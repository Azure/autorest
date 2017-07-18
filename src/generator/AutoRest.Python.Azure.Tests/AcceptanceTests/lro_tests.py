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
sys.modules['fixtures'].__path__.append(join(tests, "Lro", "fixtures"))

# Import mock from Autorest.Python.Tests
mockfiles = realpath(join(cwd, pardir, pardir, "AutoRest.Python.Tests", "AcceptanceTests"))
sys.path.append(mockfiles)

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError
from msrest.authentication import BasicTokenAuthentication
from msrestazure.azure_exceptions import CloudError, CloudErrorData

from fixtures.acceptancetestslro import AutoRestLongRunningOperationTestService
from fixtures.acceptancetestslro.models import *

from http_tests import TestAuthentication

class LroTests(unittest.TestCase):

    def setUp(self):

        cred = BasicTokenAuthentication({"access_token" :str(uuid4())})
        self.client = AutoRestLongRunningOperationTestService(cred, base_url="http://localhost:3000")
        self.client._client.creds = TestAuthentication()
        self.client.config.long_running_operation_timeout = 0
        return super(LroTests, self).setUp()

    def assertRaisesWithMessage(self, msg, func, *args, **kwargs):
        try:
            func(*args, **kwargs).result()
            self.fail("CloudError wasn't raised as expected")

        except CloudError as err:
            self.assertTrue(msg in err.message)
            self.assertIsNotNone(err.response)
            error = err.error
            self.assertIsNotNone(error)
            if isinstance(error, CloudErrorData):
                self.assertIsNotNone(error.message)

    def test_lro_happy_paths(self):

        product = Product(location="West US")

        process = self.client.lr_os.put201_creating_succeeded200(product)
        self.assertEqual("Succeeded", process.result().provisioning_state)

        self.assertRaisesWithMessage("Operation failed with status: 200. Details: Resource state Failed",
            self.client.lr_os.put201_creating_failed200, product)

        process = self.client.lr_os.put200_updating_succeeded204(product)
        self.assertEqual("Succeeded", process.result().provisioning_state)

        self.assertRaisesWithMessage("Operation failed with status: 200. Details: Resource state Canceled",
            self.client.lr_os.put200_acceptedcanceled200, product)

        # Testing raw
        process = self.client.lr_os.put201_creating_succeeded200(product, raw=True)
        self.assertEqual("Creating", process.output.provisioning_state)

        process = self.client.lr_os.put201_creating_failed200(product, raw=True)
        self.assertEqual("Created", process.output.provisioning_state)

        process = self.client.lr_os.put200_updating_succeeded204(product, raw=True)
        self.assertEqual("Updating", process.output.provisioning_state)

        process = self.client.lr_os.put200_acceptedcanceled200(product, raw=True)
        self.assertEqual("Accepted", process.output.provisioning_state)

        process = self.client.lr_os.put_no_header_in_retry(product)
        self.assertEqual("Succeeded", process.result().provisioning_state)

        process = self.client.lr_os.put_async_no_header_in_retry(product)
        self.assertEqual("Succeeded", process.result().provisioning_state)

        process = self.client.lr_os.put_sub_resource(SubProduct())
        self.assertEqual("Succeeded", process.result().provisioning_state)

        process = self.client.lr_os.put_async_sub_resource(SubProduct())
        self.assertEqual("Succeeded", process.result().provisioning_state)

        process = self.client.lr_os.put_non_resource(Sku())
        self.assertEqual("100", process.result().id)

        process = self.client.lr_os.put_async_non_resource(Sku())
        self.assertEqual("100", process.result().id)

        process = self.client.lr_os.post202_retry200(product)
        self.assertIsNone(process.result())

        process = self.client.lr_os.put200_succeeded(product)
        self.assertEqual("Succeeded", process.result().provisioning_state)

        process = self.client.lr_os.put200_succeeded_no_state(product)
        self.assertEqual("100", process.result().id)

        process = self.client.lr_os.put202_retry200(product)
        self.assertEqual("100", process.result().id)

        process = self.client.lr_os.put_async_retry_succeeded(product)
        self.assertEqual("Succeeded", process.result().provisioning_state)

        process = self.client.lr_os.put_async_no_retry_succeeded(product)
        self.assertEqual("Succeeded", process.result().provisioning_state)

        self.assertRaisesWithMessage("Operation failed with status: 200. Details: Resource state Failed",
            self.client.lr_os.put_async_retry_failed, product)

        self.assertRaisesWithMessage("Operation failed with status: 200. Details: Resource state Canceled",
            self.client.lr_os.put_async_no_retrycanceled, product)

        self.assertIsNone(self.client.lr_os.delete204_succeeded().result())
        self.assertIsNone(self.client.lr_os.delete202_retry200().result())
        self.assertIsNone(self.client.lr_os.delete202_no_retry204().result())

        self.assertIsNone(self.client.lr_os.delete_async_no_retry_succeeded().result())
        self.assertIsNone(self.client.lr_os.delete_no_header_in_retry().result())

        self.assertIsNone(self.client.lr_os.delete_async_no_header_in_retry().result())

        self.assertRaisesWithMessage("Operation failed with status: 200. Details: Resource state Canceled",
            self.client.lr_os.delete_async_retrycanceled)

        self.assertRaisesWithMessage("Operation failed with status: 200. Details: Resource state Failed",
            self.client.lr_os.delete_async_retry_failed)

        self.assertIsNone(self.client.lr_os.delete_async_retry_succeeded().result())

        process = self.client.lr_os.delete_provisioning202_accepted200_succeeded()
        self.assertEqual("Succeeded", process.result().provisioning_state)

        result = self.client.lr_os.delete_provisioning202_deletingcanceled200().result()
        self.assertEqual(result.provisioning_state, 'Canceled')

        result = self.client.lr_os.delete_provisioning202_deleting_failed200().result()
        self.assertEqual(result.provisioning_state, 'Failed')

        self.assertIsNone(self.client.lr_os.post202_no_retry204(product).result())

        self.assertRaisesWithMessage("Internal Server Error",
            self.client.lr_os.post_async_retry_failed)

        self.assertRaisesWithMessage("Operation failed with status: 200. Details: Resource state Canceled",
            self.client.lr_os.post_async_retrycanceled)

        prod = self.client.lr_os.post_async_retry_succeeded().result()
        self.assertEqual(prod.id, "100")

        prod = self.client.lr_os.post_async_no_retry_succeeded().result()
        self.assertEqual(prod.id, "100")

        sku = self.client.lr_os.post200_with_payload().result()
        self.assertEqual(sku.id, '1')

        process = self.client.lro_retrys.put201_creating_succeeded200(product)
        self.assertEqual('Succeeded', process.result().provisioning_state)

        process = self.client.lro_retrys.put_async_relative_retry_succeeded(product)
        self.assertEqual('Succeeded', process.result().provisioning_state)

        process = self.client.lro_retrys.delete_provisioning202_accepted200_succeeded()
        self.assertEqual('Succeeded', process.result().provisioning_state)

        self.assertIsNone(self.client.lro_retrys.delete202_retry200().result())
        self.assertIsNone(self.client.lro_retrys.delete_async_relative_retry_succeeded().result())
        self.assertIsNone(self.client.lro_retrys.post202_retry200(product).result())
        self.assertIsNone(self.client.lro_retrys.post_async_relative_retry_succeeded(product).result())

        custom_headers = {"x-ms-client-request-id": '9C4D50EE-2D56-4CD3-8152-34347DC9F2B0'}

        process = self.client.lr_os_custom_header.put_async_retry_succeeded(product, custom_headers)
        self.assertIsNotNone(process.result())

        process = self.client.lr_os_custom_header.post_async_retry_succeeded(product, custom_headers)
        self.assertIsNone(process.result())

        process = self.client.lr_os_custom_header.put201_creating_succeeded200(product, custom_headers)
        self.assertIsNotNone(process.result())

        process = self.client.lr_os_custom_header.post202_retry200(product, custom_headers)
        self.assertIsNone(process.result())

    def test_lro_sad_paths(self):

        product = Product(location="West US")

        self.assertRaisesWithMessage("Expected bad request message",
            self.client.lrosa_ds.put_non_retry400, product)

        self.assertRaisesWithMessage("Error from the server",
            self.client.lrosa_ds.put_non_retry201_creating400, product)

        self.assertRaisesWithMessage("Operation failed with status: 'Bad Request'",
            self.client.lrosa_ds.put_async_relative_retry400, product)

        self.assertRaisesWithMessage("Expected bad request message",
            self.client.lrosa_ds.delete_non_retry400)

        self.assertRaisesWithMessage("Expected bad request message",
            self.client.lrosa_ds.delete202_non_retry400)

        self.assertRaisesWithMessage("Expected bad request message",
            self.client.lrosa_ds.delete_async_relative_retry400)

        self.assertRaisesWithMessage("Expected bad request message",
            self.client.lrosa_ds.post_non_retry400, product)

        self.assertRaisesWithMessage("Expected bad request message",
            self.client.lrosa_ds.post202_non_retry400, product)

        self.assertRaisesWithMessage("Expected bad request message",
            self.client.lrosa_ds.post_async_relative_retry400, product)

        self.assertRaisesWithMessage("The response from long running operation does not contain a body.",
            self.client.lrosa_ds.put_error201_no_provisioning_state_payload, product)

        self.assertRaisesWithMessage("The response from long running operation does not contain a body.",
            self.client.lrosa_ds.put_async_relative_retry_no_status, product)

        self.assertRaisesWithMessage("The response from long running operation does not contain a body.",
            self.client.lrosa_ds.put_async_relative_retry_no_status_payload, product)

        with self.assertRaises(DeserializationError):
            self.client.lrosa_ds.put200_invalid_json(product).result()

        with self.assertRaises(DeserializationError):
            self.client.lrosa_ds.put_async_relative_retry_invalid_json_polling(product).result()

        with self.assertRaises(ValueError):
            self.client.lrosa_ds.put_async_relative_retry_invalid_header(product).result()

        with self.assertRaises(ValueError):
            self.client.lrosa_ds.delete202_retry_invalid_header().result()

        with self.assertRaises(ValueError):
            self.client.lrosa_ds.delete_async_relative_retry_invalid_header().result()

        with self.assertRaises(ValueError):
            self.client.lrosa_ds.post202_retry_invalid_header().result()

        with self.assertRaises(ValueError):
            self.client.lrosa_ds.post_async_relative_retry_invalid_header().result()

        with self.assertRaises(DeserializationError):
            self.client.lrosa_ds.delete_async_relative_retry_invalid_json_polling().result()

        with self.assertRaises(DeserializationError):
            self.client.lrosa_ds.post_async_relative_retry_invalid_json_polling().result()

        self.client.lrosa_ds.delete204_succeeded().result()

        self.assertRaisesWithMessage("The response from long running operation does not contain a body.",
            self.client.lrosa_ds.delete_async_relative_retry_no_status)

        self.assertRaisesWithMessage("Location header is missing from long running operation.",
            self.client.lrosa_ds.post202_no_location)

        self.assertRaisesWithMessage("The response from long running operation does not contain a body.",
            self.client.lrosa_ds.post_async_relative_retry_no_payload)


if __name__ == '__main__':
    unittest.main()
