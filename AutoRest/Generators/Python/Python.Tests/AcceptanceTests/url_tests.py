import unittest
import subprocess
import sys
import isodate
import tempfile
from datetime import date, datetime, timedelta
import os
from os.path import dirname, pardir, join, realpath, sep, pardir

cwd = dirname(realpath(__file__))
sys.path.append(cwd + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + "ClientRuntimes" + sep + "Python" + sep + "msrest")

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "Url"))

from msrest.exceptions import DeserializationError

from auto_rest_url_test_service import AutoRestUrlTestService, AutoRestUrlTestServiceConfiguration
from auto_rest_url_test_service.models.enums import UriColor


class UrlTests(unittest.TestCase):

    def test_url_path(self):

        config = AutoRestUrlTestServiceConfiguration(None, "http://localhost:3000")
        config.log_level = 10
        client = AutoRestUrlTestService(config)

        client.paths.byte_empty(bytearray())

        with self.assertRaises(ValueError):
            client.paths.byte_null(None)

        u_bytes = bytearray(u"\u554A\u9F44\u4E02\u72DB\u72DC\uF9F1\uF92C\uF9F1\uFA0C\uFA29", encoding='utf-8')
        client.paths.byte_multi_byte(u_bytes)

        with self.assertRaises(ValueError):
            client.paths.date_null(None)

        with self.assertRaises(ValueError):
            client.paths.date_time_null(None)

        client.paths.date_time_valid(isodate.parse_datetime("2012-01-01T01:01:01Z"))
        client.paths.date_valid(isodate.parse_date("2012-01-01"))

        client.paths.double_decimal_negative(-9999999.999)
        client.paths.double_decimal_positive(9999999.999)

        client.paths.float_scientific_negative(-1.034e-20)
        client.paths.float_scientific_positive(1.034e+20)
        client.paths.get_boolean_false(False)
        client.paths.get_boolean_true(True)
        client.paths.get_int_negative_one_million(-1000000)
        client.paths.get_int_one_million(1000000)
        client.paths.get_negative_ten_billion(-10000000000)
        client.paths.get_ten_billion(10000000000)
        client.paths.string_empty("")

        with self.assertRaises(ValueError):
            client.paths.string_null(None)

        client.paths.string_url_encoded(r"begin!*'();:@ &=+$,/?#[]end")
        client.paths.enum_valid(UriColor.greencolor)

        with self.assertRaises(ValueError):
            client.paths.enum_null(None)

    def test_url_query(self):

        config = AutoRestUrlTestServiceConfiguration(None, "http://localhost:3000")
        config.log_level = 10
        client = AutoRestUrlTestService(config)

        client.queries.byte_empty(bytearray())
        u_bytes = bytearray(u"\u554A\u9F44\u4E02\u72DB\u72DC\uF9F1\uF92C\uF9F1\uFA0C\uFA29", encoding='utf-8')
        client.queries.byte_multi_byte(u_bytes)
        client.queries.byte_null(None)
        client.queries.date_null(None)
        client.queries.date_time_null(None)
        client.queries.date_time_valid(isodate.parse_datetime("2012-01-01T01:01:01Z"))
        client.queries.date_valid(isodate.parse_date("2012-01-01"))
        client.queries.double_null(None)
        client.queries.double_decimal_negative(-9999999.999)
        client.queries.double_decimal_positive(9999999.999)
        client.queries.float_scientific_negative(-1.034e-20)
        client.queries.float_scientific_positive(1.034e20)
        client.queries.float_null(None)
        client.queries.get_boolean_false(False)
        client.queries.get_boolean_true(True)
        client.queries.get_boolean_null(None)
        client.queries.get_int_negative_one_million(-1000000)
        client.queries.get_int_one_million(1000000)
        client.queries.get_int_null(None)
        client.queries.get_negative_ten_billion(-10000000000)
        client.queries.get_ten_billion(10000000000)
        client.queries.get_long_null(None)
        client.queries.string_empty("")
        client.queries.string_null(None)
        client.queries.string_url_encoded("begin!*'();:@ &=+$,/?#[]end")
        client.queries.enum_valid(UriColor.greencolor)
        client.queries.enum_null(None)
        client.queries.array_string_csv_empty([])
        client.queries.array_string_csv_null(None)
        test_array = ["ArrayQuery1", r"begin!*'();:@ &=+$,/?#[]end", None, ""]
        client.queries.array_string_csv_valid(test_array)
        client.queries.array_string_pipes_valid(test_array)
        client.queries.array_string_ssv_valid(test_array)
        client.queries.array_string_tsv_valid(test_array)

    def test_url_mixed(self):

        config = AutoRestUrlTestServiceConfiguration(None, "http://localhost:3000")
        config.log_level = 10
        client = AutoRestUrlTestService(config)

        client.config.global_string_path = "globalStringPath"
        client.config.global_string_query = "globalStringQuery"

        client.path_items.get_all_with_values("localStringPath", "pathItemStringPath",
                "localStringQuery", "pathItemStringQuery")

        client.config.global_string_query = None
        client.path_items.get_global_and_local_query_null("localStringPath", "pathItemStringPath",
                None, "pathItemStringQuery")

        client.path_items.get_global_query_null("localStringPath", "pathItemStringPath",
                "localStringQuery", "pathItemStringQuery")

        client.config.global_string_query = "globalStringQuery"
        client.path_items.get_local_path_item_query_null("localStringPath", "pathItemStringPath", 
                None, None)

if __name__ == '__main__':
    unittest.main()