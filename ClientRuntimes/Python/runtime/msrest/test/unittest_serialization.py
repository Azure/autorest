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
import json
import isodate
from datetime import datetime

try:
    import unittest2 as unittest
except ImportError:
    import unittest

try:
    from unittest import mock
except ImportError:
    import mock

from msrest.serialization import Model
from msrest import Serializer, Deserializer
from msrest.exceptions import SerializationError, DeserializationError

from requests import Response

class TestRuntimeSerialized(unittest.TestCase):

    class TestObj(Model):

        _required = []
        _attribute_map = {
            'attr_a': {'key':'id', 'type':'str'},
            'attr_b': {'key':'AttrB', 'type':'int'},
            'attr_c': {'key':'Key_C', 'type': 'bool'},
            'attr_d': {'key':'AttrD', 'type':'[int]'},
            'attr_e': {'key':'AttrE', 'type': '{float}'}
            #TODO: Add more here as more types are defined in serialized
            }

        def __init__(self):

            self.attr_a = None
            self.attr_b = None
            self.attr_c = None
            self.attr_d = None
            self.attr_e = None

    def setUp(self):
        self.s = Serializer()
        return super(TestRuntimeSerialized, self).setUp()

    def test_obj_without_attr_map(self):
        """
        Test serializing an object with no attribute_map.
        """
        test_obj = type("BadTestObj", (), {})

        with self.assertRaises(SerializationError):
            self.s(test_obj)

    def test_obj_with_malformed_map(self):
        """
        Test serializing an object with a malformed attribute_map.
        """
        test_obj = type("BadTestObj", (Model,), {"_attribute_map":None})

        with self.assertRaises(SerializationError):
            self.s(test_obj)

        test_obj._attribute_map = {"attr":"val"}

        with self.assertRaises(SerializationError):
            self.s(test_obj)

        test_obj._attribute_map = {"attr":{"val":1}}

        with self.assertRaises(SerializationError):
            self.s(test_obj)

    def test_obj_with_mismatched_map(self):
        """
        Test serializing an object with mismatching attributes and map.
        """
        test_obj = type("BadTestObj", (Model,), {"_attribute_map":None})
        test_obj._attribute_map = {"abc":{"key":"ABC", "type":"str"}}

        with self.assertRaises(SerializationError):
            self.s(test_obj)

    def test_attr_none(self):
        """
        Test serializing an object with None attributes.
        """
        test_obj = self.TestObj()
        message = self.s(test_obj)

        self.assertIsInstance(message, dict)
        self.assertFalse('id' in message)

    def test_attr_int(self):
        """
        Test serializing an object with Int attributes.
        """
        test_obj = self.TestObj()
        self.TestObj._required = ['attr_b']
        test_obj.attr_b = None

        with self.assertRaises(SerializationError):
            self.s(test_obj)

        test_obj.attr_b = 25

        message = self.s(test_obj)
        self.assertEqual(message['AttrB'], 25)

        test_obj.attr_b = "34534"

        message = self.s(test_obj)
        self.assertEqual(message['AttrB'], 34534)

        test_obj.attr_b = "NotANumber"

        with self.assertRaises(SerializationError):
            self.s(test_obj)

        self.TestObj._required = []

    def test_attr_str(self):
        """
        Test serializing an object with Str attributes.
        """
        test_obj = self.TestObj()
        self.TestObj._required = ['attr_a']
        test_obj.attr_a = None

        with self.assertRaises(SerializationError):
            self.s(test_obj)

        self.TestObj._required = []
        test_obj.attr_a = "TestString"

        message = self.s(test_obj)
        self.assertEqual(message['id'], "TestString")

        test_obj.attr_a = 1234

        message = self.s(test_obj)
        self.assertEqual(message['id'], "1234")

        test_obj.attr_a = list()

        message = self.s(test_obj)
        self.assertFalse('id' in message)

        test_obj.attr_a = [1]

        message = self.s(test_obj)
        self.assertEqual(message['id'], "[1]")

    def test_attr_bool(self):
        """
        Test serializing an object with bool attributes.
        """
        test_obj = self.TestObj()
        test_obj.attr_c = True

        message = self.s(test_obj)
        self.assertEqual(message['Key_C'], True)

        test_obj.attr_c = ""

        message = self.s(test_obj)
        self.assertFalse('Key_C' in message)

        test_obj.attr_c = None

        message = self.s(test_obj)
        self.assertFalse('Key_C' in message)

        test_obj.attr_c = "NotEmpty"

        message = self.s(test_obj)
        self.assertEqual(message['Key_C'], True)

    def test_attr_list_simple(self):
        """
        Test serializing an object with simple-typed list attributes
        """
        test_obj = self.TestObj()
        test_obj.attr_d = []

        message = self.s(test_obj)
        self.assertFalse('AttrD' in message)

        test_obj.attr_d = [1,2,3]

        message = self.s(test_obj)
        self.assertEqual(message['AttrD'], [1,2,3])

        test_obj.attr_d = ["1","2","3"]

        message = self.s(test_obj)
        self.assertEqual(message['AttrD'], [1,2,3])

        test_obj.attr_d = ["test","test2","test3"]

        with self.assertRaises(SerializationError):
            self.s(test_obj)

        test_obj.attr_d = "NotAList"

        with self.assertRaises(SerializationError):
            self.s(test_obj)

    def test_attr_list_complex(self):
        """
        Test serializing an object with a list of complex objects as an attribute.
        """
        list_obj = type("ListObj", (Model,), {"_attribute_map":None,
                                        "_required":[],
                                        "abc":None})
        list_obj._attribute_map = {"abc":{"key":"ABC", "type":"int"}}
        list_obj.abc = "123"

        test_obj = type("CmplxTestObj", (Model,), {"_attribute_map":None,
                                             "_required":[],
                                             "test_list":None})

        test_obj._attribute_map = {"test_list":{"key":"_list", "type":"[ListObj]"}}
        test_obj.test_list = [list_obj]

        message = self.s(test_obj)
        self.assertEqual(message, {'_list':[{'ABC':123}]})

        list_obj = type("BadListObj", (Model,), {"map":None})
        test_obj._attribute_map = {"test_list":{"key":"_list", "type":"[BadListObj]"}}
        test_obj.test_list = [list_obj]

        with self.assertRaises(SerializationError):
            self.s(test_obj)

    def test_attr_dict_simple(self):
        """
        Test serializing an object with a simple dictionary attribute.
        """

        test_obj = self.TestObj()
        test_obj.attr_e = {"value": 3.14}

        message = self.s(test_obj)
        self.assertEqual(message['AttrE']['value'], 3.14)

        test_obj.attr_e = {1: "3.14"}

        message = self.s(test_obj)
        self.assertEqual(message['AttrE']['1'], 3.14)

        test_obj.attr_e = "NotADict"

        with self.assertRaises(SerializationError):
            self.s(test_obj)

        test_obj.attr_e = {"value": "NotAFloat"}

        with self.assertRaises(SerializationError):
            self.s(test_obj)

    def test_serialize_datetime(self):

        date_obj = isodate.parse_datetime('2015-01-01T00:00:00')
        date_str = Serializer.serialize_iso(date_obj)

        self.assertEqual(date_str, '2015-01-01T00:00:00.000Z')

        date_obj = isodate.parse_datetime('1999-12-31T23:59:59-12:00')
        date_str = Serializer.serialize_iso(date_obj)

        self.assertEqual(date_str, '2000-01-01T11:59:59.000Z')

        with self.assertRaises(SerializationError):
            date_obj = isodate.parse_datetime('9999-12-31T23:59:59-12:00')
            date_str = Serializer.serialize_iso(date_obj)

        with self.assertRaises(SerializationError):
            date_obj = isodate.parse_datetime('0001-01-01T00:00:00+23:59')
            date_str = Serializer.serialize_iso(date_obj)


        date_obj = isodate.parse_datetime("2015-06-01T16:10:08.0121-07:00")
        date_str = Serializer.serialize_iso(date_obj)

        self.assertEqual(date_str, '2015-06-01T23:10:08.0121Z')

        date_obj = datetime.min
        date_str = Serializer.serialize_iso(date_obj)
        self.assertEqual(date_str, '0001-01-01T00:00:00.000Z')

        date_obj = datetime.max
        date_str = Serializer.serialize_iso(date_obj)
        self.assertEqual(date_str, '9999-12-31T23:59:59.999999Z')


    def test_serialize_primitive_types(self):

        a = Serializer.serialize_data(Serializer, 1, 'int', True)
        self.assertEqual(a, 1)

        b = Serializer.serialize_data(Serializer, True, 'bool', True)
        self.assertEqual(b, True)

        c = Serializer.serialize_data(Serializer, 'True', 'str', True)
        self.assertEqual(c, 'True')

        d = Serializer.serialize_data(Serializer, 100.0123, 'float', True)
        self.assertEqual(d, 100.0123)

    def test_serialize_empty_iter(self):

        a = Serializer.serialize_dict(Serializer, {}, 'int', False)
        self.assertEqual(a, {})

        b = Serializer.serialize_iter(Serializer, [], 'int', False)
        self.assertEqual(b, [])

    def test_serialize_json_obj(self):

        class ComplexId(Model):

            _required = []
            _attribute_map = {'id':{'key':'id','type':'int'},
                              'name':{'key':'name','type':'str'},
                              'age':{'key':'age','type':'float'},
                              'male':{'key':'male','type':'bool'},
                              'birthday':{'key':'birthday','type':'iso-8601'},
                              'anniversary':{'key':'anniversary', 'type':'iso-8601'}}

            id = 1
            name = "Joey"
            age = 23.36
            male = True
            birthday = '1992-01-01T00:00:00.000Z'
            anniversary = isodate.parse_datetime('2013-12-08T00:00:00')

        class ComplexJson(Model):

            _required = []
            _attribute_map = {'p1':{'key':'p1','type':'str'},
                              'p2':{'key':'p2','type':'str'},
                              'top_date':{'key':'top_date', 'type':'iso-8601'},
                              'top_dates':{'key':'top_dates', 'type':'[iso-8601]'},
                              'insider':{'key':'insider','type':'{iso-8601}'},
                              'top_complex':{'key':'top_complex','type':'ComplexId'}}

            p1 = 'value1'
            p2 = 'value2'
            top_date = isodate.parse_datetime('2014-01-01T00:00:00')
            top_dates = [isodate.parse_datetime('1900-01-01T00:00:00'), isodate.parse_datetime('1901-01-01T00:00:00')]
            insider = {
                'k1': isodate.parse_datetime('2015-01-01T00:00:00'),
                'k2': isodate.parse_datetime('2016-01-01T00:00:00'),
                'k3': isodate.parse_datetime('2017-01-01T00:00:00')}
            top_complex = ComplexId()

        message =self.s(ComplexJson())

        output = { 
            'p1': 'value1', 
            'p2': 'value2', 
            'top_date': '2014-01-01T00:00:00.000Z', 
            'top_dates': [ 
                '1900-01-01T00:00:00.000Z', 
                '1901-01-01T00:00:00.000Z' 
            ], 
            'insider': {
                'k1': '2015-01-01T00:00:00.000Z', 
                'k2': '2016-01-01T00:00:00.000Z', 
                'k3': '2017-01-01T00:00:00.000Z' 
            }, 
            'top_complex': { 
                'id': 1, 
                'name': 'Joey', 
                'age': 23.36, 
                'male': True, 
                'birthday': '1992-01-01T00:00:00.000Z', 
                'anniversary': '2013-12-08T00:00:00.000Z', 
            } 
        }
        self.maxDiff = None
        self.assertEqual(message, output) 

    def test_polymorphic_serialization(self):

        self.maxDiff = None
        class Zoo(Model):

            _attribute_map = {
                "animals":{"key":"Animals", "type":"[Animal]"},
                }

            def __init__(self):
                self.animals = None

        class Animal(Model):

            _attribute_map = {
                "name":{"key":"Name", "type":"str"}
                }

            _subtype_map = {
                'dType': {"cat":"Cat", "dog":"Dog"}
                }

            def __init__(self):
                self.name = None

        class Dog(Animal):

            _attribute_map = {
                "likes_dog_food":{"key":"likesDogFood","type":"bool"}
                }

            def __init__(self):
                self.likes_dog_food = None
                super(Dog, self).__init__()

        class Cat(Animal):

            _attribute_map = {
                "likes_mice":{"key":"likesMice","type":"bool"},
                "dislikes":{"key":"dislikes","type":"Animal"}
                }

            _subtype_map = {
                "dType":{"siamese":"Siamese"}
                }

            def __init__(self):
                self.likes_mice = None
                self.dislikes = None
                super(Cat, self).__init__()

        class Siamese(Cat):

            _attribute_map = {
                "color":{"key":"Color", "type":"str"}
                }

            def __init__(self):
                self.color = None
                super(Siamese, self).__init__()

        message = {
            "Animals": [ 
            { 
            "dType": "dog", 
            "likesDogFood": True, 
            "Name": "Fido" 
            }, 
            { 
            "dType": "cat", 
            "likesMice": False, 
            "dislikes": { 
            "dType": "dog", 
            "likesDogFood": True, 
            "Name": "Angry" 
            }, 
            "Name": "Felix" 
            }, 
            { 
            "dType": "siamese", 
            "Color": "grey", 
            "likesMice": True, 
            "Name": "Finch" 
            }]}

        zoo = Zoo()
        angry = Dog()
        angry.name = "Angry"
        angry.likes_dog_food = True

        fido = Dog()
        fido.name = "Fido"
        fido.likes_dog_food = True

        felix = Cat()
        felix.name = "Felix"
        felix.likes_mice = False
        felix.dislikes = angry

        finch = Siamese()
        finch.name = "Finch"
        finch.color = "grey"
        finch.likes_mice = True

        zoo.animals = [fido, felix, finch]

        serialized = self.s(zoo)
        self.assertEqual(serialized, message)


class TestRuntimeDeserialized(unittest.TestCase):

    class TestObj(object):

        _required = []
        _attribute_map = {
            'attr_a': {'key':'id', 'type':'str'},
            'attr_b': {'key':'AttrB', 'type':'int'},
            'attr_c': {'key':'Key_C', 'type': 'bool'},
            'attr_d': {'key':'AttrD', 'type':'[int]'},
            'attr_e': {'key':'AttrE', 'type': '{float}'}
            #TODO: Add more here as more types are defined in serialized
            }

        _header_map = {
            'client_request_id': {'key': 'client-request-id', 'type':'str'},
            'e_tag': {'key': 'etag', 'type':'str'},
            }

        _response_map = {
            'status_code': {'key':'status_code', 'type':'str'}
            }

    def setUp(self):
        self.d = Deserializer()
        return super().setUp()

    def test_obj_with_no_attr(self):
        """
        Test deserializing an object with no attributes.
        """
        class EmptyResponse(object):
            
            def __init__(*args, **kwargs):
                pass

        response_data = mock.create_autospec(Response)
        response_data.content = json.dumps({"a":"b"})

        with self.assertRaises(DeserializationError):
            self.d(EmptyResponse, response_data)

        class BetterEmptyResponse(object):
            _attribute_map = {}
            _header_map = {}

            def __init__(*args, **kwargs):
                pass

        derserialized = self.d(BetterEmptyResponse, response_data)
        self.assertIsInstance(derserialized, BetterEmptyResponse)

    def test_obj_with_malformed_map(self):
        """
        Test deserializing an object with a malformed attributes_map.
        """
        response_data = mock.create_autospec(Response)
        response_data.content = json.dumps({"a":"b"})

        class BadResponse(object):
            _attribute_map = None

            def __init__(*args, **kwargs):
                pass

        with self.assertRaises(DeserializationError):
            self.d(BadResponse, response_data)

        class BadResponse(object):
            _attribute_map = {"attr":"val"}

            def __init__(*args, **kwargs):
                pass

        with self.assertRaises(DeserializationError):
            self.d(BadResponse, response_data)

        class BadResponse(object):
            _attribute_map = {"attr":{"val":1}}

            def __init__(*args, **kwargs):
                pass

        with self.assertRaises(DeserializationError):
            self.d(BadResponse, response_data)

    def test_attr_none(self):
        """
        Test serializing an object with None attributes.
        """
        response_data = mock.create_autospec(Response)

        with self.assertRaises(DeserializationError):
            self.d(self.TestObj, response_data)

        response_data.status_code = None
        response_data.headers = {'client-request-id':None, 'etag':None}
        response_data.content = None

        response = self.d(self.TestObj, response_data)

        self.assertIsNone(response.status_code)
        self.assertIsNone(response.client_request_id)
        self.assertIsNone(response.e_tag)

        self.assertFalse(hasattr(response, 'attr_a'))
        self.assertIsInstance(response, self.TestObj)

    def test_attr_int(self):
        """
        Test deserializing an object with Int attributes.
        """
        response_data = mock.create_autospec(Response)
        response_data.status_code = 200
        response_data.headers = {'client-request-id':"123", 'etag':456.3}
        response_data.content = None

        response = self.d(self.TestObj, response_data)

        self.assertEqual(response.status_code, "200")
        self.assertEqual(response.client_request_id, "123")
        self.assertEqual(response.e_tag, "456.3")

        response_data.content = json.dumps({'AttrB':'1234'})
        response = self.d(self.TestObj, response_data)
        self.assertTrue(hasattr(response, 'attr_b'))
        self.assertEqual(response.attr_b, 1234)

        with self.assertRaises(DeserializationError):
            response_data.content = json.dumps({'AttrB':'NotANumber'})
            response = self.d(self.TestObj, response_data)

    def test_attr_str(self):
        """
        Test deserializing an object with Str attributes.
        """
        response_data = mock.create_autospec(Response)
        response_data.status_code = 200
        response_data.headers = {'client-request-id': 'a', 'etag': 'b'}
        response_data.content = json.dumps({'id':'InterestingValue'})

        response = self.d(self.TestObj, response_data)
        self.assertTrue(hasattr(response, 'attr_a'))
        self.assertEqual(response.attr_a, 'InterestingValue')

        response_data.content = json.dumps({'id':1234})
        response = self.d(self.TestObj, response_data)
        self.assertEqual(response.attr_a, '1234')

        response_data.content = json.dumps({'id':list()})
        response = self.d(self.TestObj, response_data)
        self.assertEqual(response.attr_a, '[]')

        response_data.content = json.dumps({'id':None})
        response = self.d(self.TestObj, response_data)
        self.assertEqual(response.attr_a, None)

    def test_attr_bool(self):
        """
        Test deserializing an object with bool attributes.
        """
        response_data = mock.create_autospec(Response)
        response_data.status_code = 200
        response_data.headers = {'client-request-id': 'a', 'etag': 'b'}
        response_data.content = json.dumps({'Key_C':True})

        response = self.d(self.TestObj, response_data)

        self.assertTrue(hasattr(response, 'attr_c'))
        self.assertEqual(response.attr_c, True)

        response_data.content = json.dumps({'Key_C':[]})
        response = self.d(self.TestObj, response_data)
        self.assertEqual(response.attr_c, False)

        response_data.content = json.dumps({'Key_C':0})
        response = self.d(self.TestObj, response_data)
        self.assertEqual(response.attr_c, False)

        response_data.content = json.dumps({'Key_C':"value"})
        response = self.d(self.TestObj, response_data)
        self.assertEqual(response.attr_c, True)

    def test_attr_list_simple(self):
        """
        Test deserializing an object with simple-typed list attributes
        """
        response_data = mock.create_autospec(Response)
        response_data.status_code = 200
        response_data.headers = {'client-request-id': 'a', 'etag': 'b'}
        response_data.content = json.dumps({'AttrD': []})

        response = self.d(self.TestObj, response_data)
        deserialized_list = [d for d in response.attr_d]
        self.assertEqual(deserialized_list, [])

        response_data.content = json.dumps({'AttrD': [1,2,3]})
        response = self.d(self.TestObj, response_data)
        deserialized_list = [d for d in response.attr_d]
        self.assertEqual(deserialized_list, [1,2,3])

        response_data.content = json.dumps({'AttrD': ["1","2","3"]})
        response = self.d(self.TestObj, response_data)
        deserialized_list = [d for d in response.attr_d]
        self.assertEqual(deserialized_list, [1,2,3])

        response_data.content = json.dumps({'AttrD': ["test","test2","test3"]})
        with self.assertRaises(DeserializationError):
            response = self.d(self.TestObj, response_data)
            deserialized_list = [d for d in response.attr_d]
        
        response_data.content = json.dumps({'AttrD': "NotAList"})
        with self.assertRaises(DeserializationError):
            response = self.d(self.TestObj, response_data)
            deserialized_list = [d for d in response.attr_d]

    def test_attr_list_complex(self):
        """
        Test deserializing an object with a list of complex objects as an attribute.
        """
        class ListObj(object):
            _attribute_map = {"abc":{"key":"ABC", "type":"int"}}

            def __init__(*args, **kwargs):
                pass

        class CmplxTestObj(object):

            def __init__(self, **kwargs):
                self._response_map = {}
                self._header_map = {}
                self._attribute_map = {'attr_a': {'key':'id', 'type':'[ListObj]'}}


        response_data = mock.create_autospec(Response)
        response_data.status_code = 200
        response_data.headers = {'client-request-id': 'a', 'etag': 'b'}
        response_data.content = json.dumps({"id":[{"ABC": "123"}]})

        d = Deserializer({'ListObj':ListObj})
        response = d(CmplxTestObj, response_data)
        deserialized_list = [a for a in response.attr_a]

        self.assertIsInstance(deserialized_list[0], ListObj)
        self.assertEqual(deserialized_list[0].abc, 123)

    def test_deserialize_datetime(self):

        a = Deserializer.deserialize_iso('9999-12-31T23:59:59+23:59')
        utc = a.utctimetuple()

        self.assertEqual(utc.tm_year, 9999)
        self.assertEqual(utc.tm_mon, 12)
        self.assertEqual(utc.tm_mday, 31)
        self.assertEqual(utc.tm_hour, 0)
        self.assertEqual(utc.tm_min, 0)
        self.assertEqual(utc.tm_sec, 59)
        self.assertEqual(a.microsecond, 0)

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso('9999-12-31T23:59:59-23:59')

        a = Deserializer.deserialize_iso('1999-12-31T23:59:59-23:59')
        utc = a.utctimetuple()
        self.assertEqual(utc.tm_year, 2000)
        self.assertEqual(utc.tm_mon, 1)
        self.assertEqual(utc.tm_mday, 1)
        self.assertEqual(utc.tm_hour, 23)
        self.assertEqual(utc.tm_min, 58)
        self.assertEqual(utc.tm_sec, 59)
        self.assertEqual(a.microsecond, 0)

        a = Deserializer.deserialize_iso('0001-01-01T23:59:00+23:59')
        utc = a.utctimetuple()

        self.assertEqual(utc.tm_year, 1)
        self.assertEqual(utc.tm_mon, 1)
        self.assertEqual(utc.tm_mday, 1)
        self.assertEqual(utc.tm_hour, 0)
        self.assertEqual(utc.tm_min, 0)
        self.assertEqual(utc.tm_sec, 0)
        self.assertEqual(a.microsecond, 0)

        #with self.assertRaises(DeserializationError):
        #    a = Deserializer.deserialize_iso('1996-01-01T23:01:54-22:66')

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso('1996-01-01T23:01:54-24:30')

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso('1996-01-01T23:01:78+00:30')

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso('1996-01-01T23:60:01+00:30')

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso('1996-01-01T24:01:01+00:30')

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso('1996-01-01t01:01:01/00:30')

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso('1996-01-01F01:01:01+00:30')

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso('2015-02-32')

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso('2015-22-01')

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso('2010-13-31')

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso('99999-12-31')

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso(True)

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso(2010)

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso(None)

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso('Happy New Year 2016')

    def test_polymorphic_deserialization(self):

        class Zoo(Model):

            _attribute_map = {
                "animals":{"key":"Animals", "type":"[Animal]"},
                }

        class Animal(Model):

            _attribute_map = {
                "name":{"key":"Name", "type":"str"}
                }

            _test_attr = 123

            _subtype_map = {
                'dType': {"cat":"Cat", "dog":"Dog"}
                }

        class Dog(Animal):

            _attribute_map = {
                "likes_dog_food":{"key":"likesDogFood","type":"bool"}
                }

        class Cat(Animal):

            _attribute_map = {
                "likes_mice":{"key":"likesMice","type":"bool"},
                "dislikes":{"key":"dislikes","type":"Animal"}
                }

            _subtype_map = {
                "dType":{"siamese":"Siamese"}
                }

        class Siamese(Cat):

            _attribute_map = {
                "color":{"key":"Color", "type":"str"}
                }

        message = {
            "Animals": [ 
            { 
            "dType": "dog", 
            "likesDogFood": True, 
            "Name": "Fido" 
            }, 
            { 
            "dType": "cat", 
            "likesMice": False, 
            "dislikes": { 
            "dType": "dog", 
            "likesDogFood": True, 
            "Name": "Angry" 
            }, 
            "Name": "Felix" 
            }, 
            { 
            "dType": "siamese", 
            "Color": "grey", 
            "likesMice": True, 
            "Name": "Finch" 
            }]}

        self.d.dependencies = {
            'Zoo':Zoo, 'Animal':Animal, 'Dog':Dog,
             'Cat':Cat, 'Siamese':Siamese}

        zoo = self.d(Zoo, message)
        animals = [a for a in zoo.animals]

        self.assertEqual(len(animals), 3)
        self.assertIsInstance(animals[0], Dog)
        self.assertTrue(animals[0].likes_dog_food)
        self.assertEqual(animals[0].name, 'Fido')

        self.assertIsInstance(animals[1], Cat)
        self.assertFalse(animals[1].likes_mice)
        self.assertIsInstance(animals[1].dislikes, Dog)
        self.assertEqual(animals[1].dislikes.name, 'Angry')
        self.assertEqual(animals[1].name, 'Felix')

        self.assertIsInstance(animals[2], Siamese)
        self.assertEqual(animals[2].color, "grey")
        self.assertTrue(animals[2].likes_mice)





