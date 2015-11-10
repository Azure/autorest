#--------------------------------------------------------------------------
#
# Copyright (c) Microsoft Corporation. All rights reserved. 
#
# The MIT License (MIT)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the ""Software""), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
#--------------------------------------------------------------------------


from msrest.authentication import Authentication, TokenAuthentication
from msrest.exceptions import TokenExpiredError, AuthenticationError, raise_with_traceback
from .azure_configuration import AzureConfiguration

import requests_oauthlib as oauth
from oauthlib.oauth2 import BackendApplicationClient, LegacyApplicationClient
from oauthlib.oauth2.rfc6749.errors import (
    InvalidGrantError,
    MismatchingStateError,
    OAuth2Error)

import time
import keyring
import ast
import base64
import hmac
import hashlib
import re

try:
    from urlparse import urlparse, parse_qs, urlunparse

except ImportError:
    from urllib.parse import urlparse, parse_qs, urlunparse


def _build_url(uri, paths, scheme):

    path = [str(p).strip('/') for p in paths]
    combined_path = '/'.join(path)

    parsed_url = urlparse(uri)
    replaced = parsed_url._replace(scheme=scheme)

    if combined_path:
        path = '/'.join([replaced.path, combined_path])
        replaced = replaced._replace(path=path)

    return replaced.geturl()


def _http(uri, *extra):
    """
    Convert https URL to http.
    """
    return _build_url(uri, extra, 'http')


def _https(uri, *extra):
    """
    Convert http URL to https.
    """
    return _build_url(uri, extra, 'https')


class AADMixin(object):
    """
    Mixin for Authentication object.
    Provides some AAD functionality:
        - State validation
        - Token caching and retrieval
    """

    def _configure(self, config):
        """
        Configure authentication endpoint.
        """
        if not config:
            config = AzureConfiguration()

        self.auth_uri = _https(config.auth_endpoint, config.tenant, config.auth_uri)
        self.token_uri = _https(config.auth_endpoint, config.tenant, config.token_uri)
        self.verify = config.verify
        self.cred_store = config.keyring
        
        self.state = state = oauth.oauth2_session.generate_token()

    def _check_state(self, response):
        """
        Validate state returned by AAD server.
        """
        state_check = re.compile("[&?][sS][tT][aA][tT][eE]={0}&".format(self.state))
        match = state_check.search(response+'&')

        return bool(match)

    def _store_token(self, token):
        """
        Store token for future sessions.
        """
        self.token = token
        keyring.set_password(self.cred_store, self.id, str(token))

    def _retrieve_stored_token(self):
        """
        Retrieve stored token for new session.
        """
        token = keyring.get_password(self.cred_store, self.id)

        if token is None:
            raise ValueError("No stored token found.")

        else:
            return ast.literal_eval(str(token))

    def _clear_token(self):
        """
        Clear any stored tokens.
        """
        try:
            keyring.delete_password(self.cred_store, self.id)

        except keyring.errors.PasswordDeleteError:
            raise_with_traceback(KeyError, "Unable to clear password.")


class UserPassCredentials(TokenAuthentication, AADMixin):
    

    def __init__(self, client_id, username, password, 
                 secret=None, config=None):

        super(UserPassCredentials, self).__init__(client_id, None)
        self._configure(config)

        self.username = username
        self.password = password
        self.secret = secret
        self.client = LegacyApplicationClient(self.id)

    def get_token(self):

        session = oauth.OAuth2Session(self.id, client=self.client)

        optional = {}
        if self.secret:
            optional['client_secret'] = self.secret

        try:
            token = session.fetch_token(self.token_uri, client_id=self.id,
                                        username=self.username,
                                        password=self.password,
                                        **optional)

        except:
            raise

        self.token = token
        return token


class ServicePrincipalCredentials(TokenAuthentication, AADMixin):
    
    def __init__(self, client_id, secret, resource,
                 tenant=None, config=None):

        if not config:
            config = AzureConfiguration()

        if tenant:
            config.tenant = tenant

        super(ServicePrincipalCredentials, self).__init__(client_id, None)
        self._configure(config)

        self.secret = secret
        self.resource = resource
        self.client = BackendApplicationClient(self.id)

    def get_token(self):

        session = oauth.OAuth2Session(self.id, client=self.client)
        
        try:
            token = session.fetch_token(self.token_uri, client_id=self.id,
                                        resource=self.resource,
                                        client_secret=self.secret,
                                        response_type="client_credentials",
                                        verify=self.verify)

        except oauth2.rfc6749.errors.InvalidGrantError as excp:
            raise

        except oauth2.rfc6749.errors.OAuth2Error as excp:
            raise

        self.token = token
        return token



class InteractiveCredentials(TokenAuthentication, AADMixin):
    
    def __init__(self, client_id, resource, redirect, config=None):
        """
        Interactive/Web AAD authentication
        """
        super(InteractiveCredentials, self).__init__(client_id, None)
        self._configure(config)

        self.resource = resource
        self.redirect = redirect

    def _setup_session(self):
        return oauth.OAuth2Session(self.id,
                                   redirect_uri=self.redirect,
                                   state=self.state)

    def retrieve_session(self):

        try:
            self.token = self._retrieve_stored_token()
            self.signed_session()
            return self.token

        except (ValueError, TokenExpiredError):
            return None

    def get_auth_url(self, msa=False, **additional_args):

        if msa:
            additional_args['domain_hint'] = 'live.com'

        session = self._setup_session()
        auth_url, state = session.authorization_url(self.auth_uri,
                                                    resource=self.resource,
                                                    **additional_args)
        return auth_url, state

    def get_token(self, response_url):

        if not self._check_state(response_url):
            raise ValueError("Invalid state returned.")

        session = self._setup_session()

        if response_url.startswith(_http(self.redirect)):
            response_url = _https(response_url)

        elif not response_url.startswith(_https(self.redirect)):
            response_url = _https(self.redirect, response_url) 

        try:
            token = session.fetch_token(self.token_uri,
                                        authorization_response=response_url,
                                        verify=self.verify)

        except (InvalidGrantError, OAuth2Error,
                MismatchingStateError) as err:

            raise_with_traceback(AuthenticationError, "", err)

        self.token = token
        return token

    def signed_session(self):
        countdown = float(self.token['expires_at']) - time.time()

        self.token['expires_in'] = countdown

        try:

            new_session = oauth.OAuth2Session(
                self.id,
                token=self.token,
                auto_refresh_url=self.token_uri,
                auto_refresh_kwargs={'client_id':self.id,
                                     'resource':self.resource},
                token_updater=self._store_token)

            return new_session


        except oauth2.rfc6749.errors.TokenExpiredError as err:
            raise_with_traceback(TokenExpiredError, "", err)



