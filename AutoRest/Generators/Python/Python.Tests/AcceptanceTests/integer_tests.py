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
log_level = os.environ.get('PythonLogLevel', 30)

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "BodyInteger"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError

from auto_rest_integer_test_service import (
    AutoRestIntegerTestService, 
    AutoRestIntegerTestServiceConfiguration)


class IntegerTests(unittest.TestCase):

    def test_integer(self):

        config = AutoRestIntegerTestServiceConfiguration(base_url="http://localhost:3000")
        config.log_level = log_level
        client = AutoRestIntegerTestService(config)

        client.int_model.put_max32(sys.maxint)

        client.int_model.put_min32(0 - sys.maxint - 1)

        client.int_model.put_max64(9223372036854776000)  #sys.maxsize
        client.int_model.put_min64(-9223372036854776000)  #0 - sys.maxsize
        client.int_model.get_null()

        with self.assertRaises(DeserializationError):
            client.int_model.get_invalid()

        # These wont fail in Python
        #client.int_model.get_overflow_int32()
        #client.int_model.get_overflow_int64()
        #client.int_model.get_underflow_int32()
        #client.int_model.get_underflow_int64()


if __name__ == '__main__':
    unittest.main()