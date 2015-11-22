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
sys.path.append(join(tests, "SubscriptionIdApiVersion"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError
from msrestazure.azure_active_directory import UserPassCredentials

from microsoft_azure_test_url import (
    MicrosoftAzureTestUrl, 
    MicrosoftAzureTestUrlConfiguration)

from microsoft_azure_test_url.models import ErrorException, SampleResourceGroup

class AzureUrlTests(unittest.TestCase):

    def test_azure_url(self):

        sub_id = str(uuid4())
        client_id = str(uuid4())
        
        config = MicrosoftAzureTestUrlConfiguration(sub_id, "http://localhost:3000")

        # TODO: investigate how to use TokenAuth in testing
        #creds = UserPassCredentials(config, client_id, "user", "password")
        #creds.get_token()

        config.log_level = 10
        client = MicrosoftAzureTestUrl(None, config)

        group = client.group.get_sample_resource_group("testgoup101")
        self.assertEqual(group.name, "testgroup101")
        self.assertEqual(group.location, "West US")


if __name__ == '__main__':
    unittest.main()