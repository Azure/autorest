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


from ..msrest.authentication import Authentication, TokenAuthentication
from .azure_configuration import AzureConfiguration
import requests_oauthlib as oauth
from oauthlib.oauth2 import BackendApplicationClient, LegacyApplicationClient
from requests.auth import AuthBase
import time
import keyring
import ast
import base64
import hmac
import hashlib

try:
    from urlparse import urlparse, parse_qs

except ImportError:
    from urllib.parse import urlparse, parse_qs

def _http(base_uri, *extra):

    parts = [str(e).strip('/') for e in extra]
    str_parts = '/'.join(parts)
    str_base = str(base_uri)

    if str_base.startswith("http://"):
        return "{0}/{1}".format(str_base, str_parts)

    elif str_base.startswith("https://"):
        return "{0}/{1}".format(str_base.replace("https:","http:", 1), str_parts)

    else:
        return "http://{0}/{1}".format(str_base, str_parts)

def _https(base_uri, *extra):

    parts = [str(e).strip('/') for e in extra]
    str_parts = '/'.join(parts)
    str_base = str(base_uri)

    if str_base.startswith("https://"):
        return "{0}/{1}".format(str_base, str_parts)

    elif str_base.startswith("http://"):
        return "{0}/{1}".format(str_base.replace("http:","https:", 1), str_parts)

    else:
        return "https://{0}/{1}".format(str_base, str_parts)


class AADMixin(object):

    def _configure(self, config):
        
        if not config:
            config = AzureConfiguration()

        self.auth_uri = _https(config.auth_endpoint, config.tenant, config.auth_uri)
        self.token_uri = _https(config.auth_endpoint, config.tenant, config.token_uri)
        self.verify = config.verify
        self.cred_store = config.keyring
        
        self.state = state = oauth.oauth2_session.generate_token()

    def _check_state(response):

        state_key = '&state='
        state_idx = response.find(state_key)
        if state_idx < 0:
            return False

        strt_idx = state_idx + len(state_key)
        end_idx = response.find('&', strt_idx)
        state_val = response[strt_idx:end_idx]

        return state_val == self.state

    def _store_token(self, token):

        self.token = token
        keyring.set_password(self.cred_store, self.id, str(token))

    def _retrieve_stored_token(self):

        token = keyring.get_password(self.cred_store, self.id)

        if token is None:
            raise Exception() #TODO

        else:
            return ast.literal_eval(str(token))

    def _clear_token(self):

        try:
            keyring.delete_password(self.cred_store, self.id)

        except:
            raise


class UserPassCredentials(TokenAuthentication, AADMixin):
    

    def __init__(self, client_id, username, password, secret=None, config=None):

        super(InteractiveAuth, self).__init__(client_id, None)
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
                                        username=self.username, password=self.password,
                                        **optional)

        except:
            raise

        self.token = token
        return token


class ServicePrincipalCredentials(TokenAuthentication, AADMixin):
    
    def __init__(self, client_id, secret, resource, tenant=None, config=None):

        if not config:
            config = AzureConfiguration()

        if tenant:
            config.tenant = tenant

        super(InteractiveAuth, self).__init__(client_id, None)
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

        super(InteractiveAuth, self).__init__(client_id, None)
        self._configure(config)

        self.resource = resource
        self.redirect = redirect

    def _setup_session(self):
        return oauth.OAuth2Session(self.id, redirect_uri=self.redirect,
                                               state=self.state)

    def retrieve_session(self):

        try:
            self.token = self._retrieve_stored_token()
            self.signed_session()
            return token

        except:
            raise

    def get_auth_url(self, msa=False, **additional_args):

        if msa:
            additional_args['domain_hint'] = 'live.com'

        session = self._setup_session()
        auth_url, state = session.authorization_url(self.auth_uri, resource=self.resource, **additional_args)
        return auth_url, state

    def get_token(self, response_url):

        if not self._check_state(response_url):
            raise Exception() #TODO

        session = self._setup_session()

        if response_url.startswith(_http(self.redirect)):
            response_url = _https(response_url)

        elif not response_url.startswith(_https(self.redirect)):
            response_url = _https(self.redirect) + response_url

        try:
            token = session.fetch_token(self.token_uri,
                                        authorization_response=response_url,
                                        verify=self.verify)

        except oauth2.rfc6749.errors.InvalidGrantError as excp:
            raise

        except oauth2.rfc6749.errors.OAuth2Error as excp:
            raise

        except oauth2.rfc6749.errors.MismatchingStateError as excep:
            raise

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
                token_updater=self._store_auth)

            return new_session


        except oauth2.rfc6749.errors.TokenExpiredError as err:
            #TODO: Error handling
            raise


class SharedKeyAuth(AuthBase):

    def __init__(self, header, account_name, key):
        self._header = header
        self._account_name = account_name
        self._key = key

    def __call__(self, request):

        url = urlparse(request.url);
        uri_path = url.path;

        # method to sign
        string_to_sign = request.method + '\n'

        # get headers to sign
        headers_to_sign = [
            'content-encoding', 'content-language', 'content-length',
            'content-md5', 'content-type', 'date', 'if-modified-since',
            'if-match', 'if-none-match', 'if-unmodified-since', 'range']

        request_header_dict = dict((name.lower(), value)
                                   for name, value in request.headers.iteritems() if value)
        string_to_sign += '\n'.join(request_header_dict.get(x, '')
                                    for x in headers_to_sign) + '\n'

        # get ocp- header to sign
        ocp_headers = []
        for name, value in request.headers.iteritems():
            if 'ocp-' in name:
                ocp_headers.append((name.lower(), value))
        ocp_headers.sort()
        for name, value in ocp_headers:
            if value:
                string_to_sign += ''.join([name, ':', value, '\n'])

        # get account_name and uri path to sign
        string_to_sign += '/' + self._account_name + uri_path

        # get query string to sign if it is not table service
        query_to_sign = parse_qs(url.query)

        for name in sorted(query_to_sign.iterkeys()):
            if query_to_sign[name][0]:
                string_to_sign += '\n' + name + ':' + query_to_sign[name][0]

        # sign the request
        auth_string = 'SharedKey ' + self._account_name + ':' + \
            self._sign_string(string_to_sign)

        request.headers[self._header] = auth_string

        return request

    def _sign_string(self, string_to_sign):
        if isinstance(self._key, unicode):
            self._key = self._key.encode('utf-8')

        key = base64.b64decode(self._key)
        if isinstance(string_to_sign, unicode):
            string_to_sign = string_to_sign.encode('utf-8')

        signed_hmac_sha256 = hmac.HMAC(key, string_to_sign, hashlib.sha256)
        digest = signed_hmac_sha256.digest()

        return base64.b64encode(digest)

class SharedKeyCredentials(Authentication):

    def __init__(self, account_name, key):
        super(SharedKeyCredentials, self).__init__()
        self.auth = SharedKeyAuth(self.header, account_name, key)
    
    def signed_session(self):

        session = super(SharedKeyCredentials, self).signed_session()
        session.auth = self.auth

        return session



