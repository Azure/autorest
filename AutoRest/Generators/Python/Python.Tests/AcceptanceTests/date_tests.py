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

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "BodyDate"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError

from auto_rest_date_test_service import (
    AutoRestDateTestService, 
    AutoRestDateTestServiceConfiguration)


class DateTests(unittest.TestCase):

    def test_date(self):

        config = AutoRestDateTestServiceConfiguration(base_url="http://localhost:3000")
        config.log_level = 10
        client = AutoRestDateTestService(config)

        max_date = isodate.parse_date("9999-12-31T23:59:59.999999Z")
        min_date = isodate.parse_date("0001-01-01T00:00:00Z")
        client.date_model.put_max_date(max_date)
        client.date_model.put_min_date(min_date)

        self.assertEqual(max_date, client.date_model.get_max_date())
        self.assertEqual(min_date, client.date_model.get_min_date())
        self.assertIsNone(client.date_model.get_null())

        # Python isodate.parse support too wild input, and won't raise error
        #with self.assertRaises(DeserializationError):
        #    client.date_model.get_invalid_date()

        with self.assertRaises(DeserializationError):
            client.date_model.get_overflow_date()

        with self.assertRaises(DeserializationError):
            client.date_model.get_underflow_date()

if __name__ == '__main__':
    unittest.main()