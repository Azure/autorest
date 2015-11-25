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
sys.path.append(join(tests, "AzureBodyDuration"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError
from msrest.authentication import BasicTokenAuthentication

from auto_rest_duration_test_service import (
    AutoRestDurationTestService, 
    AutoRestDurationTestServiceConfiguration)


class DurationTests(unittest.TestCase):

    def test_duration(self):

        cred = BasicTokenAuthentication({"access_token" :str(uuid4())})
        config = AutoRestDurationTestServiceConfiguration(cred, base_url="http://localhost:3000")
        config.log_level = 10
        client = AutoRestDurationTestService(config)

        self.assertIsNone(client.duration.get_null())

        with self.assertRaises(DeserializationError):
            client.duration.get_invalid()

        client.duration.get_positive_duration()
        delta = timedelta(days=123, hours=22, minutes=14, seconds=12, milliseconds=11)
        client.duration.put_positive_duration(delta)


if __name__ == '__main__':
    unittest.main()