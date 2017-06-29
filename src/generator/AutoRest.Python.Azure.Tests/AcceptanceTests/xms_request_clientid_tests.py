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

import unittest
import subprocess
import sys
import isodate
import tempfile
import json
from uuid import uuid4
from datetime import date, datetime, timedelta
import os
from os.path import dirname, pardir, join, realpath

cwd = dirname(realpath(__file__))
log_level = int(os.environ.get('PythonLogLevel', 30))

import fixtures # Ensure that fixtures is loaded on old python before the next line
tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.modules['fixtures'].__path__.append(join(tests, "AzureSpecials", "fixtures"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError
from msrest.authentication import BasicTokenAuthentication
from msrestazure.azure_exceptions import CloudError, CloudErrorData

from fixtures.acceptancetestsazurespecials import AutoRestAzureSpecialParametersTestClient
from fixtures.acceptancetestsazurespecials import models

class XmsRequestClientIdTests(unittest.TestCase):

    def test_xms_request_client_id(self):

        validSubscription = '1234-5678-9012-3456'
        validClientId = '9C4D50EE-2D56-4CD3-8152-34347DC9F2B0'

        cred = BasicTokenAuthentication({"access_token":123})
        client = AutoRestAzureSpecialParametersTestClient(cred, validSubscription, base_url="http://localhost:3000")

        custom_headers = {"x-ms-client-request-id": validClientId }

        result1 = client.xms_client_request_id.get(custom_headers = custom_headers, raw=True)
        #TODO: should we put the x-ms-request-id into response header of swagger spec?
        self.assertEqual("123", result1.response.headers.get("x-ms-request-id"))

        result2 = client.xms_client_request_id.param_get(validClientId, raw=True)
        self.assertEqual("123", result2.response.headers.get("x-ms-request-id"))

    def test_custom_named_request_id(self):

        validSubscription = '1234-5678-9012-3456'
        expectedRequestId = '9C4D50EE-2D56-4CD3-8152-34347DC9F2B0'

        cred = BasicTokenAuthentication({"access_token":123})
        client = AutoRestAzureSpecialParametersTestClient(cred, validSubscription, base_url="http://localhost:3000")

        response = client.header.custom_named_request_id(expectedRequestId, raw=True)
        self.assertEqual("123", response.response.headers.get("foo-request-id"))

    def test_custom_named_request_id_param_grouping(self):

        validSubscription = '1234-5678-9012-3456'
        expectedRequestId = '9C4D50EE-2D56-4CD3-8152-34347DC9F2B0'

        cred = BasicTokenAuthentication({"access_token":123})
        client = AutoRestAzureSpecialParametersTestClient(cred, validSubscription, base_url="http://localhost:3000")

        group = models.HeaderCustomNamedRequestIdParamGroupingParameters(foo_client_request_id=expectedRequestId)
        response = client.header.custom_named_request_id_param_grouping(group, raw=True)
        self.assertEqual("123", response.response.headers.get("foo-request-id"))

    def test_client_request_id_in_exception(self):
        validSubscription = '1234-5678-9012-3456'
        expectedRequestId = '9C4D50EE-2D56-4CD3-8152-34347DC9F2B0'

        cred = BasicTokenAuthentication({"access_token":123})
        client = AutoRestAzureSpecialParametersTestClient(cred, validSubscription, base_url="http://localhost:3000")

        try:
            client.xms_client_request_id.get()
            self.fail("CloudError wasn't raised as expected")

        except CloudError as err:
            self.assertEqual("123", err.request_id)

    def test_xms_request_client_id_in_client(self):
        validSubscription = '1234-5678-9012-3456'
        expectedRequestId = '9C4D50EE-2D56-4CD3-8152-34347DC9F2B0'

        cred = BasicTokenAuthentication({"access_token":123})
        client = AutoRestAzureSpecialParametersTestClient(cred, validSubscription, base_url="http://localhost:3000")
        client.config.generate_client_request_id = False
        client.xms_client_request_id.get()


if __name__ == '__main__':
    unittest.main()
