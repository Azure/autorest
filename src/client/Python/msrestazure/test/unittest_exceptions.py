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
import unittest
try:
    from unittest import mock
except ImportError:
    import mock

from requests import Response

from msrest import Deserializer, Configuration
from msrest.exceptions import RequestException
from msrestazure.azure_exceptions import CloudErrorData, CloudError


class TestCloudException(unittest.TestCase):

    def setUp(self):
        self.cfg = Configuration("https://my_endpoint.com")
        self._d = Deserializer()
        self._d.dependencies = {'CloudErrorData': CloudErrorData}
        return super(TestCloudException, self).setUp()

    def test_cloud_exception(self):

        message = {
            'code': '500',
            'message': 'Bad Request',
            'values': {'invalid_attribute':'data'}
            }

        cloud_exp = self._d(CloudErrorData(), message)
        self.assertEqual(cloud_exp.message, 'Bad Request')
        self.assertEqual(cloud_exp.error, '500')
        self.assertEqual(cloud_exp.data['invalid_attribute'], 'data')

        message = {
            'code': '500',
            'message': {'value': 'Bad Request\nRequest:34875\nTime:1999-12-31T23:59:59-23:59'},
            'values': {'invalid_attribute':'data'}
            }

        cloud_exp = self._d(CloudErrorData(), message)
        self.assertEqual(cloud_exp.message, 'Bad Request')
        self.assertEqual(cloud_exp.error, '500')
        self.assertEqual(cloud_exp.data['invalid_attribute'], 'data')

        message = {
            'code': '500',
            'message': {'value': 'Bad Request\nRequest:34875'},
            'values': {'invalid_attribute':'data'}
            }

        cloud_exp = self._d(CloudErrorData(), message)
        self.assertEqual(cloud_exp.message, 'Bad Request')
        self.assertEqual(cloud_exp.request_id, '34875')
        self.assertEqual(cloud_exp.error, '500')
        self.assertEqual(cloud_exp.data['invalid_attribute'], 'data')

        message = {}
        cloud_exp = self._d(CloudErrorData(), message)
        self.assertEqual(cloud_exp.message, None)
        self.assertEqual(cloud_exp.error, None)

        message = ('{\r\n  "odata.metadata":"https://account.region.batch.azure.com/$metadata#'
                   'Microsoft.Azure.Batch.Protocol.Entities.Container.errors/@Element","code":'
                   '"InvalidHeaderValue","message":{\r\n    "lang":"en-US","value":"The value '
                   'for one of the HTTP headers is not in the correct format.\\nRequestId:5f4c1f05-'
                   '603a-4495-8e80-01f776310bbd\\nTime:2016-01-04T22:12:33.9245931Z"\r\n  },'
                   '"values":[\r\n    {\r\n      "key":"HeaderName","value":"Content-Type"\r\n    }'
                   ',{\r\n      "key":"HeaderValue","value":"application/json; odata=minimalmetadata;'
                   ' charset=utf-8"\r\n    }\r\n  ]\r\n}')
        message = json.loads(message)
        cloud_exp = self._d(CloudErrorData(), message)
        self.assertEqual(
            cloud_exp.message,
            "The value for one of the HTTP headers is not in the correct format.")

        message = {
            "code": "BadArgument",
            "message": "The provided database 'foo' has an invalid username.",
            "target": "query",
            "details": [
                {
                    "code": "301",
                    "target": "$search",
                    "message": "$search query option not supported",
                }
            ]
        }
        cloud_exp = self._d(CloudErrorData(), message)
        self.assertEqual(cloud_exp.target, 'query')
        self.assertEqual(cloud_exp.details[0].target, '$search')



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
        self.assertIsInstance(error.error, CloudErrorData)

        message = { 'error': {
            'code': '500',
            'message': {'value': 'Bad Request\nRequest:34875\nTime:1999-12-31T23:59:59-23:59'},
            'values': {'invalid_attribute':'data'}
            }}

        response.content = json.dumps(message)
        error = CloudError(response)
        self.assertEqual(error.message, 'Bad Request')
        self.assertEqual(error.status_code, 400)
        self.assertIsInstance(error.error, CloudErrorData)

        error = CloudError(response, "Request failed with bad status")
        self.assertEqual(error.message, "Request failed with bad status")
        self.assertEqual(error.status_code, 400)
        self.assertIsInstance(error.error, Response)

        response.content = "{"
        error = CloudError(response)
        self.assertTrue("none" in error.message)

        response.content = json.dumps({'message':'server error'})
        error = CloudError(response)
        self.assertTrue("server error" in error.message)
        self.assertEqual(error.status_code, 400)

        response.content = "{"
        response.raise_for_status.side_effect = RequestException("FAILED!")
        error = CloudError(response)
        self.assertTrue("FAILED!" in error.message)
        self.assertIsInstance(error.error, RequestException)

        response.raise_for_status.side_effect = None

        response.content = '{\r\n  "odata.metadata":"https://account.region.batch.azure.com/$metadata#Microsoft.Azure.Batch.Protocol.Entities.Container.errors/@Element","code":"InvalidHeaderValue","message":{\r\n    "lang":"en-US","value":"The value for one of the HTTP headers is not in the correct format.\\nRequestId:5f4c1f05-603a-4495-8e80-01f776310bbd\\nTime:2016-01-04T22:12:33.9245931Z"\r\n  },"values":[\r\n    {\r\n      "key":"HeaderName","value":"Content-Type"\r\n    },{\r\n      "key":"HeaderValue","value":"application/json; odata=minimalmetadata; charset=utf-8"\r\n    }\r\n  ]\r\n}'
        error = CloudError(response)
        self.assertIsInstance(error.error, CloudErrorData)

        response.content = '{"code":"Conflict","message":"The maximum number of Free ServerFarms allowed in a Subscription is 10.","target":null,"details":[{"message":"The maximum number of Free ServerFarms allowed in a Subscription is 10."},{"code":"Conflict"},{"errorentity":{"code":"Conflict","message":"The maximum number of Free ServerFarms allowed in a Subscription is 10.","extendedCode":"59301","messageTemplate":"The maximum number of {0} ServerFarms allowed in a Subscription is {1}.","parameters":["Free","10"],"innerErrors":null}}],"innererror":null}'
        error = CloudError(response)
        self.assertIsInstance(error.error, CloudErrorData)
        self.assertEqual(error.error.error, "Conflict")

        response.content = json.dumps({
            "error": {
                "code": "BadArgument",
                "message": "The provided database 'foo' has an invalid username.",
                "target": "query",
                "details": [
                    {
                        "code": "301",
                        "target": "$search",
                        "message": "$search query option not supported",
                    }
                ]
            }})
        error = CloudError(response)
        self.assertIsInstance(error.error, CloudErrorData)
        self.assertEqual(error.error.error, "BadArgument")


if __name__ == '__main__':
    unittest.main()
