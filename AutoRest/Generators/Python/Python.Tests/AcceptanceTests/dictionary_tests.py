import unittest
import subprocess
import sys
import isodate
from datetime import date, datetime, timedelta
from os.path import dirname, realpath, sep, pardir

sys.path.append(dirname(realpath(__file__)) + sep + pardir + sep + "Expected" + sep + "AcceptanceTests" + sep + "BodyDictionary")

from msrest.exceptions import DeserializationError

from auto_rest_swagger_ba_tdictionary_service import AutoRestSwaggerBATdictionaryService, AutoRestSwaggerBATdictionaryServiceConfiguration
from auto_rest_swagger_ba_tdictionary_service.models import Widget, ErrorException


def sort_test(_, x, y):

    if x == 'test_ensure_coverage' :
        return 1
    if y == 'test_ensure_coverage' :
        return -1
    return (x > y) - (x < y)

unittest.TestLoader.sortTestMethodsUsing = sort_test

class DictionaryTests(unittest.TestCase):

    #@classmethod
    #def setUpClass(cls):

    #    cls.server = subprocess.Popen("node ../../../../AutoRest/TestServer/server/startup/www.js")

    #@classmethod
    #def tearDownClass(cls):

    #    cls.server.kill()

    def test_dictionary_primitive_types(self):

        config = AutoRestSwaggerBATdictionaryServiceConfiguration("http://localhost:3000")
        config.log_level = 10
        client = AutoRestSwaggerBATdictionaryService(config)

        tfft = {"0":True, "1":False, "2":False, "3":True}
        self.assertEqual(tfft, client.dictionary.get_boolean_tfft())

        client.dictionary.put_boolean_tfft(tfft)

        invalid_null_dict = {"0":True, "1":None, "2":False}
        self.assertEqual(invalid_null_dict, client.dictionary.get_boolean_invalid_null())
        
        with self.assertRaises(DeserializationError):
            client.dictionary.get_boolean_invalid_string()

        int_valid = {"0":1, "1":-1, "2":3, "3":300}
        self.assertEqual(int_valid, client.dictionary.get_integer_valid())

        client.dictionary.put_integer_valid(int_valid)

        int_null_dict = {"0":1, "1":None, "2":0}
        self.assertEqual(int_null_dict, client.dictionary.get_int_invalid_null())
        
        with self.assertRaises(DeserializationError):
            client.dictionary.get_int_invalid_string()
        
        long_valid = {"0":1L, "1":-1, "2":3, "3":300}
        self.assertEqual(long_valid, client.dictionary.get_long_valid())

        client.dictionary.put_long_valid(long_valid)

        long_null_dict = {"0":1, "1":None, "2":0}
        self.assertEqual(long_null_dict, client.dictionary.get_long_invalid_null())

        with self.assertRaises(DeserializationError):
            client.dictionary.get_long_invalid_string()

        float_valid = {"0":0, "1":-0.01, "2":-1.2e20}
        self.assertEqual(float_valid, client.dictionary.get_float_valid())

        client.dictionary.put_float_valid(float_valid)

        float_null_dict = {"0":0.0, "1":None, "2":-1.2e20}
        self.assertEqual(float_null_dict, client.dictionary.get_float_invalid_null())

        with self.assertRaises(DeserializationError):
            client.dictionary.get_float_invalid_string()

        double_valid = {"0":0, "1":-0.01, "2":-1.2e20}
        self.assertEqual(double_valid, client.dictionary.get_double_valid())

        client.dictionary.put_double_valid(double_valid)
        
        double_null_dict = {"0":0.0, "1":None, "2":-1.2e20}
        self.assertEqual(double_null_dict, client.dictionary.get_double_invalid_null())

        with self.assertRaises(DeserializationError):
            client.dictionary.get_double_invalid_string()
        
        string_valid = {"0":"foo1", "1":"foo2", "2":"foo3"}
        self.assertEqual(string_valid, client.dictionary.get_string_valid())

        client.dictionary.put_string_valid(string_valid)
        
        string_null_dict = {"0":"foo", "1":None, "2":"foo2"}
        string_invalid_dict = {"0":"foo", "1":"123", "2":"foo2"}
        self.assertEqual(string_null_dict, client.dictionary.get_string_with_null())
        self.assertEqual(string_invalid_dict, client.dictionary.get_string_with_invalid())
        
        date1 = isodate.parse_date("2000-12-01T00:00:00Z")
        date2 = isodate.parse_date("1980-01-02T00:00:00Z")
        date3 = isodate.parse_date("1492-10-12T00:00:00Z")
        datetime1 = isodate.parse_datetime("2000-12-01T00:00:01Z")
        datetime2 = isodate.parse_datetime("1980-01-02T00:11:35+01:00")
        datetime3 = isodate.parse_datetime("1492-10-12T10:15:01-08:00")
        rfc_datetime1 = isodate.parse_datetime("2000-12-01T00:00:01")
        rfc_datetime2 = isodate.parse_datetime("1980-01-02T00:11:35")
        rfc_datetime3 = isodate.parse_datetime("1492-10-12T10:15:01")        
        duration1 = timedelta(days=123, hours=22, minutes=14, seconds=12, milliseconds=11)
        duration2 = timedelta(days=5, hours=1)
       
        valid_date_dict = {"0":date1, "1":date2, "2":date3}
        date_dictionary = client.dictionary.get_date_valid()
        self.assertEqual(date_dictionary, valid_date_dict)
        
        client.dictionary.put_date_valid(valid_date_dict)

        date_null_dict = {"0":isodate.parse_date("2012-01-01"),
                          "1":None,
                          "2":isodate.parse_date("1776-07-04")}
        self.assertEqual(date_null_dict, client.dictionary.get_date_invalid_null())
        
        with self.assertRaises(DeserializationError):
            client.dictionary.get_date_invalid_chars()

        valid_datetime_dict = {"0":datetime1, "1":datetime2, "2":datetime3}
        self.assertEqual(valid_datetime_dict, client.dictionary.get_date_time_valid())

        client.dictionary.put_date_time_valid(valid_datetime_dict)

        datetime_null_dict = {"0":isodate.parse_datetime("2000-12-01T00:00:01Z"), "1":None}
        self.assertEqual(datetime_null_dict, client.dictionary.get_date_time_invalid_null())

        with self.assertRaises(DeserializationError):
            client.dictionary.get_date_time_invalid_chars()

        valid_rfc_dict = {"0":rfc_datetime1, "1":rfc_datetime2, "2":rfc_datetime3}
        self.assertEqual(valid_rfc_dict, client.dictionary.get_date_time_rfc1123_valid())

        client.dictionary.put_date_time_rfc1123_valid(valid_rfc_dict)

        valid_duration_dict = {"0":duration1, "1":duration2}
        self.assertEqual(valid_duration_dict, client.dictionary.get_duration_valid())

        client.dictionary.put_duration_valid(valid_duration_dict)

        bytes1 = bytearray([0x0FF, 0x0FF, 0x0FF, 0x0FA])
        bytes2 = bytearray([0x01, 0x02, 0x03])
        bytes3 = bytearray([0x025, 0x029, 0x043])
        bytes4 = bytearray([0x0AB, 0x0AC, 0x0AD])

        bytes_valid = {"0":bytes1, "1":bytes2, "2":bytes3}
        client.dictionary.put_byte_valid(bytes_valid)

        bytes_result = client.dictionary.get_byte_valid()

        for key,val in bytes_valid.items():
            self.assertTrue(key in bytes_result)
            self.assertEqual(val, bytes_result[key])
        
        bytes_null = {"0":bytes4, "1":None}
        bytes_result = client.dictionary.get_byte_invalid_null()

        for key,val in bytes_null.items():
            self.assertTrue(key in bytes_result)
            self.assertEqual(val, bytes_result[key])
        


if __name__ == '__main__':
    unittest.main()