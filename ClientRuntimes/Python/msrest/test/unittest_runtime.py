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
import httpretty
try:
    from http.server import(
        HTTPServer,
        BaseHTTPRequestHandler)
except ImportError:
    from BaseHTTPServer import HTTPServer
    from BaseHTTPServer import BaseHTTPRequestHandler
import os
import requests
import re
import unittest
try:
    from unittest import mock
except ImportError:
    import mock

from msrest.authentication import (
    Authentication,
    OAuthTokenAuthentication)
from msrest.pipeline import (
    ClientHTTPAdapter,
    ClientPipelineHook,
    ClientRequest)
from msrest import (
    ServiceClient,
    Configuration)
from msrest.exceptions import (
    TokenExpiredError,
    ClientRequestError)


class TestRuntime(unittest.TestCase):

    @httpretty.activate
    def test_credential_headers(self):
        
        httpretty.register_uri(httpretty.GET, "https://my_service.com/get_endpoint",
                           body='[{"title": "Test Data"}]',
                           content_type="application/json")

        token = {
            'access_token': 'eswfld123kjhn1v5423',
            'refresh_token': 'asdfkljh23490sdf',
            'token_type': 'Bearer',
            'expires_in': '3600',
        }

        creds = OAuthTokenAuthentication("client_id", token)
        cfg = Configuration("https://my_service.com")

        client = ServiceClient(creds, cfg)

        def hook(aptr, req, *args, **kwargs):
            self.assertTrue('Authorization' in req.headers)
            self.assertEqual(req.headers['Authorization'], 'Bearer eswfld123kjhn1v5423')
        
        client.add_hook('request', hook)
        url = client.format_url("/get_endpoint")
        request = client.get(url, {'check':True})
        response = client.send(request)
        check = httpretty.last_request()
        self.assertEqual(response.json(), [{"title": "Test Data"}])

        token['expires_in'] = '-30'
        creds = OAuthTokenAuthentication("client_id", token)
        client = ServiceClient(creds, cfg)
        url = client.format_url("/get_endpoint")
        request = client.get(url, {'check':True})

        with self.assertRaises(TokenExpiredError):
            response = client.send(request)

    @mock.patch.object(requests, 'Session')
    def test_request_fail(self, mock_requests):

        mock_requests.return_value.request.return_value = mock.Mock(_content_consumed=True)

        cfg = Configuration("https://my_service.com")
        creds = Authentication()

        client = ServiceClient(creds, cfg)
        url = client.format_url("/get_endpoint")
        request = client.get(url, {'check':True})
        response = client.send(request)

        check = httpretty.last_request()

        self.assertTrue(response._content_consumed)

        mock_requests.return_value.request.side_effect = requests.RequestException
        with self.assertRaises(ClientRequestError):
            client.send(request)

    def test_request_proxy(self):

        cfg = Configuration("http://my_service.com")
        cfg.proxies.add("http://my_service.com", 'http://localhost:57979')
        creds = Authentication()

        def hook(adptr, request, *args, **kwargs):
            self.assertEqual(kwargs.get('proxies'), {"http://my_service.com":'http://localhost:57979'})
            kwargs['result']._content_consumed = True
            kwargs['result'].status_code = 200
            return kwargs['result']

        client = ServiceClient(creds, cfg)
        client.add_hook('request', hook, precall=False, overwrite=True)
        url = client.format_url("/get_endpoint")
        request = client.get(url, {'check':True})
        response = client.send(request)

        os.environ['HTTPS_PROXY'] = "http://localhost:1987"

        def hook2(adptr, request, *args, **kwargs):
            self.assertEqual(kwargs.get('proxies')['https'], "http://localhost:1987")
            kwargs['result']._content_consumed = True
            kwargs['result'].status_code = 200
            return kwargs['result']

        cfg = Configuration("http://my_service.com")
        client = ServiceClient(creds, cfg)
        client.add_hook('request', hook2, precall=False, overwrite=True)
        url = client.format_url("/get_endpoint")
        request = client.get(url, {'check':True})
        response = client.send(request)

        del os.environ['HTTPS_PROXY']


class TestRedirect(unittest.TestCase):

    def setUp(self):

        cfg = Configuration("https://my_service.com")
        cfg.retry_policy.backoff_factor=0
        cfg.redirect_policy.max_redirects=2
        creds = Authentication()

        self.client = ServiceClient(creds, cfg)

        return super(TestRedirect, self).setUp()

    @httpretty.activate
    def test_request_redirect_post(self):

        url = self.client.format_url("/get_endpoint")
        request = self.client.post(url, {'check':True})

        httpretty.register_uri(httpretty.GET, 'https://my_service.com/http/success/get/200', status=200)
        httpretty.register_uri(httpretty.POST, "https://my_service.com/get_endpoint",
                                responses=[
                                httpretty.Response(body="", status=303, method='POST', location='/http/success/get/200'),
                                ])
        
        
        response = self.client.send(request)
        self.assertEqual(response.status_code, 200, msg="Should redirect with GET on 303 with location header")
        self.assertEqual(response.request.method, 'GET')

        self.assertEqual(response.history[0].status_code, 303)
        self.assertTrue(response.history[0].is_redirect)

        httpretty.reset()
        httpretty.register_uri(httpretty.POST, "https://my_service.com/get_endpoint",
                                responses=[
                                httpretty.Response(body="", status=303, method='POST'),
                                ])

        response = self.client.send(request)
        self.assertEqual(response.status_code, 303, msg="Should not redirect on 303 without location header")
        self.assertEqual(response.history, [])
        self.assertFalse(response.is_redirect)

    @httpretty.activate
    def test_request_redirect_head(self):

        url = self.client.format_url("/get_endpoint")
        request = self.client.head(url, {'check':True})

        httpretty.register_uri(httpretty.HEAD, 'https://my_service.com/http/success/200', status=200)
        httpretty.register_uri(httpretty.HEAD, "https://my_service.com/get_endpoint",
                                responses=[
                                httpretty.Response(body="", status=307, method='HEAD', location='/http/success/200'),
                                ])
        
        
        response = self.client.send(request)
        self.assertEqual(response.status_code, 200, msg="Should redirect on 307 with location header")
        self.assertEqual(response.request.method, 'HEAD')

        self.assertEqual(response.history[0].status_code, 307)
        self.assertTrue(response.history[0].is_redirect)

        httpretty.reset()
        httpretty.register_uri(httpretty.HEAD, "https://my_service.com/get_endpoint",
                                responses=[
                                httpretty.Response(body="", status=307, method='HEAD'),
                                ])

        response = self.client.send(request)
        self.assertEqual(response.status_code, 307, msg="Should not redirect on 307 without location header")
        self.assertEqual(response.history, [])
        self.assertFalse(response.is_redirect)

    @httpretty.activate
    def test_request_redirect_delete(self):

        url = self.client.format_url("/get_endpoint")
        request = self.client.delete(url, {'check':True})

        httpretty.register_uri(httpretty.DELETE, 'https://my_service.com/http/success/200', status=200)
        httpretty.register_uri(httpretty.DELETE, "https://my_service.com/get_endpoint",
                                responses=[
                                httpretty.Response(body="", status=307, method='DELETE', location='/http/success/200'),
                                ])
        
        
        response = self.client.send(request)
        self.assertEqual(response.status_code, 200, msg="Should redirect on 307 with location header")
        self.assertEqual(response.request.method, 'DELETE')

        self.assertEqual(response.history[0].status_code, 307)
        self.assertTrue(response.history[0].is_redirect)

        httpretty.reset()
        httpretty.register_uri(httpretty.DELETE, "https://my_service.com/get_endpoint",
                                responses=[
                                httpretty.Response(body="", status=307, method='DELETE'),
                                ])

        response = self.client.send(request)
        self.assertEqual(response.status_code, 307, msg="Should not redirect on 307 without location header")
        self.assertEqual(response.history, [])
        self.assertFalse(response.is_redirect)

    @httpretty.activate
    def test_request_redirect_put(self):

        url = self.client.format_url("/get_endpoint")
        request = self.client.put(url, {'check':True})

        httpretty.register_uri(httpretty.PUT, "https://my_service.com/get_endpoint",
                                responses=[
                                httpretty.Response(body="", status=305, method='PUT', location='/http/success/200'),
                                ])

        response = self.client.send(request)
        self.assertEqual(response.status_code, 305, msg="Should not redirect on 305")
        self.assertEqual(response.history, [])
        self.assertFalse(response.is_redirect)

    @httpretty.activate
    def test_request_redirect_get(self):

        url = self.client.format_url("/get_endpoint")
        request = self.client.get(url, {'check':True})

        httpretty.register_uri(httpretty.GET, "https://my_service.com/http/finished",
                        responses=[
                        httpretty.Response(body="", status=200, method='GET'),
                        ])

        httpretty.register_uri(httpretty.GET, "https://my_service.com/http/redirect3",
                        responses=[
                        httpretty.Response(body="", status=307, method='GET', location='/http/finished'),
                        ])

        httpretty.register_uri(httpretty.GET, "https://my_service.com/http/redirect2",
                        responses=[
                        httpretty.Response(body="", status=307, method='GET', location='/http/redirect3'),
                        ])

        httpretty.register_uri(httpretty.GET, "https://my_service.com/http/redirect1",
                        responses=[
                        httpretty.Response(body="", status=307, method='GET', location='/http/redirect2'),
                        ])

        httpretty.register_uri(httpretty.GET, "https://my_service.com/get_endpoint",
                        responses=[
                        httpretty.Response(body="", status=307, method='GET', location='/http/redirect1'),
                        ])

        with self.assertRaises(ClientRequestError, msg="Should exceed maximum redirects"):
            response = self.client.send(request)



class TestRuntimeRetry(unittest.TestCase):

    def setUp(self):
        cfg = Configuration("https://my_service.com")
        cfg.retry_policy.backoff_factor=0
        creds = Authentication()

        self.client = ServiceClient(creds, cfg)
        url = self.client.format_url("/get_endpoint")
        self.request = self.client.get(url, {'check':True})
        return super(TestRuntimeRetry, self).setUp()

    @httpretty.activate
    def test_request_retry_502(self):

        httpretty.register_uri(httpretty.GET, "https://my_service.com/get_endpoint",
                                responses=[
                                httpretty.Response(body="retry response", status=502),
                                httpretty.Response(body='success response', status=202),
                                ])
        
        
        response = self.client.send(self.request)
        self.assertEqual(response.status_code, 202, msg="Should retry on 502")

    @httpretty.activate
    def test_request_retry_408(self):
        httpretty.register_uri(httpretty.GET, "https://my_service.com/get_endpoint",
                                responses=[
                                httpretty.Response(body="retry response", status=408),
                                httpretty.Response(body='success response', status=202),
                                ])
        response = self.client.send(self.request)
        self.assertEqual(response.status_code, 202, msg="Should retry on 408")

    @httpretty.activate
    def test_request_retry_3_times(self):
        httpretty.register_uri(httpretty.GET, "https://my_service.com/get_endpoint",
                                responses=[
                                httpretty.Response(body="retry response", status=502),
                                httpretty.Response(body="retry response", status=502),
                                httpretty.Response(body="retry response", status=502),
                                httpretty.Response(body='success response', status=202),
                                ])

        response = self.client.send(self.request)
        self.assertEqual(response.status_code, 202, msg="Should retry 3 times")

    @httpretty.activate
    def test_request_retry_max(self):
        httpretty.register_uri(httpretty.GET, "https://my_service.com/get_endpoint",
                                responses=[
                                httpretty.Response(body="retry response", status=502),
                                httpretty.Response(body="retry response", status=502),
                                httpretty.Response(body="retry response", status=502),
                                httpretty.Response(body="retry response", status=502),
                                ])

        with self.assertRaises(ClientRequestError, msg="Max retries reached"):
            response = self.client.send(self.request)
        
    @httpretty.activate
    def test_request_retry_404(self):
        httpretty.register_uri(httpretty.GET, "https://my_service.com/get_endpoint",
                           responses=[
                                httpretty.Response(body="retry response", status=404),
                                httpretty.Response(body='success response', status=202),
                                ])

        response = self.client.send(self.request)
        self.assertEqual(response.status_code, 404, msg="Shouldn't retry on 404")

    @httpretty.activate
    def test_request_retry_501(self):
        httpretty.register_uri(httpretty.GET, "https://my_service.com/get_endpoint",
                           responses=[
                                httpretty.Response(body="retry response", status=501),
                                httpretty.Response(body='success response', status=202),
                                ])

        response = self.client.send(self.request)
        self.assertEqual(response.status_code, 501, msg="Shouldn't retry on 501")

    @httpretty.activate
    def test_request_retry_505(self):
        httpretty.register_uri(httpretty.GET, "https://my_service.com/get_endpoint",
                           responses=[
                                httpretty.Response(body="retry response", status=505),
                                httpretty.Response(body='success response', status=202),
                                ])

        response = self.client.send(self.request)
        self.assertEqual(response.status_code, 505, msg="Shouldn't retry on 505")

        
if __name__ == '__main__':
    unittest.main()