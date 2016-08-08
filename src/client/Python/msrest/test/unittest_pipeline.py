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
import requests
import datetime
from enum import Enum
import unittest
try:
    from unittest import mock
except ImportError:
    import mock

from msrest.pipeline import (
    ClientHTTPAdapter,
    ClientPipelineHook,
    ClientRequest,
    ClientRawResponse)

from msrest import Configuration


class TestPipelineHooks(unittest.TestCase):

    def event_hook(event):
        def event_wrapper(func):
            def execute_hook(self, *args, **kwargs):
                return self.adp._client_hooks[event](func, self, *args, **kwargs)
            return execute_hook
        return event_wrapper

    @event_hook('request')
    def mock_send(*args, **kwargs):
        return "Not a real response"

    @event_hook('response')
    def mock_response(*args, **kwargs):
        resp = mock.MagicMock(result=200, headers={"a":1, "b":False})
        return resp

    def setUp(self):

        self.cfg = mock.create_autospec(Configuration)
        self.cfg.log_name = "test_log"
        self.adp = ClientHTTPAdapter(self.cfg)
        self.adp.send = self.mock_send
        self.adp.build_response = self.mock_response

        return super(TestPipelineHooks, self).setUp()
    
    def test_adding_hook(self):

        self.assertTrue('request' in self.adp._client_hooks)
        self.assertTrue('response' in self.adp._client_hooks)

        with self.assertRaises(TypeError):
            self.adp.add_hook('request', None)

        with self.assertRaises(TypeError):
            self.adp.add_hook('response', 'NotCallable')

        with self.assertRaises(KeyError):
            self.adp.add_hook('Something', lambda a:True)

        def hook(*args, **kwargs):
            pass

        self.adp.add_hook('request', hook)
        self.assertTrue(hook in self.adp._client_hooks['request'].precalls)
        self.assertFalse(hook in self.adp._client_hooks['request'].postcalls)

        def hook2(*args, **kwargs):
            pass

        self.adp.add_hook('response', hook2, precall=False)
        self.assertFalse(hook2 in self.adp._client_hooks['response'].precalls)
        self.assertTrue(hook2 in self.adp._client_hooks['response'].postcalls)

    def test_pre_event_callback(self):

        class TestEvent(Exception):
            pass

        def hook(*args, **kwargs):
            raise TestEvent("Entered hook function")

        self.adp.add_hook('request', hook)

        with self.assertRaises(TestEvent):
            self.adp.send("request_obj")

    def test_overwrite_event_hook(self):

        resp = self.adp.send("request_obj")
        self.assertEqual(resp, "Not a real response")

        def hook(*args, **kwargs):
            self.assertEqual(args[1], "request_obj")
            return None

        self.adp.add_hook('request', hook, precall=False, overwrite=True)
        resp = self.adp.send("request_obj")
        self.assertIsNone(resp)

    def test_post_event_callback(self):

        def hook(*args, **kwargs):
            self.assertTrue('result' in kwargs)
            self.assertEqual(kwargs['result'].result, 200)
            return kwargs['result']

        self.adp.add_hook('response', hook, precall=False)
        resp = self.adp.build_response('request_obj')
        self.assertEqual(resp.result, 200)

    def test_alter_response_callback(self):
        
        def hook(*args, **kwargs):
            kwargs['result'].headers['a'] = "Changed!"
            return kwargs['result']

        self.adp.add_hook('response', hook, precall=False)
        resp = self.adp.build_response('request_obj')
        self.assertEqual(resp.headers['a'], "Changed!")
        self.assertEqual(resp.headers['b'], False)


class TestClientRequest(unittest.TestCase):

    def test_request_headers(self):

        request = ClientRequest()
        request.add_header("a", 1)
        request.add_headers({'b':2, 'c':3})

        self.assertEqual(request.headers, {'a':1, 'b':2, 'c':3})

    def test_request_data(self):

        request = ClientRequest()
        data = "Lots of dataaaa"
        request.add_content(data)

        self.assertEqual(request.data, json.dumps(data))
        self.assertEqual(request.headers.get('Content-Length'), '17')

    def test_request_url_with_params(self):

        request = ClientRequest()
        request.url = "a/b/c?t=y"
        request.format_parameters({'g': 'h'})

        self.assertIn(request.url, [
            'a/b/c?g=h&t=y',
            'a/b/c?t=y&g=h'
        ])

class TestClientResponse(unittest.TestCase):

    class Colors(Enum):
        red = 'red'
        blue = 'blue'

    def test_raw_response(self):

        response = mock.create_autospec(requests.Response)
        response.headers = {}
        response.headers["my-test"] = '1999-12-31T23:59:59-23:59'
        response.headers["colour"] = "red"

        raw = ClientRawResponse([], response)

        raw.add_headers({'my-test': 'iso-8601',
                         'another_header': 'str',
                         'colour': TestClientResponse.Colors})
        self.assertIsInstance(raw.headers['my-test'], datetime.datetime)

if __name__ == '__main__':
    unittest.main()
