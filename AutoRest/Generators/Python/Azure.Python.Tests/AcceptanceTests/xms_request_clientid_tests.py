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
log_level = int(os.environ.get('PythonLogLevel', 30))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "AzureSpecials"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError
from msrest.authentication import BasicTokenAuthentication

from auto_rest_azure_special_parameters_test_client import AutoRestAzureSpecialParametersTestClient, AutoRestAzureSpecialParametersTestClientConfiguration
    

class XmsRequestClientIdTests(unittest.TestCase):

    def test_xms_request_client_id(self):

        validSubscription = '1234-5678-9012-3456'
        validClientId = '9C4D50EE-2D56-4CD3-8152-34347DC9F2B0'

        cred = BasicTokenAuthentication({"access_token":123})
        config = AutoRestAzureSpecialParametersTestClientConfiguration(cred, validSubscription, base_url="http://localhost:3000")
        config.log_level = log_level
        client = AutoRestAzureSpecialParametersTestClient(config)

        custom_headers = {"x-ms-client-request-id": validClientId }
        result1 = client.xms_client_request_id.get(custom_headers = custom_headers)
        #TODO: investigate on return default request_id as other language
        #self.assertEqual("123", result1.request_id)

        result2 = client.xms_client_request_id.param_get(validClientId)
        #TODO: investigate on return default request_id as other language
        #self.assertEqual("123", result2.request_id)

if __name__ == '__main__':
    unittest.main()