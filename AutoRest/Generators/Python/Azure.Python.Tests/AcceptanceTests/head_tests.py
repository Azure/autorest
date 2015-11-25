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
from msrest.authentication import BasicTokenAuthentication

from auto_rest_head_test_service import (
    AutoRestHeadTestService, 
    AutoRestHeadTestServiceConfiguration)


class HeadTests(unittest.TestCase):

    def test_head(self):
        
        cred = BasicTokenAuthentication({"access_token" :str(uuid4())})
        config = AutoRestHeadTestServiceConfiguration(cred, base_url="http://localhost:3000")

        config.log_level = 10
        client = AutoRestHeadTestService(config)

        self.assertTrue(client.http_success.head200())
        self.assertTrue(client.http_success.head204())
        self.assertFalse(client.http_success.head404())


if __name__ == '__main__':
    unittest.main()