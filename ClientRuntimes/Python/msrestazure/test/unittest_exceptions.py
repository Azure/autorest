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

import unittest

from requests import Response

from msrest import Deserializer
from msrest.exceptions import RequestException
from msrestazure.azure_exceptions import CloudException, CloudError

class TestCloudException(unittest.TestCase):

    def setUp(self):
        self._d = Deserializer()
        self._d.dependencies = {'CloudException': CloudException}
        return super(TestCloudException, self).setUp()

    def test_cloud_exception(self):

        message = {
            'code': '500',
            'message': 'Bad Request',
            'values': {'invalid_attribute':'data'}
            }

        cloud_exp = self._d('CloudException', message)
        self.assertEqual(cloud_exp.message, 'Bad Request')
        self.assertEqual(cloud_exp.error, '500')
        self.assertEqual(cloud_exp.data['invalid_attribute'], 'data')

        message = {
            'code': '500',
            'message': {'value': 'Bad Request\nRequest:34875\nTime:1999-12-31T23:59:59-23:59'},
            'values': {'invalid_attribute':'data'}
            }

        cloud_exp = self._d('CloudException', message)
        self.assertEqual(cloud_exp.message, 'Bad Request')
        self.assertEqual(cloud_exp.error, '500')
        self.assertEqual(cloud_exp.data['invalid_attribute'], 'data')

        message = {
            'code': '500',
            'message': {'value': 'Bad Request\nRequest:34875'},
            'values': {'invalid_attribute':'data'}
            }

        cloud_exp = self._d('CloudException', message)
        self.assertEqual(cloud_exp.message, {'value': 'Bad Request\nRequest:34875'})
        self.assertEqual(cloud_exp.error, '500')
        self.assertEqual(cloud_exp.data['invalid_attribute'], 'data')

        message = {}
        cloud_exp = self._d('CloudException', message)
        self.assertEqual(cloud_exp.message, None)
        self.assertEqual(cloud_exp.error, None)

    def test_cloud_error(self):
        
        response = mock.create_autospec(Response)
        response.status_code = 400
        response.reason = 'BadRequest'

        message = {
            'code': '500',
            'message': {'value': 'Bad Request\nRequest:34875\nTime:1999-12-31T23:59:59-23:59'},
            'values': {'invalid_attribute':'data'}
            }

        response.content = json.dumps(message)
        response.json = lambda: json.loads(response.content)

        error = CloudError(response)
        self.assertEqual(error.message, 'Bad Request')
        self.assertEqual(error.status_code, 400)
        self.assertIsInstance(error.error, CloudException)

        message = { 'error': {
            'code': '500',
            'message': {'value': 'Bad Request\nRequest:34875\nTime:1999-12-31T23:59:59-23:59'},
            'values': {'invalid_attribute':'data'}
            }}

        response.content = json.dumps(message)
        error = CloudError(response)
        self.assertEqual(error.message, 'Bad Request')
        self.assertEqual(error.status_code, 400)
        self.assertIsInstance(error.error, CloudException)

        error = CloudError(response, "Request failed with bad status")
        self.assertEqual(error.message, "Request failed with bad status")
        self.assertEqual(error.status_code, 400)
        self.assertIsInstance(error.error, Response)

        response.content = "{"
        error = CloudError(response)
        self.assertEqual(error.message, "Operation failed with status: '400'. Details: none")

        response.content = json.dumps({'message':'server error'})
        error = CloudError(response)
        self.assertEqual(error.message, "server error")
        self.assertEqual(error.status_code, 400)

        response.content = "{"
        response.raise_for_status.side_effect = RequestException("FAILED!")
        error = CloudError(response)
        self.assertEqual(error.message,
                         "Operation failed with status: 'BadRequest'. Details: FAILED!")
        self.assertIsInstance(error.error, RequestException)


if __name__ == '__main__':
    unittest.main()
