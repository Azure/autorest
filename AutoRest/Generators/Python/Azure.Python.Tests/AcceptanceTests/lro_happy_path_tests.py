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

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "Lro"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError
from msrestazure.azure_active_directory import UserPassCredentials
from msrestazure.azure_exceptions import CloudError

from auto_rest_long_running_operation_test_service import (
    AutoRestLongRunningOperationTestService, 
    AutoRestLongRunningOperationTestServiceConfiguration)

from auto_rest_long_running_operation_test_service.models import *

class LroTests(unittest.TestCase):

    def assertRaisesWithMessage(self, msg, func, *args, **kwargs):

        try:
            func(*args, **kwargs)
            self.fail("CloudError wasn't raised as expected")

        except CloudError as err:
            self.assertEqual(err.message, msg)

    def test_lro(self):

        config = AutoRestLongRunningOperationTestServiceConfiguration("http://localhost:3000")

        # TODO: investigate how to use TokenAuth in testing
        #creds = UserPassCredentials(config, client_id, "user", "password")
        #creds.get_token()

        config.log_level = 10
        client = AutoRestLongRunningOperationTestService(None, config)

        client.config.long_running_operation_timeout = 0

        product = Product(location="West US")
        process = client.lr_os.put201_creating_succeeded200(product)
        self.assertEqual("Succeeded", process.result().provisioning_state)

        self.assertRaisesWithMessage("Long running operation failed",
            client.lr_os.put201_creating_failed200(product).result)

        process = client.lr_os.put200_updating_succeeded204(product)
        self.assertEqual("Succeeded", process.result().provisioning_state)

        self.assertRaisesWithMessage("Long running operation failed",
            client.lr_os.put200_acceptedcanceled200(product).result)

        process = client.lr_os.put_no_header_in_retry(product)
        self.assertEqual("Succeeded", process.result().provisioning_state)

        process = client.lr_os.put_async_no_header_in_retry(product)
        self.assertEqual("Succeeded", process.result().provisioning_state)

        process = client.lr_os.put_sub_resource(SubProduct())
        self.assertEqual("Succeeded", process.result().provisioning_state)

        process = client.lr_os.put_async_sub_resource(SubProduct())
        self.assertEqual("Succeeded", process.result().provisioning_state)

        # TODO - Doesn't appear to be any data in responses
        #process = client.lr_os.put_non_resource(Sku())
        #self.assertEqual("100", process.result().id)

        # TODO - Doesn't appear to be any data in responses
        #process = client.lr_os.put_async_non_resource(Sku())
        #self.assertEqual("100", process.result().id)

        self.assertIsNone(client.lr_os.post202_retry200(product).result())

        process = client.lr_os.put200_succeeded(product)
        self.assertEqual("Succeeded", process.result().provisioning_state)

        process = client.lr_os.put200_succeeded_no_state(product)
        self.assertEqual("100", process.result().id)

        # TODO - The generated code doesn't allow for the required status 200?
        #process = client.lr_os.put202_retry200(product)
        #self.assertEqual("100", process.result().id)

        # TODO - Server doesn't return expected status
        #process = client.lr_os.put_async_retry_succeeded(product)
        #self.assertEqual("Succeeded", process.result().provisioning_state)

        # TODO - Polling returns status 202, which generated code detects as error
        #process = client.lr_os.put_async_no_retry_succeeded(product)
        #self.assertEqual("Succeeded", process.result().provisioning_state)

        self.assertRaisesWithMessage("Long running operation failed",
            client.lr_os.put_async_retry_failed(product).result)

        self.assertRaisesWithMessage("Long running operation failed",
            client.lr_os.put_async_no_retrycanceled(product).result)

        client.lr_os.delete204_succeeded().result()
        client.lr_os.delete202_retry200().result()
        client.lr_os.delete202_no_retry204().result()

        # TODO - Seems to run in an endless loop
        #client.lr_os.delete_async_no_retry_succeeded().result()



#        client.LROs.DeleteNoHeaderInRetry();
#        client.LROs.DeleteAsyncNoHeaderInRetry();
#        exception = Assert.Throws<CloudException>(() => client.LROs.DeleteAsyncRetrycanceled());
#        Assert.Contains("Long running operation failed", exception.Message, StringComparison.Ordinal);
#        exception = Assert.Throws<CloudException>(() => client.LROs.DeleteAsyncRetryFailed());
#        Assert.Contains("Long running operation failed", exception.Message, StringComparison.Ordinal);
#        client.LROs.DeleteAsyncRetrySucceeded();
#        client.LROs.DeleteProvisioning202Accepted200Succeeded();
#        client.LROs.DeleteProvisioning202Deletingcanceled200();
#        client.LROs.DeleteProvisioning202DeletingFailed200();
#        client.LROs.Post202NoRetry204(new Product { Location = "West US" });
#        exception = Assert.Throws<CloudException>(() => client.LROs.PostAsyncRetryFailed());
#        Assert.Contains("Long running operation failed with status 'Failed'", exception.Message,
#            StringComparison.Ordinal);
#        Assert.NotNull(exception.Body);
#        var error = exception.Body;
#        Assert.NotNull(error.Code);
#        Assert.NotNull(error.Message);
#        exception = Assert.Throws<CloudException>(() => client.LROs.PostAsyncRetrycanceled());
#        Assert.Contains("Long running operation failed with status 'Canceled'", exception.Message,
#            StringComparison.Ordinal);
#        Product prod = client.LROs.PostAsyncRetrySucceeded();
#        Assert.Equal("100", prod.Id);
#        prod = client.LROs.PostAsyncNoRetrySucceeded();
#        Assert.Equal("100", prod.Id);
#        var sku = client.LROs.Post200WithPayload();
#        Assert.Equal("1", sku.Id);
#        // Retryable errors
#        Assert.Equal("Succeeded",
#            client.LRORetrys.Put201CreatingSucceeded200(new Product { Location = "West US" }).ProvisioningState);
#        Assert.Equal("Succeeded",
#            client.LRORetrys.PutAsyncRelativeRetrySucceeded(new Product { Location = "West US" }).ProvisioningState);
#        client.LRORetrys.DeleteProvisioning202Accepted200Succeeded();
#        client.LRORetrys.Delete202Retry200();
#        client.LRORetrys.DeleteAsyncRelativeRetrySucceeded();
#        client.LRORetrys.Post202Retry200(new Product { Location = "West US" });
#        client.LRORetrys.PostAsyncRelativeRetrySucceeded(new Product { Location = "West US" });

#        var customHeaders = new Dictionary<string, List<string>>
#        {
#            {
#            "x-ms-client-request-id", new List<string> {"9C4D50EE-2D56-4CD3-8152-34347DC9F2B0"}
#            }
#        };

#        Assert.NotNull(client.LROsCustomHeader.PutAsyncRetrySucceededWithHttpMessagesAsync(
#                            new Product { Location = "West US" }, customHeaders).Result);

#        Assert.NotNull(client.LROsCustomHeader.PostAsyncRetrySucceededWithHttpMessagesAsync(
#                            new Product { Location = "West US" }, customHeaders).Result);

#        Assert.NotNull(client.LROsCustomHeader.Put201CreatingSucceeded200WithHttpMessagesAsync(
#                            new Product { Location = "West US" }, customHeaders).Result);

#        Assert.NotNull(client.LROsCustomHeader.Post202Retry200WithHttpMessagesAsync(
#                            new Product { Location = "West US" }, customHeaders).Result);



if __name__ == '__main__':
    unittest.main()