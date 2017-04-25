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
import os
from datetime import date, datetime, timedelta
from os.path import dirname, pardir, join, realpath

cwd = dirname(realpath(__file__))
log_level = int(os.environ.get('PythonLogLevel', 30))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "BodyDictionary"))

from msrest.exceptions import DeserializationError

from auto_rest_swagger_ba_tdictionary_service import AutoRestSwaggerBATdictionaryService
from auto_rest_swagger_ba_tdictionary_service.models import Widget, ErrorException


class DictionaryTests(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.client = AutoRestSwaggerBATdictionaryService(base_url="http://localhost:3000")
        return super(DictionaryTests, cls).setUpClass()

    def test_dictionary_primitive_types(self):

        tfft = {"0":True, "1":False, "2":False, "3":True}
        self.assertEqual(tfft, self.client.dictionary.get_boolean_tfft())

        self.client.dictionary.put_boolean_tfft(tfft)

        invalid_null_dict = {"0":True, "1":None, "2":False}
        self.assertEqual(invalid_null_dict, self.client.dictionary.get_boolean_invalid_null())

        with self.assertRaises(DeserializationError):
            self.client.dictionary.get_boolean_invalid_string()

        int_valid = {"0":1, "1":-1, "2":3, "3":300}
        self.assertEqual(int_valid, self.client.dictionary.get_integer_valid())

        self.client.dictionary.put_integer_valid(int_valid)

        int_null_dict = {"0":1, "1":None, "2":0}
        self.assertEqual(int_null_dict, self.client.dictionary.get_int_invalid_null())

        with self.assertRaises(DeserializationError):
            self.client.dictionary.get_int_invalid_string()

        long_valid = {"0":1, "1":-1, "2":3, "3":300}
        self.assertEqual(long_valid, self.client.dictionary.get_long_valid())

        self.client.dictionary.put_long_valid(long_valid)

        long_null_dict = {"0":1, "1":None, "2":0}
        self.assertEqual(long_null_dict, self.client.dictionary.get_long_invalid_null())

        with self.assertRaises(DeserializationError):
            self.client.dictionary.get_long_invalid_string()

        float_valid = {"0":0, "1":-0.01, "2":-1.2e20}
        self.assertEqual(float_valid, self.client.dictionary.get_float_valid())

        self.client.dictionary.put_float_valid(float_valid)

        float_null_dict = {"0":0.0, "1":None, "2":-1.2e20}
        self.assertEqual(float_null_dict, self.client.dictionary.get_float_invalid_null())

        with self.assertRaises(DeserializationError):
            self.client.dictionary.get_float_invalid_string()

        double_valid = {"0":0, "1":-0.01, "2":-1.2e20}
        self.assertEqual(double_valid, self.client.dictionary.get_double_valid())

        self.client.dictionary.put_double_valid(double_valid)

        double_null_dict = {"0":0.0, "1":None, "2":-1.2e20}
        self.assertEqual(double_null_dict, self.client.dictionary.get_double_invalid_null())

        with self.assertRaises(DeserializationError):
            self.client.dictionary.get_double_invalid_string()

        string_valid = {"0":"foo1", "1":"foo2", "2":"foo3"}
        self.assertEqual(string_valid, self.client.dictionary.get_string_valid())

        self.client.dictionary.put_string_valid(string_valid)

        string_null_dict = {"0":"foo", "1":None, "2":"foo2"}
        string_invalid_dict = {"0":"foo", "1":"123", "2":"foo2"}
        self.assertEqual(string_null_dict, self.client.dictionary.get_string_with_null())
        self.assertEqual(string_invalid_dict, self.client.dictionary.get_string_with_invalid())

        date1 = isodate.parse_date("2000-12-01T00:00:00Z")
        date2 = isodate.parse_date("1980-01-02T00:00:00Z")
        date3 = isodate.parse_date("1492-10-12T00:00:00Z")
        datetime1 = isodate.parse_datetime("2000-12-01T00:00:01Z")
        datetime2 = isodate.parse_datetime("1980-01-02T00:11:35+01:00")
        datetime3 = isodate.parse_datetime("1492-10-12T10:15:01-08:00")
        rfc_datetime1 = isodate.parse_datetime("2000-12-01T00:00:01Z")
        rfc_datetime2 = isodate.parse_datetime("1980-01-02T00:11:35Z")
        rfc_datetime3 = isodate.parse_datetime("1492-10-12T10:15:01Z")
        duration1 = timedelta(days=123, hours=22, minutes=14, seconds=12, milliseconds=11)
        duration2 = timedelta(days=5, hours=1)

        valid_date_dict = {"0":date1, "1":date2, "2":date3}
        date_dictionary = self.client.dictionary.get_date_valid()
        self.assertEqual(date_dictionary, valid_date_dict)

        self.client.dictionary.put_date_valid(valid_date_dict)

        date_null_dict = {"0":isodate.parse_date("2012-01-01"),
                          "1":None,
                          "2":isodate.parse_date("1776-07-04")}
        self.assertEqual(date_null_dict, self.client.dictionary.get_date_invalid_null())

        with self.assertRaises(DeserializationError):
            self.client.dictionary.get_date_invalid_chars()

        valid_datetime_dict = {"0":datetime1, "1":datetime2, "2":datetime3}
        self.assertEqual(valid_datetime_dict, self.client.dictionary.get_date_time_valid())

        self.client.dictionary.put_date_time_valid(valid_datetime_dict)

        datetime_null_dict = {"0":isodate.parse_datetime("2000-12-01T00:00:01Z"), "1":None}
        self.assertEqual(datetime_null_dict, self.client.dictionary.get_date_time_invalid_null())

        with self.assertRaises(DeserializationError):
            self.client.dictionary.get_date_time_invalid_chars()

        valid_rfc_dict = {"0":rfc_datetime1, "1":rfc_datetime2, "2":rfc_datetime3}
        self.assertEqual(valid_rfc_dict, self.client.dictionary.get_date_time_rfc1123_valid())

        self.client.dictionary.put_date_time_rfc1123_valid(valid_rfc_dict)

        valid_duration_dict = {"0":duration1, "1":duration2}
        self.assertEqual(valid_duration_dict, self.client.dictionary.get_duration_valid())

        self.client.dictionary.put_duration_valid(valid_duration_dict)

        bytes1 = bytearray([0x0FF, 0x0FF, 0x0FF, 0x0FA])
        bytes2 = bytearray([0x01, 0x02, 0x03])
        bytes3 = bytearray([0x025, 0x029, 0x043])
        bytes4 = bytearray([0x0AB, 0x0AC, 0x0AD])

        bytes_valid = {"0":bytes1, "1":bytes2, "2":bytes3}
        self.client.dictionary.put_byte_valid(bytes_valid)

        bytes_result = self.client.dictionary.get_byte_valid()
        self.assertEqual(bytes_valid, bytes_result)

        bytes_null = {"0":bytes4, "1":None}
        bytes_result = self.client.dictionary.get_byte_invalid_null()
        self.assertEqual(bytes_null, bytes_result)

        test_dict = {'0': 'a string that gets encoded with base64url'.encode(),
                     '1': 'test string'.encode(),
                     '2': 'Lorem ipsum'.encode()}
        self.assertEqual(self.client.dictionary.get_base64_url(), test_dict)

    def test_basic_dictionary_parsing(self):

        self.assertEqual({}, self.client.dictionary.get_empty())

        self.client.dictionary.put_empty({})

        self.assertIsNone(self.client.dictionary.get_null())

        with self.assertRaises(DeserializationError):
            self.client.dictionary.get_invalid()

        # {null:"val1"} is not standard JSON format (JSON require key as string. Should we skip this case
        #self.assertEqual({"None":"val1"}, self.client.dictionary.get_null_key())
        self.assertEqual({"key1":None}, self.client.dictionary.get_null_value())
        self.assertEqual({"":"val1"}, self.client.dictionary.get_empty_string_key())

    def test_dictionary_composed_types(self):

        test_product1 = Widget(integer=1, string="2")
        test_product2 = Widget(integer=3, string="4")
        test_product3 = Widget(integer=5, string="6")
        test_dict = {"0":test_product1, "1":test_product2, "2":test_product3}

        self.assertIsNone(self.client.dictionary.get_complex_null())
        self.assertEqual({}, self.client.dictionary.get_complex_empty())

        self.client.dictionary.put_complex_valid(test_dict)
        complex_result = self.client.dictionary.get_complex_valid()
        self.assertEqual(test_dict, complex_result)

        list_dict = {"0":["1","2","3"], "1":["4","5","6"], "2":["7","8","9"]}
        self.client.dictionary.put_array_valid(list_dict)

        array_result = self.client.dictionary.get_array_valid()
        self.assertEqual(list_dict, array_result)

        dict_dict = {"0":{"1":"one","2":"two","3":"three"},
                     "1":{"4":"four","5":"five","6":"six"},
                     "2":{"7":"seven","8":"eight","9":"nine"}}
        self.client.dictionary.put_dictionary_valid(dict_dict)

        dict_result = self.client.dictionary.get_dictionary_valid()
        self.assertEqual(dict_dict, dict_result)

        self.assertIsNone(self.client.dictionary.get_complex_null())
        self.assertEqual({}, self.client.dictionary.get_complex_empty())

        test_dict2 = {"0":test_product1, "1":None, "2":test_product3}
        complex_result = self.client.dictionary.get_complex_item_null()
        self.assertEqual(complex_result, test_dict2)

        test_dict3 = {"0":test_product1, "1":Widget(), "2":test_product3}
        complex_result = self.client.dictionary.get_complex_item_empty()
        self.assertEqual(complex_result, test_dict3)

        self.assertIsNone(self.client.dictionary.get_array_null())
        self.assertEqual({}, self.client.dictionary.get_array_empty())

        list_dict = {"0":["1","2","3"], "1":None, "2":["7","8","9"]}
        array_result = self.client.dictionary.get_array_item_null()
        self.assertEqual(list_dict, array_result)

        list_dict = {"0":["1","2","3"], "1":[], "2":["7","8","9"]}
        array_result = self.client.dictionary.get_array_item_empty()
        self.assertEqual(list_dict, array_result)

        self.assertIsNone(self.client.dictionary.get_dictionary_null())
        self.assertEqual({}, self.client.dictionary.get_dictionary_empty())

        dict_dict = {"0":{"1":"one","2":"two","3":"three"},
                     "1":None,
                     "2":{"7":"seven","8":"eight","9":"nine"}}
        dict_result = self.client.dictionary.get_dictionary_item_null()
        self.assertEqual(dict_dict, dict_result)

        dict_dict = {"0":{"1":"one","2":"two","3":"three"},
                     "1":{},
                     "2":{"7":"seven","8":"eight","9":"nine"}}
        dict_result = self.client.dictionary.get_dictionary_item_empty()
        self.assertEqual(dict_dict, dict_result)


if __name__ == '__main__':
    unittest.main()
