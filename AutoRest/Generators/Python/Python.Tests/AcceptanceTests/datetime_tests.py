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
sys.path.append(join(tests, "BodyDateTime"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError, SerializationError

from auto_rest_date_time_test_service import (
    AutoRestDateTimeTestService, 
    AutoRestDateTimeTestServiceConfiguration)


class DatetimeTests(unittest.TestCase):

    def test_datetime(self):

        config = AutoRestDateTimeTestServiceConfiguration("http://localhost:3000")
        config.log_level = 10
        client = AutoRestDateTimeTestService(config)

        max_date = isodate.parse_datetime("9999-12-31T23:59:59.999999Z")
        min_date = isodate.parse_datetime("0001-01-01T00:00:00Z")

        dt = client.datetime_model.get_utc_lowercase_max_date_time()
        self.assertEqual(dt, max_date)
        dt = client.datetime_model.get_utc_uppercase_max_date_time()
        self.assertEqual(dt, max_date)
        dt = client.datetime_model.get_utc_min_date_time()
        self.assertEqual(dt, min_date)

        client.datetime_model.get_local_negative_offset_min_date_time()

        with self.assertRaises(DeserializationError):
            client.datetime_model.get_local_negative_offset_lowercase_max_date_time()

        with self.assertRaises(DeserializationError):
            client.datetime_model.get_local_negative_offset_uppercase_max_date_time()

        with self.assertRaises(DeserializationError):
            client.datetime_model.get_local_positive_offset_min_date_time()

        client.datetime_model.get_local_positive_offset_lowercase_max_date_time()
        client.datetime_model.get_local_positive_offset_uppercase_max_date_time()

        client.datetime_model.get_null()

        with self.assertRaises(DeserializationError):
            client.datetime_model.get_overflow()

        with self.assertRaises(DeserializationError):
            client.datetime_model.get_invalid()

        with self.assertRaises(DeserializationError):
            client.datetime_model.get_underflow()

        client.datetime_model.put_utc_max_date_time(max_date)
        client.datetime_model.put_utc_min_date_time(min_date)

        with self.assertRaises(SerializationError):
            client.datetime_model.put_local_positive_offset_min_date_time(
                isodate.parse_datetime("0001-01-01T00:00:00+14:00"))

        client.datetime_model.put_local_negative_offset_min_date_time(
            isodate.parse_datetime("0001-01-01T00:00:00-14:00"))

        with self.assertRaises(SerializationError):
            client.datetime_model.put_local_negative_offset_max_date_time(
                isodate.parse_datetime("9999-12-31T23:59:59.999999-14:00"))

        client.datetime_model.put_local_positive_offset_max_date_time(
            isodate.parse_datetime("9999-12-31T23:59:59.999999+14:00"))


if __name__ == '__main__':
    unittest.main()