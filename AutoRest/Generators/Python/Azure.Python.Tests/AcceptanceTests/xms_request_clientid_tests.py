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
sys.path.append(join(tests, "Head"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError
from msrestazure.azure_active_directory import UserPassCredentials

from auto_rest_head_test_service import (
    AutoRestHeadTestService, 
    AutoRestHeadTestServiceConfiguration)


class XmsRequestClientIdTests(unittest.TestCase):

    def test_xms_request_client_id(self):

        validSubscription = '1234-5678-9012-3456'
        validClientId = '9C4D50EE-2D56-4CD3-8152-34347DC9F2B0'

        cred = TokenAuthentication(validSubscription, {"my_token":123})
        config = AutoRestAzureSpecialParametersTestClientConfiguration(None, validSubscription, "http://localhost:3000")
        config.log_level = 10
        client = AutoRestAzureSpecialParametersTestClient(config)

        custom_headers = {"x-ms-client-request-id": validClientId }
        result1 = client.xms_client_request_id.get(custom_headers = custom_headers)
        #TODO: investigate on return default request_id as other language
        #self.assertEqual("123", result1.request_id)

        result2 = client.xms_client_request_id.param_get(validClientId)
        #TODO: investigate on return default request_id as other language
        #self.assertEqual("123", result2.request_id)
        
    #var validSubscription = "1234-5678-9012-3456";
    #var validClientId = "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0";
    #using (var client = new AutoRestAzureSpecialParametersTestClient(Fixture.Uri,
    #        new TokenCredentials(validSubscription, Guid.NewGuid().ToString()))
    #        { SubscriptionId = validSubscription })
    #{
    #    Dictionary<string, List<string>> customHeaders = new Dictionary<string, List<string>>();
    #    customHeaders["x-ms-client-request-id"] = new List<string> { validClientId };
    #    var result1 = client.XMsClientRequestId.GetWithHttpMessagesAsync(customHeaders)
    #        .ConfigureAwait(true).GetAwaiter().GetResult();
    #    Assert.Equal("123", result1.RequestId);

    #    var result2 = client.XMsClientRequestId.ParamGetWithHttpMessagesAsync(validClientId)
    #        .ConfigureAwait(false).GetAwaiter().GetResult();
    #    Assert.Equal("123", result2.RequestId);
    #}


if __name__ == '__main__':
    unittest.main()