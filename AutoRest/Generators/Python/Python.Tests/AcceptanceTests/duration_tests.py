import unittest
import subprocess
import sys
import isodate
import tempfile
import json
from datetime import date, datetime, timedelta
import os
from os.path import dirname, pardir, join, realpath, sep, pardir

cwd = dirname(realpath(__file__))
root = realpath(join(cwd , pardir, pardir, pardir, pardir, pardir))
sys.path.append(join(root, "ClientRuntimes" , "Python", "msrest"))
log_level = int(os.environ.get('PythonLogLevel', 30))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "BodyDuration"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError

from auto_rest_duration_test_service import (
    AutoRestDurationTestService, 
    AutoRestDurationTestServiceConfiguration)


class DurationTests(unittest.TestCase):

    def test_duration(self):

        config = AutoRestDurationTestServiceConfiguration(base_url="http://localhost:3000")
        config.log_level = log_level
        client = AutoRestDurationTestService(config)

        self.assertIsNone(client.duration.get_null())

        with self.assertRaises(DeserializationError):
            client.duration.get_invalid()

        client.duration.get_positive_duration()
        client.duration.put_positive_duration(timedelta(days=123, hours=22, minutes=14, seconds=12, milliseconds=11))


if __name__ == '__main__':
    unittest.main()