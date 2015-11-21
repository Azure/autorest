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
sys.path.append(join(tests, "Header"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError

from auto_rest_swagger_bat_header_service import AutoRestSwaggerBATHeaderService, AutoRestSwaggerBATHeaderServiceConfiguration
from auto_rest_swagger_bat_header_service.models.enums import GreyscaleColors


class HeaderTests(unittest.TestCase):

    def test_headers(self):

        config = AutoRestSwaggerBATHeaderServiceConfiguration("http://localhost:3000")
        config.log_level = 10
        client = AutoRestSwaggerBATHeaderService(config)

        client.header.param_integer("positive", 1)
        client.header.param_integer("negative", -2)

        response, raw = client.header.response_integer("positive", raw=True)
        self.assertEqual(1, int(raw.headers.get("value")))
        response, raw = client.header.response_integer("negative", raw=True)
        self.assertEqual(-2, int(raw.headers.get("value")))

        client.header.param_long("positive", 105)
        client.header.param_long("negative", -2)

        response, raw = client.header.response_long("positive", raw=True)
        self.assertEqual(105, int(raw.headers.get("value")))
        response, raw = client.header.response_long("negative", raw=True)
        self.assertEqual(-2, int(raw.headers.get("value")))

        client.header.param_float("positive", 0.07)
        client.header.param_float("negative", -3.0)

        response, raw = client.header.response_float("positive", raw=True)
        self.assertTrue(abs(0.07 - float(raw.headers.get("value"))) < 0.00001)
        response, raw = client.header.response_float("negative", raw=True)
        self.assertTrue(abs(-3.0 - float(raw.headers.get("value"))) < 0.00001)

        client.header.param_double("positive", 7e120)
        client.header.param_double("negative", -3.0)

        response, raw = client.header.response_double("positive", raw=True)
        self.assertEqual(7e120, float(raw.headers.get("value")))
        response, raw = client.header.response_double("negative", raw=True)
        self.assertEqual(-3.0, float(raw.headers.get("value")))

        client.header.param_bool("true", True)
        client.header.param_bool("false", False)

        response, raw = client.header.response_bool("true", raw=True)
        self.assertEqual(True, json.loads(raw.headers.get("value")))
        response, raw = client.header.response_bool("false", raw=True)
        self.assertEqual(False, json.loads(raw.headers.get("value")))

        client.header.param_string("valid", "The quick brown fox jumps over the lazy dog")
        client.header.param_string("null", None)
        client.header.param_string("empty", "")

        response, raw = client.header.response_string("valid", raw=True)
        self.assertEqual("The quick brown fox jumps over the lazy dog", raw.headers.get("value"))
        response, raw = client.header.response_string("null", raw=True)
        self.assertEqual(None, json.loads(raw.headers.get("value")))
        response, raw = client.header.response_string("empty", raw=True)
        self.assertEqual("", raw.headers.get("value"))

        client.header.param_enum("valid", GreyscaleColors.grey)
        client.header.param_enum("null", None)

        response, raw = client.header.response_enum("valid", raw=True)
        self.assertEqual("GREY", raw.headers.get("value"))
        response, raw = client.header.response_enum("null", raw=True)
        self.assertEqual(None, json.loads(raw.headers.get("value")))

        client.header.param_date("valid", isodate.parse_date("2010-01-01"))
        client.header.param_date("min", datetime.min)

        response, raw = client.header.response_date("valid", raw=True)
        self.assertEqual(isodate.parse_date("2010-01-01"), isodate.parse_date(raw.headers.get("value")))
        response, raw = client.header.response_date("min", raw=True)
        self.assertEqual(isodate.parse_date("0001-01-01"), isodate.parse_date(raw.headers.get("value")))

        client.header.param_datetime("valid", isodate.parse_datetime("2010-01-01T12:34:56Z"))
        client.header.param_datetime("min", datetime.min)

        response, raw = client.header.response_datetime("valid", raw=True)
        self.assertEqual(isodate.parse_datetime("2010-01-01T12:34:56Z"), isodate.parse_datetime(raw.headers.get("value")))
        response, raw = client.header.response_datetime("min", raw=True)
        self.assertEqual(isodate.parse_datetime("0001-01-01T00:00:00Z"), isodate.parse_datetime(raw.headers.get("value")))

        client.header.param_datetime_rfc1123("valid", isodate.parse_datetime("2010-01-01T12:34:56Z"))
        client.header.param_datetime_rfc1123("min", datetime.min)

        response, raw = client.header.response_datetime_rfc1123("valid", raw=True)
        self.assertEqual(isodate.parse_datetime("2010-01-01T12:34:56Z"), Deserializer.deserialize_rfc(raw.headers.get("value")))
        response, raw = client.header.response_datetime_rfc1123("min", raw=True)
        self.assertEqual(isodate.parse_datetime("0001-01-01T00:00:00Z"), Deserializer.deserialize_rfc(raw.headers.get("value")))

        client.header.param_duration("valid", timedelta(days=123, hours=22, minutes=14, seconds=12, milliseconds=11))

        response, raw = client.header.response_duration("valid", raw=True)
        self.assertEqual(timedelta(days=123, hours=22, minutes=14, seconds=12, milliseconds=11), Deserializer.deserialize_duration(raw.headers.get("value")))

        u_bytes = bytearray(u"\u554A\u9F44\u4E02\u72DB\u72DC\uF9F1\uF92C\uF9F1\uFA0C\uFA29", encoding='utf-8')
        client.header.param_byte("valid", u_bytes)

        response, raw = client.header.response_byte("valid", raw=True)
        self.assertEqual(u_bytes, Deserializer.deserialize_bytearray(raw.headers.get("value")))

        client.header.param_existing_key("overwrite")

        response, raw = client.header.response_existing_key(raw=True)
        self.assertEqual("overwrite", raw.headers.get('User-Agent'))

        with self.assertRaises(Exception):
            client.header.param_protected_key("text/html")

        response, raw = client.header.response_protected_key(raw=True)
        self.assertFalse("Content-Type" in raw.headers)

        custom_headers = {"x-ms-client-request-id": "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0"}
        response, raw = client.header.custom_request_id(custom_headers, raw=True)
        self.assertEqual(raw.status_code, 200)

        
if __name__ == '__main__':
    unittest.main()