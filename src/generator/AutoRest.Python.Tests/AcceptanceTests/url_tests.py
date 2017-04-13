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
from os.path import dirname, pardir, join, realpath

cwd = dirname(realpath(__file__))
log_level = int(os.environ.get('PythonLogLevel', 30))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "Url"))
sys.path.append(join(tests, "UrlMultiCollectionFormat"))

from msrest.exceptions import DeserializationError, ValidationError

from auto_rest_url_test_service import AutoRestUrlTestService
from auto_rest_url_mutli_collection_format_test_service import AutoRestUrlMutliCollectionFormatTestService
from auto_rest_url_test_service.models.auto_rest_url_test_service_enums import UriColor


class UrlTests(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.client = AutoRestUrlTestService('', base_url="http://localhost:3000")
        cls.multi_client = AutoRestUrlMutliCollectionFormatTestService("http://localhost:3000")
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

        self.client.paths.date_time_valid()
        self.client.paths.date_valid()
        self.client.paths.unix_time_url(datetime(year=2016, month=4, day=13))

        self.client.paths.double_decimal_negative()
        self.client.paths.double_decimal_positive()

        self.client.paths.float_scientific_negative()
        self.client.paths.float_scientific_positive()
        self.client.paths.get_boolean_false()
        self.client.paths.get_boolean_true()
        self.client.paths.get_int_negative_one_million()
        self.client.paths.get_int_one_million()
        self.client.paths.get_negative_ten_billion()
        self.client.paths.get_ten_billion()
        self.client.paths.string_empty()

        test_array = ["ArrayPath1", r"begin!*'();:@ &=+$,/?#[]end", None, ""]
        self.client.paths.array_csv_in_path(test_array)

        with self.assertRaises(ValidationError):
            self.client.paths.string_null(None)

        self.client.paths.string_url_encoded()
        self.client.paths.enum_valid(UriColor.greencolor)

        with self.assertRaises(ValidationError):
            self.client.paths.enum_null(None)

        self.client.paths.base64_url("lorem".encode())

    def test_url_query(self):

        self.client.config.global_string_path = ''

        self.client.queries.byte_empty(bytearray())
        u_bytes = bytearray(u"\u554A\u9F44\u4E02\u72DB\u72DC\uF9F1\uF92C\uF9F1\uFA0C\uFA29", encoding='utf-8')
        self.client.queries.byte_multi_byte(u_bytes)
        self.client.queries.byte_null()
        self.client.queries.date_null()
        self.client.queries.date_time_null()
        self.client.queries.date_time_valid()
        self.client.queries.date_valid()
        self.client.queries.double_null()
        self.client.queries.double_decimal_negative()
        self.client.queries.double_decimal_positive()
        self.client.queries.float_scientific_negative()
        self.client.queries.float_scientific_positive()
        self.client.queries.float_null()
        self.client.queries.get_boolean_false()
        self.client.queries.get_boolean_true()
        self.client.queries.get_boolean_null()
        self.client.queries.get_int_negative_one_million()
        self.client.queries.get_int_one_million()
        self.client.queries.get_int_null()
        self.client.queries.get_negative_ten_billion()
        self.client.queries.get_ten_billion()
        self.client.queries.get_long_null()
        self.client.queries.string_empty()
        self.client.queries.string_null()
        self.client.queries.string_url_encoded()
        self.client.queries.enum_valid(UriColor.greencolor)
        self.client.queries.enum_null(None)
        self.client.queries.array_string_csv_empty([])
        self.client.queries.array_string_csv_null(None)
        test_array = ["ArrayQuery1", r"begin!*'();:@ &=+$,/?#[]end", None, ""]
        self.client.queries.array_string_csv_valid(test_array)
        self.client.queries.array_string_pipes_valid(test_array)
        self.client.queries.array_string_ssv_valid(test_array)
        self.client.queries.array_string_tsv_valid(test_array)

        self.multi_client.queries.array_string_multi_empty([])
        self.multi_client.queries.array_string_multi_null()
        self.multi_client.queries.array_string_multi_valid(test_array)

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
