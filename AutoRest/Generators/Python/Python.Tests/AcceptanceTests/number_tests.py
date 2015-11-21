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
sys.path.append(join(tests, "BodyNumber"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError

from auto_rest_number_test_service import (
    AutoRestNumberTestService, 
    AutoRestNumberTestServiceConfiguration)


class NumberTests(unittest.TestCase):

    def test_numbers(self):

        config = AutoRestNumberTestServiceConfiguration(base_url="http://localhost:3000")
        config.log_level = 10
        client = AutoRestNumberTestService(config)

        client.number.put_big_float(3.402823e+20)
        client.number.put_small_float(3.402823e-20)
        client.number.put_big_double(2.5976931e+101)
        client.number.put_small_double(2.5976931e-101)
        client.number.put_big_double_negative_decimal(-99999999.99)
        client.number.put_big_double_positive_decimal(99999999.99)
        client.number.get_null()
        self.assertEqual(client.number.get_big_float(), 3.402823e+20)
        self.assertEqual(client.number.get_small_float(), 3.402823e-20)
        self.assertEqual(client.number.get_big_double(), 2.5976931e+101)
        self.assertEqual(client.number.get_small_double(), 2.5976931e-101)
        self.assertEqual(client.number.get_big_double_negative_decimal(), -99999999.99)
        self.assertEqual(client.number.get_big_double_positive_decimal(), 99999999.99)

        with self.assertRaises(DeserializationError):
            client.number.get_invalid_double()

        with self.assertRaises(DeserializationError):
            client.number.get_invalid_float()


if __name__ == '__main__':
    unittest.main()