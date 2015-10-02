#--------------------------------------------------------------------------
#
# Copyright (c) Microsoft Corporation. All rights reserved. 
#
# The MIT License (MIT)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the ""Software""), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
#--------------------------------------------------------------------------

import sys

try:
    import unittest2 as unittest
except ImportError:
    import unittest

try:
    from unittest import mock
except ImportError:
    import mock

from msrest import Serialized, Deserialized
from msrest.exceptions import SerializationError, DeserializationError

from requests import Response

class TestRuntimeSerialized(unittest.TestCase):

    class TestObj(object):

        def __init__(self):

            self.attribute_map = {
                'attr_a': {'key':'id', 'type':'str'},
                'attr_b': {'key':'AttrB', 'type':'int'},
                'attr_c': {'key':'Key_C', 'type': 'bool'},
                'attr_d': {'key':'AttrD', 'type':'[int]'},
                'attr_e': {'key':'AttrE', 'type': '{float}'}
                #TODO: Add more here as more types are defined in serialized
                }

            self.attr_a = None
            self.attr_b = None
            self.attr_c = None
            self.attr_d = None
            self.attr_e = None

    def setUp(self):
        return super(TestRuntimeSerialized, self).setUp()

    def test_obj_without_attr_map(self):
        """
        Test serializing an object with no attribute_map.
        """
        test_obj = type("BadTestObj", (), {})
        serialized = Serialized(test_obj)

        with self.assertRaises(SerializationError):
            serialized()

    def test_obj_with_malformed_map(self):
        """
        Test serializing an object with a malformed attribute_map.
        """
        test_obj = type("BadTestObj", (), {"attribute_map":None})
        serialized = Serialized(test_obj)

        with self.assertRaises(SerializationError):
            serialized()

        test_obj.attribute_map = {"attr":"val"}
        serialized = Serialized(test_obj)

        with self.assertRaises(SerializationError):
            serialized()

        test_obj.attribute_map = {"attr":{"val":1}}
        serialized = Serialized(test_obj)

        with self.assertRaises(SerializationError):
            serialized()

    def test_obj_with_mismatched_map(self):
        """
        Test serializing an object with mismatching attributes and map.
        """
        test_obj = type("BadTestObj", (), {"attribute_map":None})
        test_obj.attribute_map = {"abc":{"key":"ABC", "type":"str"}}
        serialized = Serialized(test_obj)

        with self.assertRaises(SerializationError):
            serialized()

    def test_attr_none(self):
        """
        Test serializing an object with None attributes.
        """
        test_obj = self.TestObj()
        serialized = Serialized(test_obj)

        self.assertIsNone(serialized.attr_a)

        message = serialized()
        self.assertIsInstance(message, dict)
        self.assertIsNone(message['id'])

    def test_attr_int(self):
        """
        Test serializing an object with Int attributes.
        """
        test_obj = self.TestObj()
        test_obj.attr_b = 25

        serialized = Serialized(test_obj)
        self.assertEqual(serialized.attr_b, 25)

        message = serialized()
        self.assertEqual(message['AttrB'], 25)

        test_obj.attr_b = "34534"

        serialized = Serialized(test_obj)
        self.assertEqual(serialized.attr_b, 34534)

        message = serialized()
        self.assertEqual(message['AttrB'], 34534)

        test_obj.attr_b = "NotANumber"
        serialized = Serialized(test_obj)

        with self.assertRaises(SerializationError):
            serialized.attr_b

    def test_attr_str(self):
        """
        Test serializing an object with Str attributes.
        """
        test_obj = self.TestObj()
        test_obj.attr_a = "TestString"

        serialized = Serialized(test_obj)
        self.assertEqual(serialized.attr_a, "TestString")

        message = serialized()
        self.assertEqual(message['id'], "TestString")

        test_obj.attr_a = 1234

        serialized = Serialized(test_obj)
        self.assertEqual(serialized.attr_a, "1234")

        message = serialized()
        self.assertEqual(message['id'], "1234")

        test_obj.attr_a = list()

        serialized = Serialized(test_obj)
        self.assertEqual(serialized.attr_a, "[]")

        message = serialized()
        self.assertEqual(message['id'], "[]")

    def test_attr_bool(self):
        """
        Test serializing an object with bool attributes.
        """
        test_obj = self.TestObj()
        test_obj.attr_c = True

        serialized = Serialized(test_obj)
        self.assertIs(serialized.attr_c, True)

        message = serialized()
        self.assertEqual(message['Key_C'], True)

        test_obj.attr_c = ""

        serialized = Serialized(test_obj)
        self.assertIs(serialized.attr_c, False)

        message = serialized()
        self.assertEqual(message['Key_C'], False)

        test_obj.attr_c = None

        serialized = Serialized(test_obj)
        self.assertIs(serialized.attr_c, None)

        message = serialized()
        self.assertEqual(message['Key_C'], None) #TODO: Is this incorrect behaviour?

        test_obj.attr_c = "NotEmpty"

        serialized = Serialized(test_obj)
        self.assertIs(serialized.attr_c, True)

        message = serialized()
        self.assertEqual(message['Key_C'], True)

    def test_attr_list_simple(self):
        """
        Test serializing an object with simple-typed list attributes
        """
        test_obj = self.TestObj()
        test_obj.attr_d = []

        serialized = Serialized(test_obj)
        self.assertEqual(serialized.attr_d, [])

        message = serialized()
        self.assertEqual(message['AttrD'], [])

        test_obj.attr_d = [1,2,3]

        serialized = Serialized(test_obj)
        self.assertEqual(serialized.attr_d, [1,2,3])

        message = serialized()
        self.assertEqual(message['AttrD'], [1,2,3])

        test_obj.attr_d = ["1","2","3"]

        serialized = Serialized(test_obj)
        self.assertEqual(serialized.attr_d, [1,2,3])

        message = serialized()
        self.assertEqual(message['AttrD'], [1,2,3])

        test_obj.attr_d = ["test","test2","test3"]
        serialized = Serialized(test_obj)

        with self.assertRaises(SerializationError):
            serialized.attr_d

        test_obj.attr_d = "NotAList"
        serialized = Serialized(test_obj)

        with self.assertRaises(SerializationError):
            serialized.attr_d

    def test_attr_list_complex(self):
        """
        Test serializing an object with a list of complex objects as an attribute.
        """
        list_obj = type("ListObj", (), {"attribute_map":None, "abc":None})
        list_obj.attribute_map = {"abc":{"key":"ABC", "type":"int"}}
        list_obj.abc = "123"

        test_obj = type("CmplxTestObj", (), {"attribute_map":None, "test_list":None})
        test_obj.attribute_map = {"test_list":{"key":"_list", "type":"[ListObj]"}}
        test_obj.test_list = [list_obj]

        serialized = Serialized(test_obj)
        self.assertEqual(serialized.test_list[0].get('ABC'), 123)

        message = serialized()
        self.assertEqual(message, {'_list':[{'ABC':123}]})

        list_obj = type("BadListObj", (), {"map":None})
        test_obj.attribute_map = {"test_list":{"key":"_list", "type":"[BadListObj]"}}
        test_obj.test_list = [list_obj]

        serialized = Serialized(test_obj)
        with self.assertRaises(SerializationError):
            serialized.test_list

    def test_attr_dict_simple(self):
        """
        Test serializing an object with a simple dictionary attribute.
        """

        test_obj = self.TestObj()
        test_obj.attr_e = {"value": 3.14}

        serialized = Serialized(test_obj)
        self.assertEqual(serialized.attr_e["value"], 3.14)

        message = serialized()
        self.assertEqual(message['AttrE']['value'], 3.14)

        test_obj.attr_e = {1: "3.14"}

        serialized = Serialized(test_obj)
        self.assertEqual(serialized.attr_e["1"], 3.14)

        message = serialized()
        self.assertEqual(message['AttrE']['1'], 3.14)

        test_obj.attr_e = "NotADict"
        serialized = Serialized(test_obj)

        with self.assertRaises(SerializationError):
            serialized.attr_e

        test_obj.attr_e = {"value": "NotAFloat"}
        serialized = Serialized(test_obj)

        with self.assertRaises(SerializationError):
            serialized.attr_e


class TestRuntimeDeerialized(unittest.TestCase):

    class TestObj(object):

        def __init__(self):

            self.body_map = {
                'attr_a': {'key':'id', 'type':'str'},
                'attr_b': {'key':'AttrB', 'type':'int'},
                'attr_c': {'key':'Key_C', 'type': 'bool'},
                'attr_d': {'key':'AttrD', 'type':'[int]'},
                'attr_e': {'key':'AttrE', 'type': '{float}'}
                #TODO: Add more here as more types are defined in serialized
                }

            self.headers_map = {
                'client_request_id': {'key': 'client-request-id', 'type':'str'},
                'e_tag': {'key': 'etag', 'type':'str'},
                }

            self.attributes_map = {
                'status_code': {'key':'status_code', 'type':'str'}
                }

    def test_obj_with_no_attr(self):
        """
        Test deserializing an object with no attributes.
        """
        class EmptyResponse(object):
            pass

        response_data = mock.create_autospec(Response)

        with self.assertRaises(DeserializationError):
            deserializer = Deserialized(EmptyResponse, response_data)

        class BetterEmptyResponse(object):
            attributes_map = {}
            headers_map = {}
            body_map = {}

        deserializer = Deserialized(BetterEmptyResponse, response_data)
        derserialized = deserializer(None)

        self.assertIsInstance(derserialized, BetterEmptyResponse)

    def test_obj_with_malformed_map(self):
        """
        Test deserializing an object with a malformed attributes_map.
        """
        response_data = mock.create_autospec(Response)

        class BadResponse(object):
            attributes_map = None

        with self.assertRaises(DeserializationError):
            deserializer = Deserialized(BadResponse, response_data)

        class BadResponse(object):
            attributes_map = {"attr":"val"}

        with self.assertRaises(DeserializationError):
            deserializer = Deserialized(BadResponse, response_data)

        class BadResponse(object):
            attributes_map = {"attr":{"val":1}}

        with self.assertRaises(DeserializationError):
            deserializer = Deserialized(BadResponse, response_data)

    def test_obj_with_mismatched_map(self):
        """
        Test deserializing an object with mismatching attributes and map.
        """
        response_data = mock.create_autospec(Response)

        class BadResponse(object):
            attributes_map =  {"abc":{"key":"ABC", "type":"str"}}

        with self.assertRaises(DeserializationError):
            deserializer = Deserialized(BadResponse, response_data)

    def test_attr_none(self):
        """
        Test serializing an object with None attributes.
        """
        response_data = mock.create_autospec(Response)

        with self.assertRaises(DeserializationError):
            deserializer = Deserialized(self.TestObj, response_data)
            self.assertIsNone(deserializer.attr_a)

        response_data.status_code = None
        response_data.headers = {'client-request-id':None, 'etag':None}

        deserializer = Deserialized(self.TestObj, response_data)
        response = deserializer(None)

        self.assertIsNone(response.status_code)
        self.assertIsNone(response.client_request_id)
        self.assertIsNone(response.e_tag)

        self.assertFalse(hasattr(response, 'attr_a'))
        self.assertIsInstance(response, self.TestObj)
