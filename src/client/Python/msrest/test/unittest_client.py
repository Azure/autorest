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

import io
import json
import unittest
try:
    from unittest import mock
except ImportError:
    import mock

import requests
from oauthlib import oauth2

from msrest import ServiceClient
from msrest.authentication import OAuthTokenAuthentication
from msrest.pipeline import (
    ClientHTTPAdapter,
    ClientPipelineHook,
    ClientRequest)

from msrest import Configuration
from msrest.exceptions import ClientRequestError, TokenExpiredError
from msrest.pipeline import ClientRequest


class TestServiceClient(unittest.TestCase):

    def setUp(self):
        self.cfg = Configuration("https://my_endpoint.com")
        self.creds = mock.create_autospec(OAuthTokenAuthentication)
        return super(TestServiceClient, self).setUp()

    def test_client_request(self):

        client = ServiceClient(self.creds, self.cfg)
        obj = client.get()
        self.assertEqual(obj.method, 'GET')
        self.assertIsNone(obj.url)
        self.assertEqual(obj.params, {})

        obj = client.get("/service", {'param':"testing"})
        self.assertEqual(obj.method, 'GET')
        self.assertEqual(obj.url, "https://my_endpoint.com/service?param=testing")
        self.assertEqual(obj.params, {})

        obj = client.get("service 2")
        self.assertEqual(obj.method, 'GET')
        self.assertEqual(obj.url, "https://my_endpoint.com/service 2")

        self.cfg.base_url = "https://my_endpoint.com/"
        obj = client.get("//service3")
        self.assertEqual(obj.method, 'GET')
        self.assertEqual(obj.url, "https://my_endpoint.com/service3")

        obj = client.put()
        self.assertEqual(obj.method, 'PUT')

        obj = client.post()
        self.assertEqual(obj.method, 'POST')

        obj = client.head()
        self.assertEqual(obj.method, 'HEAD')

        obj = client.merge()
        self.assertEqual(obj.method, 'MERGE')

        obj = client.patch()
        self.assertEqual(obj.method, 'PATCH')

        obj = client.delete()
        self.assertEqual(obj.method, 'DELETE')

    def test_client_header(self):
        client = ServiceClient(self.creds, self.cfg)
        client.add_header("test", "value")

        self.assertEqual(client._headers.get('test'), 'value')

    def test_client_add_hook(self):

        client = ServiceClient(self.creds, self.cfg)

        def hook():
            pass
        
        client.add_hook("request", hook)
        self.assertTrue(hook in client._adapter._client_hooks['request'].precalls)

        client.add_hook("request", hook, precall=False)
        self.assertTrue(hook in client._adapter._client_hooks['request'].postcalls)

        client.remove_hook("request", hook)
        self.assertFalse(hook in client._adapter._client_hooks['request'].precalls)
        self.assertFalse(hook in client._adapter._client_hooks['request'].postcalls)

    def test_format_url(self):

        url = "/bool/test true"

        mock_client = mock.create_autospec(ServiceClient)
        mock_client.config = mock.Mock(base_url="http://localhost:3000")

        formatted = ServiceClient.format_url(mock_client, url)
        self.assertEqual(formatted, "http://localhost:3000/bool/test true")

        mock_client.config = mock.Mock(base_url="http://localhost:3000/")
        formatted = ServiceClient.format_url(mock_client, url, foo=123, bar="value")
        self.assertEqual(formatted, "http://localhost:3000/bool/test true")

        url = "https://absolute_url.com/my/test/path"
        formatted = ServiceClient.format_url(mock_client, url)
        self.assertEqual(formatted, "https://absolute_url.com/my/test/path")
        formatted = ServiceClient.format_url(mock_client, url, foo=123, bar="value")
        self.assertEqual(formatted, "https://absolute_url.com/my/test/path")

        url = "test"
        formatted = ServiceClient.format_url(mock_client, url)
        self.assertEqual(formatted, "http://localhost:3000/test")

        mock_client.config = mock.Mock(base_url="http://{hostname}:{port}/{foo}/{bar}")
        formatted = ServiceClient.format_url(mock_client, url, hostname="localhost", port="3000", foo=123, bar="value")
        self.assertEqual(formatted, "http://localhost:3000/123/value/test")

        mock_client.config = mock.Mock(base_url="https://my_endpoint.com/")
        formatted = ServiceClient.format_url(mock_client, url, foo=123, bar="value")
        self.assertEqual(formatted, "https://my_endpoint.com/test")
        

    def test_client_send(self):

        mock_client = mock.create_autospec(ServiceClient)
        mock_client.config = self.cfg
        mock_client.creds = self.creds
        mock_client._configure_session.return_value = {}
        session = mock.create_autospec(requests.Session)
        mock_client.creds.signed_session.return_value = session
        mock_client.creds.refresh_session.return_value = session

        request = ClientRequest('GET')
        ServiceClient.send(mock_client, request)
        session.request.call_count = 0
        mock_client._configure_session.assert_called_with(session)
        session.request.assert_called_with('GET', None, data=[], headers={})
        session.close.assert_called_with()

        ServiceClient.send(mock_client, request, headers={'id':'1234'}, content={'Test':'Data'})
        mock_client._configure_session.assert_called_with(session)
        session.request.assert_called_with('GET', None, data='{"Test": "Data"}', headers={'Content-Length': '16', 'id':'1234'})
        self.assertEqual(session.request.call_count, 1)
        session.request.call_count = 0
        session.close.assert_called_with()

        session.request.side_effect = requests.RequestException("test")
        with self.assertRaises(ClientRequestError):
            ServiceClient.send(mock_client, request, headers={'id':'1234'}, content={'Test':'Data'}, test='value')
        mock_client._configure_session.assert_called_with(session, test='value')
        session.request.assert_called_with('GET', None, data='{"Test": "Data"}', headers={'Content-Length': '16', 'id':'1234'})
        self.assertEqual(session.request.call_count, 1)
        session.request.call_count = 0
        session.close.assert_called_with()

        session.request.side_effect = oauth2.rfc6749.errors.InvalidGrantError("test")
        with self.assertRaises(TokenExpiredError):
            ServiceClient.send(mock_client, request, headers={'id':'1234'}, content={'Test':'Data'}, test='value')
        self.assertEqual(session.request.call_count, 2)
        session.request.call_count = 0
        session.close.assert_called_with()

        session.request.side_effect = ValueError("test")
        with self.assertRaises(ValueError):
            ServiceClient.send(mock_client, request, headers={'id':'1234'}, content={'Test':'Data'}, test='value')
        session.close.assert_called_with()

    def test_client_formdata_send(self):

        mock_client = mock.create_autospec(ServiceClient)
        mock_client._format_data.return_value = "formatted"
        request = ClientRequest('GET')
        ServiceClient.send_formdata(mock_client, request)
        mock_client.send.assert_called_with(request, {}, None, files={})

        ServiceClient.send_formdata(mock_client, request, {'id':'1234'}, {'Test':'Data'})
        mock_client.send.assert_called_with(request, {'id':'1234'}, None, files={'Test':'formatted'})

        ServiceClient.send_formdata(mock_client, request, {'Content-Type':'1234'}, {'1':'1', '2':'2'})
        mock_client.send.assert_called_with(request, {}, None, files={'1':'formatted', '2':'formatted'})

    def test_format_data(self):

        mock_client = mock.create_autospec(ServiceClient)
        data = ServiceClient._format_data(mock_client, None)
        self.assertEqual(data, (None, None))

        data = ServiceClient._format_data(mock_client, "Test")
        self.assertEqual(data, (None, "Test"))

        mock_stream = mock.create_autospec(io.BytesIO)
        data = ServiceClient._format_data(mock_client, mock_stream)
        self.assertEqual(data, (None, mock_stream, "application/octet-stream"))

        mock_stream.name = "file_name"
        data = ServiceClient._format_data(mock_client, mock_stream)
        self.assertEqual(data, ("file_name", mock_stream, "application/octet-stream"))


if __name__ == '__main__':
    unittest.main()