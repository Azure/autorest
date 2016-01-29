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

from msrest import Deserializer
from msrest.exceptions import RequestException
from msrestazure.azure_exceptions import CloudError
from msrestazure.azure_operation import (
    PostDeleteOperation,
    PutPatchOperation,
    AzureOperationPoller)


class TestLongRunningOperation(unittest.TestCase):

    def test_long_running_operation(self):
        
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


if __name__ == '__main__':
    unittest.main()