# --------------------------------------------------------------------------
#
# Copyright (c) Microsoft Corporation. All rights reserved.
#
# The MIT License (MIT)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the ""Software""), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#
# --------------------------------------------------------------------------

import ast
import re
import time
try:
    from urlparse import urlparse, parse_qs
except ImportError:
    from urllib.parse import urlparse, parse_qs

import keyring
from oauthlib.oauth2 import BackendApplicationClient, LegacyApplicationClient
from oauthlib.oauth2.rfc6749.errors import (
    InvalidGrantError,
    MismatchingStateError,
    OAuth2Error,
    TokenExpiredError)
from requests import RequestException
import requests_oauthlib as oauth

from msrest.authentication import OAuthTokenAuthentication
from msrest.exceptions import TokenExpiredError as Expired
from msrest.exceptions import (
    AuthenticationError,
    raise_with_traceback)


def _build_url(uri, paths, scheme):
    """Combine URL parts.

    :param str uri: The base URL.
    :param list paths: List of strings that make up the URL.
    :param str scheme: The URL scheme, 'http' or 'https'.
    :rtype: str
    :return: Combined, formatted URL.
    """
    path = [str(p).strip('/') for p in paths]
    combined_path = '/'.join(path)
    parsed_url = urlparse(uri)
    replaced = parsed_url._replace(scheme=scheme)
    if combined_path:
        path = '/'.join([replaced.path, combined_path])
        replaced = replaced._replace(path=path)

    new_url = replaced.geturl()
    new_url = new_url.replace('///', '//')
    return new_url


def _http(uri, *extra):
    """Convert https URL to http.

    :param str uri: The base URL.
    :param str extra: Additional URL paths (optional).
    :rtype: str
    :return: An HTTP URL.
    """
    return _build_url(uri, extra, 'http')


def _https(uri, *extra):
    """Convert http URL to https.

    :param str uri: The base URL.
    :param str extra: Additional URL paths (optional).
    :rtype: str
    :return: An HTTPS URL.
    """
    return _build_url(uri, extra, 'https')


class AADMixin(OAuthTokenAuthentication):
    """Mixin for Authentication object.
    Provides some AAD functionality:
    - State validation
    - Token caching and retrieval
    - Default AAD configuration
    """
    _auth_endpoint = "//login.microsoftonline.com"
    _china_auth_endpoint = "//login.chinacloudapi.cn"
    _token_uri = "/oauth2/token"
    _auth_uri = "/oauth2/authorize"
    _tenant = "common"
    _resource = 'https://management.core.windows.net/'
    _china_resource = "https://management.core.chinacloudapi.cn/"
    _keyring = "AzureAAD"
    _case = re.compile('([a-z0-9])([A-Z])')

    def _configure(self, **kwargs):
        """Configure authentication endpoint.

        Optional kwargs may include:
            - china (bool): Configure auth for China-based service,
              default is 'False'.
            - tenant (str): Alternative tenant, default is 'common'.
            - auth_uri (str): Alternative authentication endpoint.
            - token_uri (str): Alternative token retrieval endpoint.
            - resource (str): Alternative authentication resource, default
              is 'https://management.core.windows.net/'.
            - verify (bool): Verify secure connection, default is 'True'.
            - keyring (str): Name of local token cache, default is 'AzureAAD'.
        """
        if kwargs.get('china'):
            auth_endpoint = self._china_auth_endpoint
            resource = self._china_resource
        else:
            auth_endpoint = self._auth_endpoint
            resource = self._resource

        tenant = kwargs.get('tenant', self._tenant)
        self.auth_uri = kwargs.get('auth_uri', _https(
            auth_endpoint, tenant, self._auth_uri))
        self.token_uri = kwargs.get('token_uri', _https(
            auth_endpoint, tenant, self._token_uri))
        self.verify = kwargs.get('verify', True)
        self.cred_store = kwargs.get('keyring', self._keyring)
        self.resource = kwargs.get('resource', resource)
        self.state = oauth.oauth2_session.generate_token()
        self.store_key = "{}_{}".format(
            self._auth_endpoint.strip('/'), self.store_key)

    def _check_state(self, response):
        """Validate state returned by AAD server.

        :param str response: URL returned by server redirect.
        :raises: ValueError if state does not match that of the request.
        :rtype: None
        """
        query = parse_qs(urlparse(response).query)
        if self.state not in query.get('state', []):
            raise ValueError(
                "State received from server does not match that of request.")

    def _convert_token(self, token):
        """Convert token fields from camel case.

        :param dict token: An authentication token.
        :rtype: dict
        """
        return {self._case.sub(r'\1_\2', k).lower(): v
                for k, v in token.items()}

    def _parse_token(self):
        # TODO: We could also check expires_on and use to update expires_in
        if self.token.get('expires_at'):
            countdown = float(self.token['expires_at']) - time.time()
            self.token['expires_in'] = countdown
        kwargs = {}
        if self.token.get('refresh_token'):
            kwargs['auto_refresh_url'] = self.token_uri
            kwargs['auto_refresh_kwargs'] = {'client_id': self.id,
                                             'resource': self.resource}
            kwargs['token_updater'] = self._default_token_cache
        return kwargs

    def _default_token_cache(self, token):
        """Store token for future sessions.

        :param dict token: An authentication token.
        :rtype: None
        """
        self.token = token
        keyring.set_password(self.cred_store, self.store_key, str(token))

    def _retrieve_stored_token(self):
        """Retrieve stored token for new session.

        :raises: ValueError if no cached token found.
        :rtype: dict
        :return: Retrieved token.
        """
        token = keyring.get_password(self.cred_store, self.store_key)
        if token is None:
            raise ValueError("No stored token found.")
        self.token = ast.literal_eval(str(token))
        self.signed_session()

    def signed_session(self):
        """Create token-friendly Requests session, using auto-refresh.
        Used internally when a request is made.

        :rtype: requests_oauthlib.OAuth2Session
        :raises: TokenExpiredError if token can no longer be refreshed.
        """
        kwargs = self._parse_token()
        try:
            new_session = oauth.OAuth2Session(
                self.id,
                token=self.token,
                **kwargs)
            return new_session
        except TokenExpiredError as err:
            raise_with_traceback(Expired, "", err)

    def clear_cached_token(self):
        """Clear any stored tokens.

        :raises: KeyError if failed to clear token.
        :rtype: None
        """
        try:
            keyring.delete_password(self.cred_store, self.store_key)
        except keyring.errors.PasswordDeleteError:
            raise_with_traceback(KeyError, "Unable to clear token.")


class AADRefreshMixin(object):
    """
    Additional token refresh logic
    """

    def refresh_session(self):
        """Return updated session if token has expired, attempts to
        refresh using newly acquired token.

        :rtype: requests.Session.
        """
        if self.token.get('refresh_token'):
            try:
                return self.signed_session()
            except Expired:
                pass
        self.set_token()
        return self.signed_session()


class AADTokenCredentials(AADMixin):
    """
    Credentials objects for AAD token retrieved through external process
    e.g. Python ADAL lib.

    Optional kwargs may include:
    - china (bool): Configure auth for China-based service,
      default is 'False'.
    - tenant (str): Alternative tenant, default is 'common'.
    - auth_uri (str): Alternative authentication endpoint.
    - token_uri (str): Alternative token retrieval endpoint.
    - resource (str): Alternative authentication resource, default
      is 'https://management.core.windows.net/'.
    - verify (bool): Verify secure connection, default is 'True'.
    - keyring (str): Name of local token cache, default is 'AzureAAD'.
    - cached (bool): If true, will not attempt to collect a token,
      which can then be populated later from a cached token.

    :param dict token: Authentication token.
    :param str client_id: Client ID, if not set, Xplat Client ID
     will be used.
    """

    def __init__(self, token, client_id=None, **kwargs):
        if not client_id:
            # Default to Xplat Client ID.
            client_id = '04b07795-8ddb-461a-bbee-02f9e1bf7b46'
        super(AADTokenCredentials, self).__init__(client_id, None)
        self._configure(**kwargs)
        if not kwargs.get('cached'):
            self.token = self._convert_token(token)
            self.signed_session()

    @classmethod
    def retrieve_session(cls, client_id=None):
        """Create AADTokenCredentials from a cached token if it has not
        yet expired.
        """
        session = cls(None, None, client_id=client_id, cached=True)
        session._retrieve_stored_token()
        return session


class UserPassCredentials(AADRefreshMixin, AADMixin):
    """Credentials object for Headless Authentication,
    i.e. AAD authentication via username and password.

    Headless Auth requires an AAD login (no a Live ID) that already has
    permission to access the resource e.g. an organization account, and
    that 2-factor auth be disabled.

    Optional kwargs may include:
    - china (bool): Configure auth for China-based service,
      default is 'False'.
    - tenant (str): Alternative tenant, default is 'common'.
    - auth_uri (str): Alternative authentication endpoint.
    - token_uri (str): Alternative token retrieval endpoint.
    - resource (str): Alternative authentication resource, default
      is 'https://management.core.windows.net/'.
    - verify (bool): Verify secure connection, default is 'True'.
    - keyring (str): Name of local token cache, default is 'AzureAAD'.
    - cached (bool): If true, will not attempt to collect a token,
      which can then be populated later from a cached token.

    :param str username: Account username.
    :param str password: Account password.
    :param str client_id: Client ID, if not set, Xplat Client ID
     will be used.
    :param str secret: Client secret, only if required by server.
    """

    def __init__(self, username, password,
                 client_id=None, secret=None, **kwargs):
        if not client_id:
            # Default to Xplat Client ID.
            client_id = '04b07795-8ddb-461a-bbee-02f9e1bf7b46'
        super(UserPassCredentials, self).__init__(client_id, None)
        self._configure(**kwargs)

        self.store_key += "_{}".format(username)
        self.username = username
        self.password = password
        self.secret = secret
        self.client = LegacyApplicationClient(client_id=self.id)
        if not kwargs.get('cached'):
            self.set_token()

    @classmethod
    def retrieve_session(cls, username, client_id=None):
        """Create ServicePrincipalCredentials from a cached token if it has not
        yet expired.
        """
        session = cls(username, None, client_id=client_id, cached=True)
        session._retrieve_stored_token()
        return session

    def _setup_session(self):
        """Create token-friendly Requests session.

        :rtype: requests_oauthlib.OAuth2Session
        """
        return oauth.OAuth2Session(client=self.client)

    def set_token(self):
        """Get token using Username/Password credentials.

        :raises: AuthenticationError if credentials invalid, or call fails.
        """
        session = self._setup_session()
        optional = {}
        if self.secret:
            optional['client_secret'] = self.secret
        try:
            token = session.fetch_token(self.token_uri, client_id=self.id,
                                        username=self.username,
                                        password=self.password,
                                        resource=self.resource,
                                        verify=self.verify,
                                        **optional)
        except (RequestException, OAuth2Error, InvalidGrantError) as err:
            raise_with_traceback(AuthenticationError, "", err)

        self.token = token


class ServicePrincipalCredentials(AADRefreshMixin, AADMixin):
    """Credentials object for Service Principle Authentication.
    Authenticates via a Client ID and Secret.

    Optional kwargs may include:
    - china (bool): Configure auth for China-based service,
      default is 'False'.
    - tenant (str): Alternative tenant, default is 'common'.
    - auth_uri (str): Alternative authentication endpoint.
    - token_uri (str): Alternative token retrieval endpoint.
    - resource (str): Alternative authentication resource, default
      is 'https://management.core.windows.net/'.
    - verify (bool): Verify secure connection, default is 'True'.
    - keyring (str): Name of local token cache, default is 'AzureAAD'.
    - cached (bool): If true, will not attempt to collect a token,
      which can then be populated later from a cached token.

    :param str client_id: Client ID.
    :param str secret: Client secret.
    """
    def __init__(self, client_id, secret, **kwargs):
        super(ServicePrincipalCredentials, self).__init__(client_id, None)
        self._configure(**kwargs)

        self.secret = secret
        self.client = BackendApplicationClient(self.id)
        if not kwargs.get('cached'):
            self.set_token()

    @classmethod
    def retrieve_session(cls, client_id):
        """Create ServicePrincipalCredentials from a cached token if it has not
        yet expired.
        """
        session = cls(client_id, None, cached=True)
        session._retrieve_stored_token()
        return session

    def _setup_session(self):
        """Create token-friendly Requests session.

        :rtype: requests_oauthlib.OAuth2Session
        """
        return oauth.OAuth2Session(self.id, client=self.client)

    def set_token(self):
        """Get token using Client ID/Secret credentials.

        :raises: AuthenticationError if credentials invalid, or call fails.
        """
        session = self._setup_session()
        try:
            token = session.fetch_token(self.token_uri, client_id=self.id,
                                        resource=self.resource,
                                        client_secret=self.secret,
                                        response_type="client_credentials",
                                        verify=self.verify)
        except (RequestException, OAuth2Error, InvalidGrantError) as err:
            raise_with_traceback(AuthenticationError, "", err)
        else:
            self.token = token


class InteractiveCredentials(AADMixin):
    """Credentials object for Interactive/Web App Authentication.
    Requires that an AAD Client be configured with a redirect URL.

    Optional kwargs may include:
    - china (bool): Configure auth for China-based service,
      default is 'False'.
    - tenant (str): Alternative tenant, default is 'common'.
    - auth_uri (str): Alternative authentication endpoint.
    - token_uri (str): Alternative token retrieval endpoint.
    - resource (str): Alternative authentication resource, default
      is 'https://management.core.windows.net/'.
    - verify (bool): Verify secure connection, default is 'True'.
    - keyring (str): Name of local token cache, default is 'AzureAAD'.
    - cached (bool): If true, will not attempt to collect a token,
      which can then be populated later from a cached token.

    :param str client_id: Client ID.
    :param str redirect: Redirect URL.
    """

    def __init__(self, client_id, redirect, **kwargs):
        super(InteractiveCredentials, self).__init__(client_id, None)
        self._configure(**kwargs)

        self.redirect = redirect
        if not kwargs.get('cached'):
            self.set_token()

    @classmethod
    def retrieve_session(cls, client_id, redirect):
        """Create InteractiveCredentials from a cached token if it has not
        yet expired.
        """
        session = cls(client_id, redirect, cached=True)
        session._retrieve_stored_token()
        return session

    def _setup_session(self):
        """Create token-friendly Requests session.

        :rtype: requests_oauthlib.OAuth2Session
        """
        return oauth.OAuth2Session(self.id,
                                   redirect_uri=self.redirect,
                                   state=self.state)

    def get_auth_url(self, msa=False, **additional_args):
        """Get URL to web portal for authentication.

        :param bool msa: Set to 'True' if authenticating with Live ID. Default
         is 'False'.
        :param additional_args: Set and additional kwargs for requrired AAD
         configuration: msdn.microsoft.com/en-us/library/azure/dn645542.aspx
        :rtype: Tuple
        :return: The URL for authentication (str), and state code that will
         be verified in the response (str).
        """
        if msa:
            additional_args['domain_hint'] = 'live.com'
        session = self._setup_session()
        auth_url, state = session.authorization_url(self.auth_uri,
                                                    resource=self.resource,
                                                    **additional_args)
        return auth_url, state

    def set_token(self, response_url):
        """Get token using Authorization Code from redirected URL.

        :param str response_url: The full redirected URL from successful
         authentication.
        :raises: AuthenticationError if credentials invalid, or call fails.
        """
        self._check_state(response_url)
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
                MismatchingStateError, RequestException) as err:
            raise_with_traceback(AuthenticationError, "", err)
        else:
            self.token = token
