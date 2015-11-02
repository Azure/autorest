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

import json
import isodate
import datetime
from enum import Enum

from .exceptions import SerializationError, DeserializationError


class Serializer(object):

    basic_types = ['str', 'int', 'bool', 'float']

    def __init__(self):

        self.serialize_type = {
            'iso-8601':Serializer.serialize_iso,
            'duration':Serializer.serialize_duration,
            '[]':self.serialize_iter,
            '{}':self.serialize_dict
            }

    def __call__(self, target_obj):

        serialized = {}
        attr_name = None
        class_name = target_obj.__class__.__name__

        try:
            for attr, map in target_obj._attribute_map.items():
                attr_name = attr
                try:
                    orig_attr = getattr(target_obj, attr)
                    attr_type = target_obj._attribute_map[attr]['type']
                    new_attr = self._serialize_data(
                        orig_attr, attr_type, attr in target_obj._required)

                    serialized[map['key']] = new_attr

                except ValueError:
                    continue

        except (AttributeError, KeyError, TypeError) as err:

            raise SerializationError(
                "Attribute {0} in object {1} cannot be serialized: {2}".format(
                    attr_name, class_name, err))

        return serialized

    def _serialize_data(self, data, data_type, required):

        if data is None and required:
            raise AttributeError(
                "Object missing required attribute")

        if not data:
            raise ValueError("No value for given attribute")
        
        if data_type is None:
            return data

        try:
            if data_type in self.basic_types:
                return eval(data_type)(data)
            
            if data_type in self.serialize_type:
                return self.serialize_type[data_type](data)

            if isinstance(data, Enum):
                return data.value

            iter_type = data_type[0] + data_type[-1]
            if iter_type in self.serialize_type:
                return self.serialize_type[iter_type](data, data_type[1:-1], required)

        except (ValueError, TypeError) as err:

            raise SerializationError(
                "Unable to serialize value: '{0}' as type: {1}".format(
                    data, data_type))

        return self(data)

    def serialize_iter(self, data, iter_type, required):
        return [self._serialize_data(i, iter_type, required) for i in data]

    def serialize_dict(self, attr, dict_type, required):
        return {str(x):self._serialize_data(attr[x], dict_type, required) for x in attr}

    @staticmethod
    def serialize_duration(attr):
        return str(attr) #TODO

    @staticmethod
    def serialize_opc_date(attr):
        date_str = attr.strftime('%a, %d %b %Y %H:%M:%S GMT')
        return date_str

    @staticmethod
    def serialize_date(attr):
        if isinstance(attr, str):
            attr = isodate.parse_datetime(attr)

        try:
            utc = attr.utctimetuple()
            microseconds = str(float(attr.microsecond)*1e-6)[1:].ljust(4, '0')

            date = "{:04}-{:02}-{:02}T{:02}:{:02}:{:02}".format(
                utc.tm_year,utc.tm_mon,utc.tm_mday,utc.tm_hour,utc.tm_min,utc.tm_sec)

            return date + microseconds + 'Z'

        except (ValueError, OverflowError) as err:
            raise SerializationError("Unable to serialize datetime object: {0}".format(err))
       

class DeserializedGenerator(object):
   
    def __init__(self, deserialize, resp_lst, resp_type):

        self._command = deserialize
        self._type = resp_type
        self._list = resp_lst

    def __iter__(self):

        for resp in self._list:
            yield self._command(resp, self._type)


class Deserializer(object):

    basic_types = ['str', 'int', 'bool', 'float']

    def __init__(self, classes={}):

        self.deserialize_type = {
            'iso-8601':Deserializer.deserialize_iso,
            'rfc-1123':Deserializer.deserialize_rfc,
            'duration':Deserializer.deserialize_duration,
            'time':Deserializer.deserialize_time,
            '[]':self.deserialize_iter,
            '{}':self.deserialize_dict
            # etc
            }

        self.dependencies = dict(classes)

    def __call__(self, target_obj, response_data):

        response = target_obj() if isinstance(target_obj, type) else target_obj
        class_name = response.__class__.__name__

        try:
            data = self._unpack_response(response, response_data)
            if data is None:
                return response

            map_dict = getattr(response, '_attribute_map')
            for attr in map_dict:
                attr_type = map_dict[attr]['type']
                key = map_dict[attr]['key']

                raw_value = data.get(key) if key else data

                value = self._deserialize_data(raw_value, attr_type) 
                setattr(response, attr, value)

        except (AttributeError, TypeError, KeyError) as err:

            raise DeserializationError(
                "Unable to deserialize to object: {}. Error: {}".format(
                    class_name, err))
                
        return response

    def _deserialize_data(self, data, data_type):

        if data is None:
            return data

        try:
            if not data_type:
                return data

            if data_type in self.basic_types:
                return eval(data_type)(data)

            if data_type in self.deserialize_type:
                data_val = self.deserialize_type[data_type](data)
                return data_val

            iter_type = data_type[0] + data_type[-1]
            if iter_type in self.deserialize_type:
                return self.deserialize_type[iter_type](data, data_type[1:-1])

            obj_type = self.dependencies[data_type]
            if issubclass(obj_type, Enum):
                return obj_type(data)

            return self(obj_type, data)

        except (ValueError, TypeError) as err:

            raise DeserializationError(
                "Unable to deserialize response data: {0}".format(err))

    def _unpack_headers(self, response, raw_data):

        for attr, val in response._header_map.items():
            attr_type = val['type']
            attr_name = val['key']

            raw_value = raw_data.headers.get(attr_name)
            value = self._deserialize_data(raw_value, attr_type) 

            setattr(response, attr, value)

    def _unpack_response_attrs(self, response, raw_data):

        for attr, val in response._response_map.items():
            attr_type = val['type']
            attr_name = val['key']

            raw_value = getattr(raw_data, attr_name)
            value = self._deserialize_data(raw_value, attr_type) 

            setattr(response, attr, value)

    def _unpack_response(self, response, raw_data):

        if hasattr(response, '_header_map'):
            self._unpack_headers(response, raw_data)
            
        if hasattr(response, '_response_map'):
            self._unpack_response_attrs(response, raw_data)

        if hasattr(raw_data, 'content'):
            try:
                return json.loads(raw_data.content)

            except (TypeError, json.JSONDecodeError):
                return None

        return raw_data

    def deserialize_iter(self, attr, iter_type):
        return DeserializedGenerator(self._deserialize_data, attr, iter_type)

    def deserialize_dict(self, attr, dict_type):
        if isinstance(attr, list):
            return {str(x['key']):self._deserialize_data(
                x['value'], dict_type) for x in attr}

        return {str(x):self._deserialize_data(
            attr[x], dict_type) for x in attr}

    @staticmethod
    def deserialize_duration(attr):
        return attr #TODO

    @staticmethod
    def deserialize_time(attr):
        return attr #TODO


    @staticmethod
    def deserialize_iso(attr):
        try:
            date_obj = isodate.parse_datetime(attr)
            t = date_obj.utctimetuple()
            return date_obj

        except(ValueError, OverflowError, AttributeError) as err:

            raise DeserializationError(
                "Cannot deserialize datetime object: {}".format(err))


