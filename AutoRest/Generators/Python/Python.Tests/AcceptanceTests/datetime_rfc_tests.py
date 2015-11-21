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
sys.path.append(join(tests, "BodyDateTimeRfc1123"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError

from auto_rest_rfc1123_date_time_test_service import (
    AutoRestRFC1123DateTimeTestService, 
    AutoRestRFC1123DateTimeTestServiceConfiguration)


class DateTimeRfcTests(unittest.TestCase):

    def test_datetime_rfc(self):

        config = AutoRestRFC1123DateTimeTestServiceConfiguration(base_url="http://localhost:3000")
        config.log_level = 10
        client = AutoRestRFC1123DateTimeTestService(config)

        self.assertIsNone(client.datetimerfc1123.get_null())

        with self.assertRaises(DeserializationError):
            client.datetimerfc1123.get_invalid()

        with self.assertRaises(DeserializationError):
            client.datetimerfc1123.get_underflow()

        with self.assertRaises(DeserializationError):
            client.datetimerfc1123.get_overflow()

        client.datetimerfc1123.get_utc_lowercase_max_date_time()
        client.datetimerfc1123.get_utc_uppercase_max_date_time()
        client.datetimerfc1123.get_utc_min_date_time()

        max_date = isodate.parse_datetime("9999-12-31T23:59:59.999999Z")
        client.datetimerfc1123.put_utc_max_date_time(max_date)

        min_date = isodate.parse_datetime("0001-01-01T00:00:00Z")
        client.datetimerfc1123.put_utc_min_date_time(min_date)

if __name__ == '__main__':
    unittest.main()