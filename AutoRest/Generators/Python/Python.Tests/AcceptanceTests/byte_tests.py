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
sys.path.append(join(tests, "BodyByte"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError

from auto_rest_swagger_bat_byte_service import (
    AutoRestSwaggerBATByteService, 
    AutoRestSwaggerBATByteServiceConfiguration)


class ByteTests(unittest.TestCase):

    def test_byte(self):

        config = AutoRestSwaggerBATByteServiceConfiguration(base_url="http://localhost:3000")
        config.log_level = log_level
        client = AutoRestSwaggerBATByteService(config)

        test_bytes = bytearray([0x0FF, 0x0FE, 0x0FD, 0x0FC, 0x0FB, 0x0FA, 0x0F9, 0x0F8, 0x0F7, 0x0F6])
        client.byte.put_non_ascii(test_bytes)
        self.assertEqual(test_bytes, client.byte.get_non_ascii())
        
        self.assertIsNone(client.byte.get_null())
        self.assertEqual(bytearray(), client.byte.get_empty())

        with self.assertRaises(DeserializationError):
            client.byte.get_invalid()

if __name__ == '__main__':
    unittest.main()