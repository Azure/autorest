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
import logging
from datetime import datetime
import unittest
try:
    from unittest import mock
except ImportError:
    import mock

from requests import Response

from msrest.serialization import Model
from msrest import Serializer, Deserializer
from msrest.exceptions import SerializationError, DeserializationError, ValidationError


class Resource(Model):
    """Resource

    :param str id: Resource Id
    :param str name: Resource name
    :param str type: Resource type
    :param str location: Resource location
    :param dict tags: Resource tags
    """

    _validation = {
        'location': {'required': True},
    }

    _attribute_map = {
        'id': {'key': 'id', 'type': 'str'},
        'name': {'key': 'name', 'type': 'str'},
        'type': {'key': 'type', 'type': 'str'},
        'location': {'key': 'location', 'type': 'str'},
        'tags': {'key': 'tags', 'type': '{str}'},
    }

    def __init__(self, location, id=None, name=None, type=None, tags=None, **kwargs):
        self.id = id
        self.name = name
        self.type = type
        self.location = location
        self.tags = tags

        super(Resource, self).__init__(**kwargs)

class GenericResource(Resource):
    """
    Resource information.

    :param str id: Resource Id
    :param str name: Resource name
    :param str type: Resource type
    :param str location: Resource location
    :param dict tags: Resource tags
    :param Plan plan: Gets or sets the plan of the resource.
    :param object properties: Gets or sets the resource properties.
    """

    _validation = {}

    _attribute_map = {
        'id': {'key': 'id', 'type': 'str'},
        'name': {'key': 'name', 'type': 'str'},
        'type': {'key': 'type', 'type': 'str'},
        'location': {'key': 'location', 'type': 'str'},
        'tags': {'key': 'tags', 'type': '{str}'},
        'plan': {'key': 'plan', 'type': 'Plan'},
        'properties': {'key': 'properties', 'type': 'object'},
    }

    def __init__(self, location, id=None, name=None, type=None, tags=None, plan=None, properties=None, **kwargs):
        self.plan = plan
        self.properties = properties

        super(GenericResource, self).__init__(location, id=id, name=name, type=type, tags=tags, **kwargs)

class TestModelDeserialization(unittest.TestCase):

    def setUp(self):
        self.d = Deserializer({'Resource':Resource, 'GenericResource':GenericResource})
        return super(TestModelDeserialization, self).setUp()

    def test_response(self):

        data = {
          "properties": {
            "platformUpdateDomainCount": 5,
            "platformFaultDomainCount": 3,
            "virtualMachines": []
          },
          "id": "/subscriptions/abc-def-ghi-jklmnop/resourceGroups/test_mgmt_resource_test_resourcesea/providers/Microsoft.Compute/availabilitySets/pytest",
          "name": "pytest",
          "type": "Microsoft.Compute/availabilitySets",
          "location": "westus"
        }

        resp = mock.create_autospec(Response)
        resp.content = json.dumps(data)
        model = self.d('GenericResource', resp)
        self.assertEqual(model.properties['platformFaultDomainCount'], 3)
        self.assertEqual(model.location, 'westus')

class TestRuntimeSerialized(unittest.TestCase):

    class TestObj(Model):

        _validation = {}
        _attribute_map = {
            'attr_a': {'key':'id', 'type':'str'},
            'attr_b': {'key':'AttrB', 'type':'int'},
            'attr_c': {'key':'Key_C', 'type': 'bool'},
            'attr_d': {'key':'AttrD', 'type':'[int]'},
            'attr_e': {'key':'AttrE', 'type': '{float}'}
            }

        def __init__(self):

            self.attr_a = None
            self.attr_b = None
            self.attr_c = None
            self.attr_d = None
            self.attr_e = None

        def __str__(self):
            return "Test_Object"

    def setUp(self):
        self.s = Serializer()
        return super(TestRuntimeSerialized, self).setUp()

    def test_obj_serialize_none(self):
        """Test that serialize None in object is still None.
        """
        obj = self.s.serialize_object({'test': None})
        self.assertIsNone(obj['test'])

    def test_obj_without_attr_map(self):
        """
        Test serializing an object with no attribute_map.
        """
        test_obj = type("BadTestObj", (), {})

        with self.assertRaises(SerializationError):
            self.s._serialize(test_obj)

    def test_obj_with_malformed_map(self):
        """
        Test serializing an object with a malformed attribute_map.
        """
        test_obj = type("BadTestObj", (Model,), {"_attribute_map":None})

        with self.assertRaises(SerializationError):
            self.s._serialize(test_obj)

        test_obj._attribute_map = {"attr":"val"}

        with self.assertRaises(SerializationError):
            self.s._serialize(test_obj)

        test_obj._attribute_map = {"attr":{"val":1}}

        with self.assertRaises(SerializationError):
            self.s._serialize(test_obj)

    def test_obj_with_mismatched_map(self):
        """
        Test serializing an object with mismatching attributes and map.
        """
        test_obj = type("BadTestObj", (Model,), {"_attribute_map":None})
        test_obj._attribute_map = {"abc":{"key":"ABC", "type":"str"}}

        with self.assertRaises(SerializationError):
            self.s._serialize(test_obj)

    def test_attr_none(self):
        """
        Test serializing an object with None attributes.
        """
        test_obj = self.TestObj()
        message = self.s._serialize(test_obj)

        self.assertIsInstance(message, dict)
        self.assertFalse('id' in message)

    def test_attr_int(self):
        """
        Test serializing an object with Int attributes.
        """
        test_obj = self.TestObj()
        self.TestObj._validation = {
            'attr_b': {'required': True},
        }
        test_obj.attr_b = None

        with self.assertRaises(ValidationError):
            self.s._serialize(test_obj)

        test_obj.attr_b = 25

        message = self.s._serialize(test_obj)
        self.assertEqual(message['AttrB'], int(test_obj.attr_b))

        test_obj.attr_b = "34534"

        message = self.s._serialize(test_obj)
        self.assertEqual(message['AttrB'], int(test_obj.attr_b))

        test_obj.attr_b = "NotANumber"

        with self.assertRaises(SerializationError):
            self.s._serialize(test_obj)

        self.TestObj._validation = {}

    def test_attr_str(self):
        """
        Test serializing an object with Str attributes.
        """
        test_obj = self.TestObj()
        self.TestObj._validation = {
            'attr_a': {'required': True},
        }
        test_obj.attr_a = None

        with self.assertRaises(ValidationError):
            self.s._serialize(test_obj)

        self.TestObj._validation = {}
        test_obj.attr_a = "TestString"

        message = self.s._serialize(test_obj)
        self.assertEqual(message['id'], str(test_obj.attr_a))

        test_obj.attr_a = 1234

        message = self.s._serialize(test_obj)
        self.assertEqual(message['id'], str(test_obj.attr_a))

        test_obj.attr_a = list()

        message = self.s._serialize(test_obj)
        self.assertEqual(message['id'], str(test_obj.attr_a))

        test_obj.attr_a = [1]

        message = self.s._serialize(test_obj)
        self.assertEqual(message['id'], str(test_obj.attr_a))

    def test_attr_bool(self):
        """
        Test serializing an object with bool attributes.
        """
        test_obj = self.TestObj()
        test_obj.attr_c = True

        message = self.s._serialize(test_obj)
        self.assertEqual(message['Key_C'], True)

        test_obj.attr_c = ""

        message = self.s._serialize(test_obj)
        self.assertTrue('Key_C' in message)

        test_obj.attr_c = None

        message = self.s._serialize(test_obj)
        self.assertFalse('Key_C' in message)

        test_obj.attr_c = "NotEmpty"

        message = self.s._serialize(test_obj)
        self.assertEqual(message['Key_C'], True)

    def test_attr_sequence(self):
        """
        Test serializing a sequence.
        """

        test_obj = ["A", "B", "C"]
        output = self.s._serialize(test_obj, '[str]', div='|')
        self.assertEqual(output, "|".join(test_obj))

        test_obj = [1,2,3]
        output = self.s._serialize(test_obj, '[str]', div=',')
        self.assertEqual(output, ",".join([str(i) for i in test_obj]))

    def test_attr_list_simple(self):
        """
        Test serializing an object with simple-typed list attributes
        """
        test_obj = self.TestObj()
        test_obj.attr_d = []

        message = self.s._serialize(test_obj)
        self.assertEqual(message['AttrD'], test_obj.attr_d)

        test_obj.attr_d = [1,2,3]

        message = self.s._serialize(test_obj)
        self.assertEqual(message['AttrD'], test_obj.attr_d)

        test_obj.attr_d = ["1","2","3"]

        message = self.s._serialize(test_obj)
        self.assertEqual(message['AttrD'], [int(i) for i in test_obj.attr_d])

        test_obj.attr_d = ["test","test2","test3"]

        with self.assertRaises(SerializationError):
            self.s._serialize(test_obj)

        test_obj.attr_d = "NotAList"

        with self.assertRaises(SerializationError):
            self.s._serialize(test_obj)

    def test_empty_list(self):

        input = []
        output = self.s._serialize(input, '[str]')
        self.assertEqual(output, input)

    def test_attr_list_complex(self):
        """
        Test serializing an object with a list of complex objects as an attribute.
        """
        list_obj = type("ListObj", (Model,), {"_attribute_map":None,
                                        "_validation":{},
                                        "abc":None})
        list_obj._attribute_map = {"abc":{"key":"ABC", "type":"int"}}
        list_obj.abc = "123"

        test_obj = type("CmplxTestObj", (Model,), {"_attribute_map":None,
                                             "_validation":{},
                                             "test_list":None})

        test_obj._attribute_map = {"test_list":{"key":"_list", "type":"[ListObj]"}}
        test_obj.test_list = [list_obj]

        message = self.s._serialize(test_obj)
        self.assertEqual(message, {'_list':[{'ABC':123}]})

        list_obj = type("BadListObj", (Model,), {"map":None})
        test_obj._attribute_map = {"test_list":{"key":"_list", "type":"[BadListObj]"}}
        test_obj.test_list = [list_obj]

        s = self.s._serialize(test_obj)
        self.assertEqual(s, {'_list':[{}]})

    def test_attr_dict_simple(self):
        """
        Test serializing an object with a simple dictionary attribute.
        """

        test_obj = self.TestObj()
        test_obj.attr_e = {"value": 3.14}

        message = self.s._serialize(test_obj)
        self.assertEqual(message['AttrE']['value'], float(test_obj.attr_e["value"]))

        test_obj.attr_e = {1: "3.14"}

        message = self.s._serialize(test_obj)
        self.assertEqual(message['AttrE']['1'], float(test_obj.attr_e[1]))

        test_obj.attr_e = "NotADict"

        with self.assertRaises(SerializationError):
            self.s._serialize(test_obj)

        test_obj.attr_e = {"value": "NotAFloat"}

        with self.assertRaises(SerializationError):
            self.s._serialize(test_obj)

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

        a = self.s.serialize_data(1, 'int')
        self.assertEqual(a, 1)

        b = self.s.serialize_data(True, 'bool')
        self.assertEqual(b, True)

        c = self.s.serialize_data('True', 'str')
        self.assertEqual(c, 'True')

        d = self.s.serialize_data(100.0123, 'float')
        self.assertEqual(d, 100.0123)

    def test_serialize_object(self):

        a = self.s.body(1, 'object')
        self.assertEqual(a, 1)

        b = self.s.body(True, 'object')
        self.assertEqual(b, True)

        c = self.s.serialize_data('True', 'object')
        self.assertEqual(c, 'True')

        d = self.s.serialize_data(100.0123, 'object')
        self.assertEqual(d, 100.0123)

        e = self.s.serialize_data({}, 'object')
        self.assertEqual(e, {})

        f = self.s.body({"test":"data"}, 'object')
        self.assertEqual(f, {"test":"data"})

        g = self.s.body({"test":{"value":"data"}}, 'object')
        self.assertEqual(g, {"test":{"value":"data"}})

        h = self.s.serialize_data({"test":self.TestObj()}, 'object')
        self.assertEqual(h, {"test":"Test_Object"})

        i =  self.s.serialize_data({"test":[1,2,3,4,5]}, 'object')
        self.assertEqual(i, {"test":[1,2,3,4,5]})

    def test_serialize_empty_iter(self):

        a = self.s.serialize_dict({}, 'int')
        self.assertEqual(a, {})

        b = self.s.serialize_iter([], 'int')
        self.assertEqual(b, [])

    def test_serialize_json_obj(self):

        class ComplexId(Model):

            _validation = {}
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

            _validation = {}
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

        message =self.s._serialize(ComplexJson())

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
                "name":{"key":"Name", "type":"str"},
                "likes_dog_food":{"key":"likesDogFood","type":"bool"}
                }

            def __init__(self):
                self.likes_dog_food = None
                super(Dog, self).__init__()

        class Cat(Animal):

            _attribute_map = {
                "name":{"key":"Name", "type":"str"},
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
                "name":{"key":"Name", "type":"str"},
                "likes_mice":{"key":"likesMice","type":"bool"},
                "dislikes":{"key":"dislikes","type":"Animal"},
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

        serialized = self.s._serialize(zoo)
        self.assertEqual(serialized, message)


class TestRuntimeDeserialized(unittest.TestCase):

    class TestObj(Model):

        _validation = {}
        _attribute_map = {
            'attr_a': {'key':'id', 'type':'str'},
            'attr_b': {'key':'AttrB', 'type':'int'},
            'attr_c': {'key':'Key_C', 'type': 'bool'},
            'attr_d': {'key':'AttrD', 'type':'[int]'},
            'attr_e': {'key':'AttrE', 'type': '{float}'},
            'attr_f': {'key':'AttrF', 'type': '[[str]]'}
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
        return super(TestRuntimeDeserialized, self).setUp()

    def test_non_obj_deserialization(self):
        """
        Test direct deserialization of simple types.
        """
        response_data = mock.create_autospec(Response)

        response_data.content = json.dumps({})
        response = self.d("[str]", response_data)
        self.assertIsNone(response)

        response_data.content = ""
        response = self.d("[str]", response_data)
        self.assertIsNone(response)

        response_data.content = None
        response = self.d("[str]", response_data)
        self.assertIsNone(response)

        message = ["a","b","b"]
        response_data.content = json.dumps(message)
        response = self.d("[str]", response_data)
        self.assertEqual(response, message)

        response_data.content = json.dumps(12345)
        with self.assertRaises(DeserializationError):
            response = self.d("[str]", response_data)

        response_data.content = True
        response = self.d('bool', response_data)
        self.assertEqual(response, True)

        response_data.content = json.dumps(1)
        response = self.d('bool', response_data)
        self.assertEqual(response, True)

        response_data.content = json.dumps("true1")
        with self.assertRaises(DeserializationError):
            response = self.d('bool', response_data)


    def test_obj_with_no_attr(self):
        """
        Test deserializing an object with no attributes.
        """

        response_data = mock.create_autospec(Response)
        response_data.content = json.dumps({"a":"b"})

        class EmptyResponse(Model):
            _attribute_map = {}
            _header_map = {}


        derserialized = self.d(EmptyResponse, response_data)
        self.assertIsInstance(derserialized, EmptyResponse)

    def test_obj_with_malformed_map(self):
        """
        Test deserializing an object with a malformed attributes_map.
        """
        response_data = mock.create_autospec(Response)
        response_data.content = json.dumps({"a":"b"})

        class BadResponse(Model):
            _attribute_map = None

            def __init__(*args, **kwargs):
                pass

        with self.assertRaises(DeserializationError):
            self.d(BadResponse, response_data)

        class BadResponse(Model):
            _attribute_map = {"attr":"val"}

            def __init__(*args, **kwargs):
                pass

        with self.assertRaises(DeserializationError):
            self.d(BadResponse, response_data)

        class BadResponse(Model):
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
        self.assertIsNone(response)

    def test_attr_int(self):
        """
        Test deserializing an object with Int attributes.
        """
        response_data = mock.create_autospec(Response)
        response_data.status_code = 200
        response_data.headers = {'client-request-id':"123", 'etag':456.3}
        response_data.content = None

        response = self.d(self.TestObj, response_data)
        self.assertIsNone(response)

        message = {'AttrB':'1234'}
        response_data.content = json.dumps(message)
        response = self.d(self.TestObj, response_data)
        self.assertTrue(hasattr(response, 'attr_b'))
        self.assertEqual(response.attr_b, int(message['AttrB']))

        with self.assertRaises(DeserializationError):
            response_data.content = json.dumps({'AttrB':'NotANumber'})
            response = self.d(self.TestObj, response_data)

    def test_attr_str(self):
        """
        Test deserializing an object with Str attributes.
        """
        message = {'id':'InterestingValue'}
        response_data = mock.create_autospec(Response)
        response_data.status_code = 200
        response_data.headers = {'client-request-id': 'a', 'etag': 'b'}
        response_data.content = json.dumps(message)

        response = self.d(self.TestObj, response_data)
        self.assertTrue(hasattr(response, 'attr_a'))
        self.assertEqual(response.attr_a, message['id'])

        message = {'id':1234}
        response_data.content = json.dumps(message)
        response = self.d(self.TestObj, response_data)
        self.assertEqual(response.attr_a, str(message['id']))

        message = {'id':list()}
        response_data.content = json.dumps(message)
        response = self.d(self.TestObj, response_data)
        self.assertEqual(response.attr_a, str(message['id']))

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
        with self.assertRaises(DeserializationError):
            response = self.d(self.TestObj, response_data)

        response_data.content = json.dumps({'Key_C':0})
        response = self.d(self.TestObj, response_data)
        self.assertEqual(response.attr_c, False)

        response_data.content = json.dumps({'Key_C':"value"})
        with self.assertRaises(DeserializationError):
            response = self.d(self.TestObj, response_data)

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

        message = {'AttrD': [1,2,3]}
        response_data.content = json.dumps(message)
        response = self.d(self.TestObj, response_data)
        deserialized_list = [d for d in response.attr_d]
        self.assertEqual(deserialized_list, message['AttrD'])

        message = {'AttrD': ["1","2","3"]}
        response_data.content = json.dumps(message)
        response = self.d(self.TestObj, response_data)
        deserialized_list = [d for d in response.attr_d]
        self.assertEqual(deserialized_list, [int(i) for i in message['AttrD']])

        response_data.content = json.dumps({'AttrD': ["test","test2","test3"]})
        with self.assertRaises(DeserializationError):
            response = self.d(self.TestObj, response_data)
            deserialized_list = [d for d in response.attr_d]
        
        response_data.content = json.dumps({'AttrD': "NotAList"})
        with self.assertRaises(DeserializationError):
            response = self.d(self.TestObj, response_data)
            deserialized_list = [d for d in response.attr_d]

    def test_attr_list_in_list(self):
        """
        Test deserializing a list of lists
        """
        response_data = mock.create_autospec(Response)
        response_data.status_code = 200
        response_data.headers = {'client-request-id': 'a', 'etag': 'b'}
        response_data.content = json.dumps({'AttrF':[]})

        response = self.d(self.TestObj, response_data)
        self.assertTrue(hasattr(response, 'attr_f'))
        self.assertEqual(response.attr_f, [])

        response_data.content = json.dumps({'AttrF':None})

        response = self.d(self.TestObj, response_data)
        self.assertTrue(hasattr(response, 'attr_f'))
        self.assertEqual(response.attr_f, None)

        response_data.content = json.dumps({})

        response = self.d(self.TestObj, response_data)

        self.assertTrue(hasattr(response, 'attr_f'))
        self.assertEqual(response.attr_f, None)

        message = {'AttrF':[[]]}
        response_data.content = json.dumps(message)

        response = self.d(self.TestObj, response_data)
        self.assertTrue(hasattr(response, 'attr_f'))
        self.assertEqual(response.attr_f, message['AttrF'])

        message = {'AttrF':[[1,2,3], ['a','b','c']]}
        response_data.content = json.dumps(message)

        response = self.d(self.TestObj, response_data)
        self.assertTrue(hasattr(response, 'attr_f'))
        self.assertEqual(response.attr_f, [[str(i) for i in k] for k in message['AttrF']])

        with self.assertRaises(DeserializationError):
            response_data.content = json.dumps({'AttrF':[1,2,3]})
            response = self.d(self.TestObj, response_data)

    def test_attr_list_complex(self):
        """
        Test deserializing an object with a list of complex objects as an attribute.
        """
        class ListObj(Model):
            _attribute_map = {"abc":{"key":"ABC", "type":"int"}}

        class CmplxTestObj(Model):
            _response_map = {}
            _attribute_map = {'attr_a': {'key':'id', 'type':'[ListObj]'}}


        response_data = mock.create_autospec(Response)
        response_data.status_code = 200
        response_data.headers = {'client-request-id': 'a', 'etag': 'b'}
        response_data.content = json.dumps({"id":[{"ABC": "123"}]})

        d = Deserializer({'ListObj':ListObj})
        response = d(CmplxTestObj, response_data)
        deserialized_list = list(response.attr_a)

        self.assertIsInstance(deserialized_list[0], ListObj)
        self.assertEqual(deserialized_list[0].abc, 123)

    def test_deserialize_object(self):

        a = self.d('object', 1)
        self.assertEqual(a, 1)

        b = self.d('object', True)
        self.assertEqual(b, True)

        c = self.d('object', 'True')
        self.assertEqual(c, 'True')

        d = self.d('object', 100.0123)
        self.assertEqual(d, 100.0123)

        e = self.d('object', {})
        self.assertEqual(e, {})

        f = self.d('object', {"test":"data"})
        self.assertEqual(f, {"test":"data"})

        g = self.d('object', {"test":{"value":"data"}})
        self.assertEqual(g, {"test":{"value":"data"}})

        with self.assertRaises(DeserializationError):
            self.d('object', {"test":self.TestObj()})

        h =  self.d('object', {"test":[1,2,3,4,5]})
        self.assertEqual(h, {"test":[1,2,3,4,5]})

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
        #    a = Deserializer.deserialize_iso('1996-01-01T23:01:54-22:66') #TODO

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso('1996-01-01T23:01:54-24:30')

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso('1996-01-01T23:01:78+00:30')

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso('1996-01-01T23:60:01+00:30')

        with self.assertRaises(DeserializationError):
            a = Deserializer.deserialize_iso('1996-01-01T24:01:01+00:30')

        #with self.assertRaises(DeserializationError):
        #    a = Deserializer.deserialize_iso('1996-01-01t01:01:01/00:30') #TODO

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
                "name":{"key":"Name", "type":"str"},
                "likes_dog_food":{"key":"likesDogFood","type":"bool"}
                }

        class Cat(Animal):

            _attribute_map = {
                "name":{"key":"Name", "type":"str"},
                "likes_mice":{"key":"likesMice","type":"bool"},
                "dislikes":{"key":"dislikes","type":"Animal"}
                }

            _subtype_map = {
                "dType":{"siamese":"Siamese"}
                }

        class Siamese(Cat):

            _attribute_map = {
                "name":{"key":"Name", "type":"str"},
                "likes_mice":{"key":"likesMice","type":"bool"},
                "dislikes":{"key":"dislikes","type":"Animal"},
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
        self.assertEqual(animals[0].name, message['Animals'][0]["Name"])

        self.assertIsInstance(animals[1], Cat)
        self.assertFalse(animals[1].likes_mice)
        self.assertIsInstance(animals[1].dislikes, Dog)
        self.assertEqual(animals[1].dislikes.name, message['Animals'][1]["dislikes"]["Name"])
        self.assertEqual(animals[1].name, message['Animals'][1]["Name"])

        self.assertIsInstance(animals[2], Siamese)
        self.assertEqual(animals[2].color, message['Animals'][2]["Color"])
        self.assertTrue(animals[2].likes_mice)

if __name__ == '__main__':
    unittest.main()
