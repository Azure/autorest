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

try:
    import unittest2 as unittest
except ImportError:
    import unittest

try:
    from unittest import mock
except ImportError:
    import mock

from msrest import ServiceClient

from msrest.authentication import TokenAuthentication
from msrest.pipeline import (
    ClientHTTPAdapter,
    ClientPipelineHook,
    ClientRequest)

from msrest import Configuration


class TestServiceClient(unittest.TestCase):

    def setUp(self):
        self.cfg = mock.create_autospec(Configuration)
        self.cfg.log_name = "test_log_name"
        self.cfg.base_url = "https://my_endpoint.com"
        self.creds = mock.create_autospec(TokenAuthentication)
        return super().setUp()

    def test_client_request(self):

        client = ServiceClient(self.creds, self.cfg)
        obj = client.get()
        self.assertEqual(obj.method, 'GET')
        self.assertIsNone(obj.url)
        self.assertEqual(obj.params, {})

        obj = client.get("/service", {'param':"testing"})
        self.assertEqual(obj.method, 'GET')
        self.assertEqual(obj.url, "https://my_endpoint.com/service")
        self.assertEqual(obj.params, {'param':"testing"})

        obj = client.get("service 2")
        self.assertEqual(obj.method, 'GET')
        self.assertEqual(obj.url, "https://my_endpoint.com/service%202")

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
