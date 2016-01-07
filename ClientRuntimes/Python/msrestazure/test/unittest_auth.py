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

import json
import sys
import unittest
try:
    from unittest import mock
except ImportError:
    import mock

from requests_oauthlib import OAuth2Session
import oauthlib

from msrestazure import AzureConfiguration
from msrestazure import azure_active_directory
from msrestazure.azure_active_directory import (
    AADMixin,
    InteractiveCredentials,
    ServicePrincipalCredentials,
    UserPassCredentials
    )
from msrest.exceptions import (
    TokenExpiredError,
    AuthenticationError,
    )


class TestInteractiveCredentials(unittest.TestCase):

    def setUp(self):
        self.cfg = AzureConfiguration("https://my_service.com")
        return super(TestInteractiveCredentials, self).setUp()
    
    def test_http(self):

        test_uri = "http://my_service.com"
        build = azure_active_directory._http(test_uri, "path")

        self.assertEqual(build, "http://my_service.com/path")

        test_uri = "HTTPS://my_service.com"
        build = azure_active_directory._http(test_uri, "path")

        self.assertEqual(build, "http://my_service.com/path")

        test_uri = "my_service.com"
        build = azure_active_directory._http(test_uri, "path")

        self.assertEqual(build, "http://my_service.com/path")

    def test_https(self):

        test_uri = "http://my_service.com"
        build = azure_active_directory._https(test_uri, "path")

        self.assertEqual(build, "https://my_service.com/path")

        test_uri = "HTTPS://my_service.com"
        build = azure_active_directory._https(test_uri, "path")

        self.assertEqual(build, "https://my_service.com/path")

        test_uri = "my_service.com"
        build = azure_active_directory._https(test_uri, "path")

        self.assertEqual(build, "https://my_service.com/path")


    def test_check_state(self):

        mix = AADMixin()
        mix.state = "abc"

        with self.assertRaises(ValueError):
            mix._check_state("server?test")
        with self.assertRaises(ValueError):
            mix._check_state("server?test&abc")
        with self.assertRaises(ValueError):
            mix._check_state("server?test&state=xyx")
        with self.assertRaises(ValueError):
            mix._check_state("server?test&state=xyx&")
        with self.assertRaises(ValueError):
            mix._check_state("server?test&state=abcd&")
        mix._check_state("server?test&state=abc&")

    @mock.patch('msrestazure.azure_active_directory.keyring')
    def test_store_token(self, mock_keyring):

        mix = AADMixin()
        mix.cred_store = "store_name"
        mix.id = "client_id"
        mix._default_token_cache({'token_type':'1', 'access_token':'2'})

        mock_keyring.set_password.assert_called_with(
            "store_name", "client_id",
            str({'token_type':'1', 'access_token':'2'}))

    @mock.patch('msrestazure.azure_active_directory.keyring')
    def test_clear_token(self, mock_keyring):

        mix = AADMixin()
        mix.cred_store = "store_name"
        mix.id = "client_id"
        mix.clear_cached_token()

        mock_keyring.delete_password.assert_called_with(
            "store_name", "client_id")

    @mock.patch('msrestazure.azure_active_directory.keyring')
    def test_credentials_get_stored_auth(self, mock_keyring):

        mix = AADMixin()
        mix.cred_store = "store_name"
        mix.id = "client_id"

        mock_keyring.get_password.return_value = None

        with self.assertRaises(ValueError):
            mix._retrieve_stored_token()

        mock_keyring.get_password.assert_called_with(
            "store_name", "client_id")

        mock_keyring.get_password.return_value = str(
            {'token_type':'1', 'access_token':'2'})

        mix._retrieve_stored_token()
        mock_keyring.get_password.assert_called_with("store_name", "client_id")

    def test_credentials_retrieve_session(self):

        creds = mock.create_autospec(InteractiveCredentials)
        creds._retrieve_stored_token.return_value = {
            'expires_at':'1',
            'expires_in':'2',
            'refresh_token':"test"}

        token = InteractiveCredentials.retrieve_session(creds)
        self.assertEqual(token, creds._retrieve_stored_token.return_value)

        creds._retrieve_stored_token.side_effect=ValueError("No stored token")
        self.assertIsNone(InteractiveCredentials.retrieve_session(creds))

        creds._retrieve_stored_token.side_effect=None
        creds.signed_session.side_effect=TokenExpiredError("Token expired")
        self.assertIsNone(InteractiveCredentials.retrieve_session(creds))

    def test_credentials_auth_url(self):

        creds = mock.create_autospec(InteractiveCredentials)
        session = mock.create_autospec(OAuth2Session)
        creds._setup_session.return_value = session
        creds.auth_uri = "auth_uri"
        creds.resource = "auth_resource"
        session.authorization_url.return_value = ("a","b")

        url, state = InteractiveCredentials.get_auth_url(creds)
        self.assertEqual(url, "a")
        self.assertEqual(state, "b")
        session.authorization_url.assert_called_with(
            "auth_uri", resource="auth_resource")

        InteractiveCredentials.get_auth_url(creds, msa=True, test="extra_arg")
        session.authorization_url.assert_called_with(
            "auth_uri", resource="auth_resource",
            domain_hint='live.com', test='extra_arg')

    def test_credentials_get_token(self):

        creds = mock.create_autospec(InteractiveCredentials)
        session = mock.create_autospec(OAuth2Session)
        creds._setup_session.return_value = session

        session.fetch_token.return_value = {
            'expires_at':'1',
            'expires_in':'2',
            'refresh_token':"test"}

        creds.redirect = "//my_service.com"
        creds.token_uri = "token_uri"
        creds._check_state.return_value = True
        creds.verify = True

        InteractiveCredentials.get_token(creds, "response")
        self.assertEqual(creds.token, session.fetch_token.return_value)
        session.fetch_token.assert_called_with(
            "token_uri",
            authorization_response="https://my_service.com/response",
            verify=True)

        creds._check_state.side_effect = ValueError("failed")
        with self.assertRaises(ValueError):
            InteractiveCredentials.get_token(creds, "response")

        creds._check_state.side_effect = None
        session.fetch_token.side_effect = oauthlib.oauth2.OAuth2Error
        with self.assertRaises(AuthenticationError):
            InteractiveCredentials.get_token(creds, "response")

    @mock.patch('msrestazure.azure_active_directory.oauth')
    def test_credentials_signed_session(self, mock_requests):

        creds = mock.create_autospec(InteractiveCredentials)
        creds.id = 'client_id'
        creds.token_uri = "token_uri"
        creds.resource = "resource"

        creds.token = {'expires_at':'1',
                       'expires_in':'2',
                       'refresh_token':"test"}

        InteractiveCredentials.signed_session(creds)
        mock_requests.OAuth2Session.assert_called_with(
            'client_id',
            token=creds.token,
            auto_refresh_url='token_uri',
            auto_refresh_kwargs={'client_id':'client_id', 'resource':'resource'},
            token_updater=creds._default_token_cache)

    def test_service_principal(self):

        creds = mock.create_autospec(ServicePrincipalCredentials)
        session = mock.create_autospec(OAuth2Session)
        creds._setup_session.return_value = session

        session.fetch_token.return_value = {
            'expires_at':'1',
            'expires_in':'2'}

        creds.token_uri = "token_uri"
        creds.verify = True
        creds.id = 123
        creds.secret = 'secret'
        creds.resource = 'resource'

        ServicePrincipalCredentials.get_token(creds)
        self.assertEqual(creds.token, session.fetch_token.return_value)
        session.fetch_token.assert_called_with(
            "token_uri", client_id=123, client_secret='secret',
            resource='resource', response_type="client_credentials",
            verify=True)

        session.fetch_token.side_effect = oauthlib.oauth2.OAuth2Error

        with self.assertRaises(AuthenticationError):
            ServicePrincipalCredentials.get_token(creds)

        session = mock.create_autospec(OAuth2Session)
        with mock.patch.object(
            ServicePrincipalCredentials, '_setup_session', return_value=session):
            
            creds = ServicePrincipalCredentials("client_id", "secret", 
                                                verify=False, tenant="private")

            session.fetch_token.assert_called_with(
                "https://login.microsoftonline.com/private/oauth2/token",
                client_id="client_id", client_secret='secret',
                resource='https://management.core.windows.net/',
                response_type="client_credentials", verify=False)

        with mock.patch.object(
            ServicePrincipalCredentials, '_setup_session', return_value=session):
            
            creds = ServicePrincipalCredentials("client_id", "secret", china=True,
                                                verify=False, tenant="private")

            session.fetch_token.assert_called_with(
                "https://login.chinacloudapi.cn/private/oauth2/token",
                client_id="client_id", client_secret='secret',
                resource='https://management.core.chinacloudapi.cn/',
                response_type="client_credentials", verify=False)

    def test_user_pass_credentials(self):

        creds = mock.create_autospec(UserPassCredentials)
        session = mock.create_autospec(OAuth2Session)
        creds._setup_session.return_value = session

        session.fetch_token.return_value = {
            'expires_at':'1',
            'expires_in':'2'}

        creds.token_uri = "token_uri"
        creds.verify = True
        creds.username = "user"
        creds.password = 'pass'
        creds.secret = 'secret'
        creds.resource = 'resource'
        creds.id = "id"

        UserPassCredentials.get_token(creds)
        self.assertEqual(creds.token, session.fetch_token.return_value)
        session.fetch_token.assert_called_with(
            "token_uri", client_id="id", username='user',
            client_secret="secret", password='pass', resource='resource')

        session.fetch_token.side_effect = oauthlib.oauth2.OAuth2Error

        with self.assertRaises(AuthenticationError):
            UserPassCredentials.get_token(creds)

        session = mock.create_autospec(OAuth2Session)
        with mock.patch.object(
            UserPassCredentials, '_setup_session', return_value=session):
            
            creds = UserPassCredentials("my_username", "my_password", 
                                        verify=False, tenant="private", resource='resource')

            session.fetch_token.assert_called_with(
                "https://login.microsoftonline.com/private/oauth2/token",
                client_id='04b07795-8ddb-461a-bbee-02f9e1bf7b46', username='my_username',
                password='my_password', resource='resource')

        with mock.patch.object(
            UserPassCredentials, '_setup_session', return_value=session):
            
            creds = UserPassCredentials("my_username", "my_password", client_id="client_id",
                                        verify=False, tenant="private", china=True)

            session.fetch_token.assert_called_with(
                "https://login.chinacloudapi.cn/private/oauth2/token",
                client_id="client_id", username='my_username',
                password='my_password', resource='https://management.core.chinacloudapi.cn/')


if __name__ == '__main__':
    unittest.main()