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
sys.path.append(join(tests, "BodyBoolean"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError

from auto_rest_bool_test_service import (
    AutoRestBoolTestService, 
    AutoRestBoolTestServiceConfiguration)

from auto_rest_bool_test_service.models import ErrorException

class BoolTests(unittest.TestCase):

    def test_bool(self):

        config = AutoRestBoolTestServiceConfiguration("http://localhost:3000")
        config.log_level = 10
        client = AutoRestBoolTestService(config)

        self.assertTrue(client.bool_model.get_true())
        self.assertFalse(client.bool_model.get_false())

        client.bool_model.get_null()
        client.bool_model.put_false(False)
        client.bool_model.put_true(True)

        with self.assertRaises(ErrorException):
            client.bool_model.put_true(False)

        with self.assertRaises(DeserializationError):
            client.bool_model.get_invalid()

if __name__ == '__main__':
    unittest.main()