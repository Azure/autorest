import unittest
import subprocess
import sys
import isodate
import tempfile
import json
from uuid import uuid4
from datetime import date, datetime, timedelta
import os
from os.path import dirname, pardir, join, realpath, sep, pardir

cwd = dirname(realpath(__file__))
root = realpath(join(cwd , pardir, pardir, pardir, pardir, pardir))
sys.path.append(join(root, "ClientRuntimes" , "Python", "msrest"))
sys.path.append(join(root, "ClientRuntimes" , "Python", "msrestazure"))
log_level = 10#int(os.environ.get('PythonLogLevel', 30))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "Lro"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError
from msrest.authentication import BasicTokenAuthentication
from msrestazure.azure_exceptions import CloudError, CloudException

from auto_rest_long_running_operation_test_service import (
    AutoRestLongRunningOperationTestService, 
    AutoRestLongRunningOperationTestServiceConfiguration)

from auto_rest_long_running_operation_test_service.models import *

class LroTests(unittest.TestCase):

    def setUp(self):

        cred = BasicTokenAuthentication({"access_token" :str(uuid4())})
        config = AutoRestLongRunningOperationTestServiceConfiguration(cred, base_url="http://localhost:3000")

        config.log_level = log_level
        self.client = AutoRestLongRunningOperationTestService(config)

        self.client.config.long_running_operation_timeout = 0
        return super(LroTests, self).setUp()

    def assertRaisesWithMessage(self, msg, func, *args, **kwargs):

        try:
            func(*args, **kwargs)
            self.fail("CloudError wasn't raised as expected")

        except CloudError as err:
            self.assertTrue(msg in err.message)
            self.assertIsNotNone(err.response)
            error = err.error
            self.assertIsNotNone(error)
            if isinstance(error, CloudException):
                self.assertIsNone(error.code)
                self.assertIsNotNone(error.message)

    def assertRaisesWithServerErrorMessage(self, msg, func, *args, **kwargs):

        try:
            func(*args, **kwargs)
            self.fail("CloudError wasn't raised as expected")

        except CloudError as err:
            self.assertIn(msg, err.response.content)
            self.assertIsNotNone(err.response)
            error = err.error
            self.assertIsNotNone(error)
            if isinstance(error, CloudException):
                self.assertIsNone(error.code)
                self.assertIsNotNone(error.message)

    def test_lro_happy_paths(self):

        product = Product(location="West US")
        process = self.client.lr_os.put201_creating_succeeded200(product)
        self.assertEqual("Succeeded", process.result().provisioning_state)

        self.assertRaisesWithMessage("Long running operation failed",
            self.client.lr_os.put201_creating_failed200(product).result)

        process = self.client.lr_os.put200_updating_succeeded204(product)
        self.assertEqual("Succeeded", process.result().provisioning_state)

        self.assertRaisesWithMessage("Long running operation failed",
            self.client.lr_os.put200_acceptedcanceled200(product).result)

        # Had to modify generated code
        process = self.client.lr_os.put_no_header_in_retry(product)
        self.assertEqual("Succeeded", process.result().provisioning_state)

        # TODO: This returns status 200, which the spec doesn't support so raises error
        #process = self.client.lr_os.put_async_no_header_in_retry(product)
        #self.assertEqual("Succeeded", process.result().provisioning_state)

        # Had to modify generated code
        process = self.client.lr_os.put_sub_resource(SubProduct())
        self.assertEqual("Succeeded", process.result().provisioning_state)

        # TODO: This returns status 200, which the spec doesn't support so raises error
        #process = self.client.lr_os.put_async_sub_resource(SubProduct())
        #self.assertEqual("Succeeded", process.result().provisioning_state)

        # Had to modify generated code - not sure how 100 is supposed to be populated?
        process = self.client.lr_os.put_non_resource(Sku())
        self.assertEqual("100", process.result().id)

        # TODO: This returns status 200, which the spec doesn't support so raises error
        #process = self.client.lr_os.put_async_non_resource(Sku())
        #self.assertEqual("100", process.result().id)

        # TODO: This returns status 200, which the spec doesn't support so raises error
        #process = self.client.lr_os.post202_retry200(product)
        #self.assertIsNone(process.result())

        process = self.client.lr_os.put200_succeeded(product)
        self.assertEqual("Succeeded", process.result().provisioning_state)

        process = self.client.lr_os.put200_succeeded_no_state(product)
        self.assertEqual("100", process.result().id)

        # TODO: This returns status 200, which the spec doesn't support so raises error
        #process = self.client.lr_os.put202_retry200(product)
        #self.assertEqual("100", process.result().id)

        # TODO: This returns status 200, which the spec doesn't support so raises error
        #process = self.client.lr_os.put_async_retry_succeeded(product)
        #self.assertEqual("Succeeded", process.result().provisioning_state)

        # TODO - Polling returns status 202, which generated code detects as error
        #process = self.client.lr_os.put_async_no_retry_succeeded(product)
        #self.assertEqual("Succeeded", process.result().provisioning_state)

        self.assertRaisesWithMessage("Long running operation failed",
            self.client.lr_os.put_async_retry_failed(product).result)

        self.assertRaisesWithMessage("Long running operation failed",
            self.client.lr_os.put_async_no_retrycanceled(product).result)

        self.client.lr_os.delete204_succeeded().result()
        self.client.lr_os.delete202_retry200().result()
        self.client.lr_os.delete202_no_retry204().result()

        # TODO - Seems to run in an endless loop - status never changes from 202, how to detect completion?
        #self.client.lr_os.delete_async_no_retry_succeeded().result()

        self.client.lr_os.delete_no_header_in_retry().result()

        # TODO: This returns status 200, which the spec doesn't support so raises error
        #self.client.lr_os.delete_async_no_header_in_retry().result()

        # TODO - Seems to run in an endless loop - status never changes from 202, how to detect cancelation?
        #self.assertRaisesWithMessage("Long running operation failed",
        #    self.client.lr_os.delete_async_retrycanceled().result)

        # TODO - Seems to run in an endless loop
        #self.assertRaisesWithMessage("Long running operation failed",
        #    self.client.lr_os.delete_async_retry_failed().result)

        # TODO - Seems to run in an endless loop
        #self.client.lr_os.delete_async_retry_succeeded().result()

        self.client.lr_os.delete_provisioning202_accepted200_succeeded().result()
        self.client.lr_os.delete_provisioning202_deletingcanceled200().result()
        self.client.lr_os.delete_provisioning202_deleting_failed200().result()
        self.client.lr_os.post202_no_retry204(product).result()

        # TODO - Seems to run in an endless loop
        #self.assertRaisesWithMessage("Long running operation failed with status 'Failed'",
        #    self.client.lr_os.post_async_retry_failed().result)

        # TODO - Seems to run in an endless loop
        #self.assertRaisesWithMessage("Long running operation failed with status 'Canceled'",
        #    self.client.lr_os.post_async_retrycanceled().result)

        # TODO - Seems to run in an endless loop
        #prod = self.client.lr_os.post_async_retry_succeeded().result()
        #self.assertEqual(prod.id, "100")

        # TODO - Seems to run in an endless loop
        #prod = self.client.lr_os.post_async_no_retry_succeeded().result()
        #self.assertEqual(prod.id, "100")

        sku = self.client.lr_os.post200_with_payload().result()
        self.assertEqual(sku.id, '1')

        process = self.client.lro_retrys.put201_creating_succeeded200(product)
        self.assertEqual('Succeeded', process.result().provisioning_state)

        process = self.client.lro_retrys.put_async_relative_retry_succeeded(product)
        self.assertEqual('Succeeded', process.result().provisioning_state)

        self.client.lro_retrys.delete_provisioning202_accepted200_succeeded().result()

        # TODO: This returns status 200, which the spec doesn't support so raises error
        #self.client.lro_retrys.delete202_retry200().result()
        
        # TODO: This returns status 200, which the spec doesn't support so raises error
        #self.client.lro_retrys.delete_async_relative_retry_succeeded().result()
        
        # TODO: This returns status 200, which the spec doesn't support so raises error
        #self.client.lro_retrys.post202_retry200(product).result()
        
        # TODO: This returns status 200, which the spec doesn't support so raises error
        #self.client.lro_retrys.post_async_relative_retry_succeeded(product).result()

        custom_headers = {"x-ms-client-request-id": '9C4D50EE-2D56-4CD3-8152-34347DC9F2B0'}
        
        # TODO: This returns status 202, which the spec doesn't support so raises error
        #process = self.client.lr_os_custom_header.put_async_retry_succeeded(product, custom_headers)
        #self.assertIsNotNone(process.result())

        # TODO: Endless loop
        #process = self.client.lr_os_custom_header.post_async_retry_succeeded(product, custom_headers)
        #self.assertIsNotNone(process.result())

        process = self.client.lr_os_custom_header.put201_creating_succeeded200(product, custom_headers)
        self.assertIsNotNone(process.result())

        # TODO: This returns status 200, which the spec doesn't support so raises error
        #process = self.client.lr_os_custom_header.post202_retry200(product, custom_headers)
        #self.assertIsNotNone(process.result())

    def test_lro_sad_paths(self):

        product = Product(location="West US")

        self.assertRaisesWithMessage("Expected",
            self.client.lrosa_ds.put_non_retry400(product).result)

        self.assertRaisesWithMessage("Error from the server",
            self.client.lrosa_ds.put_non_retry201_creating400(product).result)

        self.assertRaisesWithMessage("Long running operation failed with status 'Bad Request'.",
            self.client.lrosa_ds.put_async_relative_retry400(product).result)

        self.assertRaisesWithMessage("Expected",
            self.client.lrosa_ds.delete_non_retry400().result)

        self.assertRaisesWithMessage("Long running operation failed with status 'Bad Request'.",
            self.client.lrosa_ds.delete202_non_retry400().result)

        self.assertRaisesWithMessage("Long running operation failed with status 'Bad Request'.",
            self.client.lrosa_ds.delete_async_relative_retry400().result)

        self.assertRaisesWithServerErrorMessage("Expected bad request message",
            self.client.lrosa_ds.post_non_retry400(product).result)

        self.assertRaisesWithMessage("Long running operation failed with status 'Bad Request'.",
            self.client.lrosa_ds.post202_non_retry400(product).result)

        self.assertRaisesWithMessage("Long running operation failed with status 'Bad Request'.",
            self.client.lrosa_ds.post_async_relative_retry400(product).result)

        self.assertRaisesWithMessage("The response from long running operation does not contain a body.",
            self.client.lrosa_ds.put_error201_no_provisioning_state_payload(product).result)

        # TODO: Response returns 200 without body, whereas in above test this is allowed?
        #self.assertRaisesWithMessage("The response from long running operation does not contain a body.",
        #    self.client.lrosa_ds.put_async_relative_retry_no_status(product).result)

        # TODO: Response returns 200 without body, whereas in above test this is allowed?
        #self.assertRaisesWithMessage("The response from long running operation does not contain a body.",
        #    self.client.lrosa_ds.put_async_relative_retry_no_status_payload(product).result)

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

        with self.assertRaises(CloudError):
            self.client.lrosa_ds.delete_async_relative_retry_invalid_json_polling().result()

        with self.assertRaises(CloudError):
            self.client.lrosa_ds.post_async_relative_retry_invalid_json_polling().result()

        self.client.lrosa_ds.delete204_succeeded().result()

        self.assertRaisesWithMessage("The response from long running operation does not contain a body.",
            self.client.lrosa_ds.delete_async_relative_retry_no_status().result)

        # TODO
        #self.assertRaisesWithMessage("Location header is missing from long running operation.",
        #    self.client.lrosa_ds.post202_no_location().result)

        self.assertRaisesWithMessage("The response from long running operation does not contain a body.",
            self.client.lrosa_ds.post_async_relative_retry_no_payload().result)


if __name__ == '__main__':
    unittest.main()