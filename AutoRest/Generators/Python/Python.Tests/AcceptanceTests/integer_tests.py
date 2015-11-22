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
sys.path.append(join(tests, "BodyInteger"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError

from auto_rest_integer_test_service import (
    AutoRestIntegerTestService, 
    AutoRestIntegerTestServiceConfiguration)


class IntegerTests(unittest.TestCase):

    def test_integer(self):

        config = AutoRestIntegerTestServiceConfiguration("http://localhost:3000")
        config.log_level = 10
        client = AutoRestIntegerTestService(config)

        client.int_model.put_max32(sys.maxint)

        # TODO
        #client.int_model.put_min32()

        client.int_model.put_max64(sys.maxsize)
        client.int_model.put_min64(0 - sys.maxsize)
        client.int_model.get_null()

        with self.assertRaises(DeserializationError):
            client.int_model.get_invalid()

        # These wont fail in Python
        client.int_model.get_overflow_int32()
        client.int_model.get_overflow_int64()
        client.int_model.get_underflow_int32()
        client.int_model.get_underflow_int64()


if __name__ == '__main__':
    unittest.main()