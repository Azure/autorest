# --------------------------------------------------------------------------
#
# Copyright (c) Microsoft Corporation. All rights reserved.
#
# The MIT License (MIT)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the ""Software""), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#
# --------------------------------------------------------------------------

import unittest
import subprocess
import sys
import isodate
import tempfile
from datetime import date, datetime, timedelta
import os
from os.path import dirname, pardir, join, realpath, sep, pardir

cwd = dirname(realpath(__file__))
root = realpath(join(cwd , pardir, pardir, pardir, pardir, pardir))
sys.path.append(join(root, "ClientRuntimes" , "Python", "msrest"))
log_level = int(os.environ.get('PythonLogLevel', 30))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "Url"))

from msrest.exceptions import DeserializationError, ValidationError

from autoresturltestservice import AutoRestUrlTestService
from autoresturltestservice.models.auto_rest_url_test_service_enums import UriColor


class UrlTests(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.client = AutoRestUrlTestService('', base_url="http://localhost:3000")
        return super(UrlTests, cls).setUpClass()

    def test_url_path(self):

        self.client.config.global_string_path = ''

        self.client.paths.byte_empty(bytearray())

        with self.assertRaises(ValidationError):
            self.client.paths.byte_null(None)

        u_bytes = bytearray(u"\u554A\u9F44\u4E02\u72DB\u72DC\uF9F1\uF92C\uF9F1\uFA0C\uFA29", encoding='utf-8')
        self.client.paths.byte_multi_byte(u_bytes)

        with self.assertRaises(ValidationError):
            self.client.paths.date_null(None)

        with self.assertRaises(ValidationError):
            self.client.paths.date_time_null(None)

        self.client.paths.date_time_valid(isodate.parse_datetime("2012-01-01T01:01:01Z"))
        self.client.paths.date_valid(isodate.parse_date("2012-01-01"))
        self.client.paths.unix_time_url(datetime(year=2016, month=4, day=13))

        self.client.paths.double_decimal_negative(-9999999.999)
        self.client.paths.double_decimal_positive(9999999.999)

        self.client.paths.float_scientific_negative(-1.034e-20)
        self.client.paths.float_scientific_positive(1.034e+20)
        self.client.paths.get_boolean_false(False)
        self.client.paths.get_boolean_true(True)
        self.client.paths.get_int_negative_one_million(-1000000)
        self.client.paths.get_int_one_million(1000000)
        self.client.paths.get_negative_ten_billion(-10000000000)
        self.client.paths.get_ten_billion(10000000000)
        self.client.paths.string_empty("")

        test_array = ["ArrayPath1", r"begin!*'();:@ &=+$,/?#[]end", None, ""]
        self.client.paths.array_csv_in_path(test_array)

        with self.assertRaises(ValidationError):
            self.client.paths.string_null(None)

        self.client.paths.string_url_encoded(r"begin!*'();:@ &=+$,/?#[]end")
        self.client.paths.enum_valid(UriColor.greencolor)

        with self.assertRaises(ValidationError):
            self.client.paths.enum_null(None)

        self.client.paths.base64_url("lorem".encode())

    def test_url_query(self):

        self.client.config.global_string_path = ''

        self.client.queries.byte_empty(bytearray())
        u_bytes = bytearray(u"\u554A\u9F44\u4E02\u72DB\u72DC\uF9F1\uF92C\uF9F1\uFA0C\uFA29", encoding='utf-8')
        self.client.queries.byte_multi_byte(u_bytes)
        self.client.queries.byte_null(None)
        self.client.queries.date_null(None)
        self.client.queries.date_time_null(None)
        self.client.queries.date_time_valid(isodate.parse_datetime("2012-01-01T01:01:01Z"))
        self.client.queries.date_valid(isodate.parse_date("2012-01-01"))
        self.client.queries.double_null(None)
        self.client.queries.double_decimal_negative(-9999999.999)
        self.client.queries.double_decimal_positive(9999999.999)
        self.client.queries.float_scientific_negative(-1.034e-20)
        self.client.queries.float_scientific_positive(1.034e20)
        self.client.queries.float_null(None)
        self.client.queries.get_boolean_false(False)
        self.client.queries.get_boolean_true(True)
        self.client.queries.get_boolean_null(None)
        self.client.queries.get_int_negative_one_million(-1000000)
        self.client.queries.get_int_one_million(1000000)
        self.client.queries.get_int_null(None)
        self.client.queries.get_negative_ten_billion(-10000000000)
        self.client.queries.get_ten_billion(10000000000)
        self.client.queries.get_long_null(None)
        self.client.queries.string_empty("")
        self.client.queries.string_null(None)
        self.client.queries.string_url_encoded("begin!*'();:@ &=+$,/?#[]end")
        self.client.queries.enum_valid(UriColor.greencolor)
        self.client.queries.enum_null(None)
        self.client.queries.array_string_csv_empty([])
        self.client.queries.array_string_csv_null(None)
        test_array = ["ArrayQuery1", r"begin!*'();:@ &=+$,/?#[]end", None, ""]
        self.client.queries.array_string_csv_valid(test_array)
        self.client.queries.array_string_pipes_valid(test_array)
        self.client.queries.array_string_ssv_valid(test_array)
        self.client.queries.array_string_tsv_valid(test_array)

    def test_url_mixed(self):

        self.client.config.global_string_path = "globalStringPath"
        self.client.config.global_string_query = "globalStringQuery"

        self.client.path_items.get_all_with_values("localStringPath", "pathItemStringPath",
                "localStringQuery", "pathItemStringQuery")

        self.client.config.global_string_query = None
        self.client.path_items.get_global_and_local_query_null("localStringPath", "pathItemStringPath",
                None, "pathItemStringQuery")

        self.client.path_items.get_global_query_null("localStringPath", "pathItemStringPath",
                "localStringQuery", "pathItemStringQuery")

        self.client.config.global_string_query = "globalStringQuery"
        self.client.path_items.get_local_path_item_query_null("localStringPath", "pathItemStringPath", 
                None, None)

if __name__ == '__main__':
    unittest.main()