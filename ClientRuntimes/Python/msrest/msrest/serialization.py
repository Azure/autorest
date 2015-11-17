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

import json
import isodate
import datetime

from enum import Enum
from decimal import Decimal

from .exceptions import (
    SerializationError,
    DeserializationError,
    raise_with_traceback)


class Model(object):
    """
    Mixin for all client request body/response body models to support
    serialization and deserialization.
    """

    _subtype_map = {}
    _attribute_map = {}
    _header_map = {}
    _response_map = {}

    def __getattribute__(self, attr):

        if attr in ['_attribute_map', '_header_map', '_response_map']:
            parents = list(self.__class__.__mro__)
            map = {}
            for p in reversed(parents):
                if hasattr(p, attr):
                    map.update(p.__dict__.get(attr, {}))

            return map

        if attr == '_subtype_map':
            parents = list(self.__class__.__bases__)
            for p in parents:
                if hasattr(p, '_subtype_map') and p._subtype_map:
                    return p._subtype_map

            return {}

        elif attr == '_required':
            parents = list(self.__class__.__mro__)
            map = []
            for p in reversed(parents):
                if hasattr(p, attr):
                    map += p.__dict__[attr]

            return map

        else:
            return object.__getattribute__(self, attr)

    @classmethod
    def _classify(cls, response, objects):
        """
        Check the class _subtype_map for any child classes.
        We want to ignore any inheirited _subtype_maps.
        """
        try:
            map = cls.__dict__.get('_subtype_map', {})

            for _type, _classes in map.items():
                classification = response.get(_type)

                try:
                    return objects[_classes[classification]]

                except KeyError:
                    pass

                for c in _classes:
                    try:
                        _cls = objects[_classes[c]]
                        return _cls._classify(response, objects)

                    except (KeyError, TypeError):
                        continue

            raise TypeError("Object cannot be classified futher.")

        except AttributeError:
            raise TypeError("Object cannot be classified futher.")


class Serializer(object):

    basic_types = ['str', 'int', 'bool', 'float']

    def __init__(self):

        self.serialize_type = {
            'iso-8601': Serializer.serialize_iso,
            'rfc-1123': Serializer.serialize_rfc,
            'duration': Serializer.serialize_duration,
            'time': Serializer.serialize_time,
            'date': Serializer.serialize_date,
            'decimal': Serializer.serialize_decimal,
            'long': Serializer.serialize_long,
            'bytearray': Serializer.serialize_bytearray,
            '[]': self.serialize_iter,
            '{}': self.serialize_dict
            }

    def __call__(self, target_obj, data_type=None, **kwargs):

        serialized = {}
        attr_name = None
        class_name = target_obj.__class__.__name__

        if data_type:
            return self.serialize_data(
                target_obj, data_type, required=True, **kwargs)

        if not hasattr(target_obj, "_attribute_map"):
            data_type = type(target_obj).__name__

            if data_type in self.basic_types:
                return self.serialize_data(
                    target_obj, data_type, required=True, **kwargs)

        try:
            attributes = target_obj._attribute_map
            required_attrs = target_obj._required
            self._classify_data(target_obj, class_name, serialized)

            for attr, map in attributes.items():
                attr_name = attr
                try:
                    orig_attr = getattr(target_obj, attr)
                    attr_type = attributes[attr]['type']

                    new_attr = self.serialize_data(
                        orig_attr, attr_type,
                        attr in required_attrs, **kwargs)

                    serialized[map['key']] = new_attr

                except ValueError:
                    continue

        except (AttributeError, KeyError, TypeError) as err:
            msg = "Attribute {0} in object {1} cannot be serialized.".format(
                attr_name, class_name)

            raise_with_traceback(SerializationError, msg, err)

        else:
            return serialized

    def _classify_data(self, target_obj, class_name, serialized):
        """
        Check whether this object is a child and therefor needs to be
        classified in the message.

        """
        try:
            for _type, _classes in target_obj._subtype_map.items():

                for ref, name in _classes.items():
                    if name == class_name:
                        serialized[_type] = ref

        except AttributeError:
            pass  # TargetObj has no _subtype_map so we don't need to classify

    def serialize_data(self, data, data_type, required=False, **kwargs):

        if data is None and required:
            raise AttributeError(
                "Object missing required attribute")

        if data in [None, ""]:
            raise ValueError("No value for given attribute")

        if data_type is None:
            return data

        try:
            if data_type in self.basic_types:
                return eval(data_type)(data)

            if data_type in self.serialize_type:
                return self.serialize_type[data_type](data, **kwargs)

            if isinstance(data, Enum):
                return data.value

            iter_type = data_type[0] + data_type[-1]
            if iter_type in self.serialize_type:

                return self.serialize_type[iter_type](
                    data, data_type[1:-1], required, **kwargs)

        except (ValueError, TypeError) as err:
            msg = "Unable to serialize value: '{0}' as type: '{1}'.".format(
                data, data_type)

            raise_with_traceback(SerializationError, msg, err)

        else:
            return self(data, **kwargs)

    def serialize_iter(self, data, iter_type, required, div=None, **kwargs):

        if div:
            return div.join([self.serialize_data(
            i, iter_type, required, **kwargs) for i in data])

        return [self.serialize_data(
            i, iter_type, required, **kwargs) for i in data]

    def serialize_dict(self, attr, dict_type, required, **kwargs):

        return {str(x): self.serialize_data(
            attr[x], dict_type, required, **kwargs) for x in attr}

    @staticmethod
    def serialize_bytearray(attr, **kwargs):
        return str(attr)  # TODO

    @staticmethod
    def serialize_decimal(attr, **kwargs):
        return float(attr)

    @staticmethod
    def serialize_long(attr, **kwargs):
        try:
            return long(attr)

        except NameError:
            return int(attr)

    @staticmethod
    def serialize_date(attr, **kwargs):
        return str(attr)  # TODO

    @staticmethod
    def serialize_time(attr, **kwargs):
        return str(attr)  # TODO

    @staticmethod
    def serialize_duration(attr, **kwargs):
        return isodate.duration_isoformat(attr)

    @staticmethod
    def serialize_rfc(attr, **kwargs):
        date_str = attr.strftime('%a, %d %b %Y %H:%M:%S GMT')
        return date_str

    @staticmethod
    def serialize_iso(attr, **kwargs):
        if isinstance(attr, str):
            attr = isodate.parse_datetime(attr)

        try:
            utc = attr.utctimetuple()
            if utc.tm_year > 9999 or utc.tm_year < 1:
                raise OverflowError("Hit max or min date")

            microseconds = str(float(attr.microsecond)*1e-6)[1:].ljust(4, '0')

            date = "{:04}-{:02}-{:02}T{:02}:{:02}:{:02}".format(
                utc.tm_year, utc.tm_mon, utc.tm_mday,
                utc.tm_hour, utc.tm_min, utc.tm_sec)

            return date + microseconds + 'Z'
            # return isodate.datetime_isoformat(attr)

        except (ValueError, OverflowError) as err:
            msg = "Unable to serialize datetime object."
            raise_with_traceback(SerializationError, msg, err)


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
            'iso-8601': Deserializer.deserialize_iso,
            'rfc-1123': Deserializer.deserialize_rfc,
            'duration': Deserializer.deserialize_duration,
            'time': Deserializer.deserialize_time,
            'date': Deserializer.deserialize_date,
            'decimal': Deserializer.deserialize_decimal,
            'long': Deserializer.deserialize_long,
            'bytearray': Deserializer.deserialize_bytearray,
            '[]': self.deserialize_iter,
            '{}': self.deserialize_dict
            }

        self.dependencies = dict(classes)

    def __call__(self, target_obj, response_data):

        response, class_name = self._classify_target(target_obj, response_data)

        try:
            data = self._unpack_response(response, response_data)

        except (TypeError, ValueError, AttributeError) as err:
            msg = "Unable to deserialize to object: {}.".format(class_name)
            raise_with_traceback(DeserializationError, msg, err)

        if isinstance(target_obj, str):
            return self.deserialize_data(data, target_obj)

        try:
            attributes = response._attribute_map
            for attr, map in attributes.items():
                attr_type = map['type']
                key = map['key']

                raw_value = data.get(key) if key else data

                value = self.deserialize_data(raw_value, attr_type)
                setattr(response, attr, value)

        except (AttributeError, TypeError, KeyError) as err:
            msg = "Unable to deserialize to object: {}.".format(class_name)
            raise_with_traceback(DeserializationError, msg, err)

        else:
            return response

    def _classify_target(self, target, data):

        if not target:
            return None, None

        if isinstance(target, type):
            try:
                target = target._classify(data, self.dependencies)

            except (TypeError, AttributeError):
                pass  # Target has no subclasses, so can't classify further.

        if isinstance(target, str):
            try:
                target = self.dependencies[target]

            except KeyError:
                return target, target

        try:
            target_obj = target()
            return target_obj, target_obj.__class__.__name__

        except TypeError:
            return target, None

    def _unpack_headers(self, response, raw_data):

        for attr, val in response._header_map.items():
            attr_type = val['type']
            attr_name = val['key']

            raw_value = raw_data.headers.get(attr_name)
            value = self.deserialize_data(raw_value, attr_type)

            setattr(response, attr, value)

    def _unpack_response_attrs(self, response, raw_data):

        for attr, val in response._response_map.items():
            attr_type = val['type']
            attr_name = val['key']

            raw_value = getattr(raw_data, attr_name)
            value = self.deserialize_data(raw_value, attr_type)

            setattr(response, attr, value)

    def _unpack_response(self, response, raw_data):

        if hasattr(response, '_header_map'):
            self._unpack_headers(response, raw_data)

        if hasattr(response, '_response_map'):
            self._unpack_response_attrs(response, raw_data)

        if hasattr(raw_data, 'content'):
            if not raw_data.content:
                return {}

            return json.loads(raw_data.content)

        return raw_data

    def deserialize_data(self, data, data_type):

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

        except (ValueError, TypeError) as err:
            msg = "Unable to deserialize response data."
            raise_with_traceback(DeserializationError, msg, err)

        else:
            return self(obj_type, data)

    def deserialize_iter(self, attr, iter_type):
        return DeserializedGenerator(self.deserialize_data, attr, iter_type)

    def deserialize_dict(self, attr, dict_type):
        if isinstance(attr, list):
            return {str(x['key']): self.deserialize_data(
                x['value'], dict_type) for x in attr}

        return {str(x): self.deserialize_data(
            attr[x], dict_type) for x in attr}

    @staticmethod
    def deserialize_bytearray(attr):
        return attr  # TODO

    @staticmethod
    def deserialize_decimal(attr):
        return Decimal(attr)

    @staticmethod
    def deserialize_long(attr):
        try:
            return long(attr)

        except NameError:
            return int(attr)

    @staticmethod
    def deserialize_duration(attr):
        try:
            duration = isodate.parse_duration(attr)

        except(ValueError, OverflowError, AttributeError) as err:
            msg = "Cannot deserialize duration object."
            raise_with_traceback(DeserializationError, msg, err)

        else:
            return duration

    @staticmethod
    def deserialize_time(attr):
        return attr  # TODO

    @staticmethod
    def deserialize_date(attr):
        return attr  # TODO

    @staticmethod
    def deserialize_rfc(attr):
        try:
            date_obj = datetime.datetime.strptime(
                attr, "%a, %d %b %Y %H:%M:%S %Z")

        except ValueError as err:
            msg = "Cannot deserialize to rfc datetime object."
            raise_with_traceback(DeserializationError, msg, err)

        else:
            return date_obj

    @staticmethod
    def deserialize_iso(attr):
        try:
            date_obj = isodate.parse_datetime(attr)
            test_utc = date_obj.utctimetuple()
            if test_utc.tm_year > 9999 or test_utc.tm_year < 1:
                raise OverflowError("Hit max or min date")

        except(ValueError, OverflowError, AttributeError) as err:
            msg = "Cannot deserialize datetime object."
            raise_with_traceback(DeserializationError, msg, err)

        else:
            return date_obj
