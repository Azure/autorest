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

from base64 import b64decode, b64encode
import calendar
import datetime
import decimal
from enum import Enum
import json
import logging
import re
try:
    from urllib import quote
except ImportError:
    from urllib.parse import quote

import chardet
import isodate

from .exceptions import (
    ValidationError,
    SerializationError,
    DeserializationError,
    raise_with_traceback)

try:
    basestring
except NameError:
    basestring = str

_LOGGER = logging.getLogger(__name__)


class UTC(datetime.tzinfo):
    """Time Zone info for handling UTC"""

    def utcoffset(self, dt):
        """UTF offset for UTC is 0."""
        return datetime.timedelta(0)

    def tzname(self, dt):
        """Timestamp representation."""
        return "Z"

    def dst(self, dt):
        """No daylight saving for UTC."""
        return datetime.timedelta(hours=1)


try:
    from datetime import timezone
    TZ_UTC = timezone.utc
except ImportError:
    TZ_UTC = UTC()


class Model(object):
    """Mixin for all client request body/response body models to support
    serialization and deserialization.
    """

    _subtype_map = {}
    _attribute_map = {}
    _validation = {}

    def __init__(self, *args, **kwargs):
        """Allow attribute setting via kwargs on initialization."""
        for k in kwargs:
            setattr(self, k, kwargs[k])

    def __eq__(self, other):
        """Compare objects by comparing all attributes."""
        if isinstance(other, self.__class__):
            return self.__class__.__dict__ == other.__class__.__dict__
        return False

    def __ne__(self, other):
        """Compare objects by comparing all attributes."""
        return not self.__eq__(other)

    def __str__(self):
        return str(self.__dict__)

    @classmethod
    def _get_subtype_map(cls):
        attr = '_subtype_map'
        parents = cls.__bases__
        for base in parents:
            if hasattr(base, attr) and base._subtype_map:
                return base._subtype_map
        return {}

    @classmethod
    def _classify(cls, response, objects):
        """Check the class _subtype_map for any child classes.
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


def _convert_to_datatype(data, data_type, localtypes):
    if data is None:
        return data
    data_obj = localtypes.get(data_type.strip('{[]}'))
    if data_obj:
        if data_type.startswith('['):
            data = [
                _convert_to_datatype(
                    param, data_type[1:-1], localtypes) for param in data
            ]
        elif data_type.startswith('{'):
            data = {
                key: _convert_to_datatype(
                    data[key], data_type[1:-1], localtypes) for key in data
            }
        elif issubclass(data_obj, Enum):
            return data
        elif not isinstance(data, data_obj):
            result = {
                key: _convert_to_datatype(
                    data[key],
                    data_obj._attribute_map[key]['type'],
                    localtypes) for key in data
            }
            data = data_obj(**result)
        else:
            try:
                for attr, map in data._attribute_map.items():
                    setattr(data, attr, _convert_to_datatype(
                        getattr(data, attr), map['type'], localtypes))
            except AttributeError:
                pass
    return data


class Serializer(object):
    """Request object model serializer."""

    basic_types = {str: 'str', int: 'int', bool: 'bool', float: 'float'}
    days = {0: "Mon", 1: "Tue", 2: "Wed", 3: "Thu",
            4: "Fri", 5: "Sat", 6: "Sun"}
    months = {1: "Jan", 2: "Feb", 3: "Mar", 4: "Apr", 5: "May", 6: "Jun",
              7: "Jul", 8: "Aug", 9: "Sep", 10: "Oct", 11: "Nov", 12: "Dec"}
    validation = {
        "min_length": lambda x, y: len(x) < y,
        "max_length": lambda x, y: len(x) > y,
        "minimum": lambda x, y: x < y,
        "maximum": lambda x, y: x > y,
        "minimum_ex": lambda x, y: x <= y,
        "maximum_ex": lambda x, y: x >= y,
        "min_items": lambda x, y: len(x) < y,
        "max_items": lambda x, y: len(x) > y,
        "pattern": lambda x, y: not re.match(y, x),
        "unique": lambda x, y: len(x) != len(set(x)),
        "multiple": lambda x, y: x % y != 0
        }
    flattten = re.compile(r"(?<!\\)\.")

    def __init__(self, classes=None):
        self.serialize_type = {
            'iso-8601': Serializer.serialize_iso,
            'rfc-1123': Serializer.serialize_rfc,
            'unix-time': Serializer.serialize_unix,
            'duration': Serializer.serialize_duration,
            'date': Serializer.serialize_date,
            'decimal': Serializer.serialize_decimal,
            'long': Serializer.serialize_long,
            'bytearray': Serializer.serialize_bytearray,
            'base64': Serializer.serialize_base64,
            'object': self.serialize_object,
            '[]': self.serialize_iter,
            '{}': self.serialize_dict
            }
        self.dependencies = dict(classes) if classes else {}

    def _serialize(self, target_obj, data_type=None, **kwargs):
        """Serialize data into a string according to type.

        :param target_obj: The data to be serialized.
        :param str data_type: The type to be serialized from.
        :rtype: str, dict
        :raises: SerializationError if serialization fails.
        """
        if target_obj is None:
            return None

        serialized = {}
        attr_name = None
        class_name = target_obj.__class__.__name__

        if data_type:
            return self.serialize_data(
                target_obj, data_type, **kwargs)

        if not hasattr(target_obj, "_attribute_map"):
            data_type = type(target_obj).__name__
            if data_type in self.basic_types.values():
                return self.serialize_data(
                    target_obj, data_type, **kwargs)

        try:
            attributes = target_obj._attribute_map
            self._classify_data(target_obj, class_name, serialized)

            for attr, map in attributes.items():
                attr_name = attr
                try:
                    keys = self.flattten.split(map['key'])
                    keys = [k.replace('\\.', '.') for k in keys]
                    attr_type = map['type']
                    orig_attr = getattr(target_obj, attr)
                    validation = target_obj._validation.get(attr_name, {})
                    orig_attr = self.validate(
                        orig_attr, attr_name, **validation)
                    new_attr = self.serialize_data(
                        orig_attr, attr_type, **kwargs)

                    for k in reversed(keys):
                        unflattened = {k: new_attr}
                        new_attr = unflattened

                    _new_attr = new_attr
                    _serialized = serialized
                    for k in keys:
                        if k not in _serialized:
                            _serialized.update(_new_attr)
                        _new_attr = _new_attr[k]
                        _serialized = _serialized[k]
                except ValueError:
                    continue

        except (AttributeError, KeyError, TypeError) as err:
            msg = "Attribute {} in object {} cannot be serialized.".format(
                attr_name, class_name)
            raise_with_traceback(SerializationError, msg, err)
        else:
            return serialized

    def _classify_data(self, target_obj, class_name, serialized):
        """Check whether this object is a child and therefor needs to be
        classified in the message.
        """
        try:
            for _type, _classes in target_obj._get_subtype_map().items():
                for ref, name in _classes.items():
                    if name == class_name:
                        serialized[_type] = ref
        except AttributeError:
            pass  # TargetObj has no _subtype_map so we don't need to classify.

    def body(self, data, data_type, **kwargs):
        """Serialize data intended for a request body.

        :param data: The data to be serialized.
        :param str data_type: The type to be serialized from.
        :rtype: dict
        :raises: SerializationError if serialization fails.
        :raises: ValueError if data is None
        """
        if data is None:
            raise ValidationError("required", "body", True)
        data = _convert_to_datatype(data, data_type, self.dependencies)
        return self._serialize(data, data_type, **kwargs)

    def url(self, name, data, data_type, **kwargs):
        """Serialize data intended for a URL path.

        :param data: The data to be serialized.
        :param str data_type: The type to be serialized from.
        :rtype: str
        :raises: TypeError if serialization fails.
        :raises: ValueError if data is None
        """
        data = self.validate(data, name, required=True, **kwargs)
        try:
            output = self.serialize_data(data, data_type, **kwargs)
            if data_type == 'bool':
                output = json.dumps(output)

            if kwargs.get('skip_quote') is True:
                output = str(output)
            else:
                output = quote(str(output), safe='')
        except SerializationError:
            raise TypeError("{} must be type {}.".format(name, data_type))
        else:
            return output

    def query(self, name, data, data_type, **kwargs):
        """Serialize data intended for a URL query.

        :param data: The data to be serialized.
        :param str data_type: The type to be serialized from.
        :rtype: str
        :raises: TypeError if serialization fails.
        :raises: ValueError if data is None
        """
        data = self.validate(data, name, required=True, **kwargs)
        try:
            if data_type in ['[str]']:
                data = ["" if d is None else d for d in data]

            output = self.serialize_data(data, data_type, **kwargs)
            if data_type == 'bool':
                output = json.dumps(output)
            if kwargs.get('skip_quote') is True:
                output = str(output)
            else:
                output = quote(str(output), safe='')
        except SerializationError:
            raise TypeError("{} must be type {}.".format(name, data_type))
        else:
            return str(output)

    def header(self, name, data, data_type, **kwargs):
        """Serialize data intended for a request header.

        :param data: The data to be serialized.
        :param str data_type: The type to be serialized from.
        :rtype: str
        :raises: TypeError if serialization fails.
        :raises: ValueError if data is None
        """
        data = self.validate(data, name, required=True, **kwargs)
        try:
            if data_type in ['[str]']:
                data = ["" if d is None else d for d in data]

            output = self.serialize_data(data, data_type, **kwargs)
            if data_type == 'bool':
                output = json.dumps(output)
        except SerializationError:
            raise TypeError("{} must be type {}.".format(name, data_type))
        else:
            return str(output)

    def validate(self, data, name, **kwargs):
        """Validate that a piece of data meets certain conditions"""
        required = kwargs.get('required', False)
        if required and data is None:
            raise ValidationError("required", name, True)
        elif data is None:
            return
        elif kwargs.get('readonly'):
            return

        try:
            for key, value in kwargs.items():
                validator = self.validation.get(key, lambda x, y: False)
                if validator(data, value):
                    raise ValidationError(key, name, value)
        except TypeError:
            raise ValidationError("unknown", name)
        else:
            return data

    def serialize_data(self, data, data_type, **kwargs):
        """Serialize generic data according to supplied data type.

        :param data: The data to be serialized.
        :param str data_type: The type to be serialized from.
        :param bool required: Whether it's essential that the data not be
         empty or None
        :raises: AttributeError if required data is None.
        :raises: ValueError if data is None
        :raises: SerializationError if serialization fails.
        """
        if data is None:
            raise ValueError("No value for given attribute")

        try:
            if data_type in self.basic_types.values():
                return self.serialize_basic(data, data_type)

            elif data_type in self.serialize_type:
                return self.serialize_type[data_type](data, **kwargs)

            enum_type = self.dependencies.get(data_type)
            if enum_type and issubclass(enum_type, Enum):
                return Serializer.serialize_enum(data, enum_obj=enum_type)

            iter_type = data_type[0] + data_type[-1]
            if iter_type in self.serialize_type:
                return self.serialize_type[iter_type](
                    data, data_type[1:-1], **kwargs)

        except (ValueError, TypeError) as err:
            msg = "Unable to serialize value: {!r} as type: {!r}."
            raise_with_traceback(
                SerializationError, msg.format(data, data_type), err)
        else:
            return self._serialize(data, **kwargs)

    def serialize_basic(self, data, data_type):
        """Serialize basic builting data type.
        Serializes objects to str, int, float or bool.

        :param data: Object to be serialized.
        :param str data_type: Type of object in the iterable.
        """
        if data_type == 'str':
            return self.serialize_unicode(data)
        return eval(data_type)(data)

    def serialize_unicode(self, data):
        """Special handling for serializing unicode strings in Py2.
        Encode to UTF-8 if unicode, otherwise handle as a str.

        :param data: Object to be serialized.
        :rtype: str
        """
        try:
            return data.value
        except AttributeError:
            pass
        try:
            if isinstance(data, unicode):
                return data.encode(encoding='utf-8')
        except NameError:
            return str(data)
        else:
            return str(data)

    def serialize_iter(self, data, iter_type, div=None, **kwargs):
        """Serialize iterable.

        :param list attr: Object to be serialized.
        :param str iter_type: Type of object in the iterable.
        :param bool required: Whether the objects in the iterable must
         not be None or empty.
        :param str div: If set, this str will be used to combine the elements
         in the iterable into a combined string. Default is 'None'.
        :rtype: list, str
        """
        serialized = []
        for d in data:
            try:
                serialized.append(
                    self.serialize_data(d, iter_type, **kwargs))
            except ValueError:
                serialized.append(None)

        if div:
            serialized = ['' if s is None else s for s in serialized]
            serialized = div.join(serialized)
        return serialized

    def serialize_dict(self, attr, dict_type, **kwargs):
        """Serialize a dictionary of objects.

        :param dict attr: Object to be serialized.
        :param str dict_type: Type of object in the dictionary.
        :param bool required: Whether the objects in the dictionary must
         not be None or empty.
        :rtype: dict
        """
        serialized = {}
        for key, value in attr.items():
            try:
                serialized[str(key)] = self.serialize_data(
                    value, dict_type, **kwargs)
            except ValueError:
                serialized[str(key)] = None
        return serialized

    def serialize_object(self, attr, **kwargs):
        """Serialize a generic object.
        This will be handled as a dictionary. If object passed in is not
        a basic type (str, int, float, dict, list) it will simply be
        cast to str.

        :param dict attr: Object to be serialized.
        :rtype: dict or str
        """
        if attr is None:
            return None
        obj_type = type(attr)
        if obj_type in self.basic_types:
            return self.serialize_basic(attr, self.basic_types[obj_type])

        if obj_type == dict:
            serialized = {}
            for key, value in attr.items():
                try:
                    serialized[str(key)] = self.serialize_object(
                        value, **kwargs)
                except ValueError:
                    serialized[str(key)] = None
            return serialized

        if obj_type == list:
            serialized = []
            for obj in attr:
                try:
                    serialized.append(self.serialize_object(
                        obj, **kwargs))
                except ValueError:
                    pass
            return serialized

        else:
            return str(attr)

    @staticmethod
    def serialize_enum(attr, enum_obj=None):
        try:
            return attr.value
        except AttributeError:
            pass
        try:
            enum_obj(attr)
            return attr
        except ValueError:
            for enum_value in enum_obj:
                if enum_value.value.lower() == str(attr).lower():
                    return enum_value.value
            error = "{!r} is not valid value for enum {!r}"
            raise SerializationError(error.format(attr, enum_obj))

    @staticmethod
    def serialize_bytearray(attr, **kwargs):
        """Serialize bytearray into base-64 string.

        :param attr: Object to be serialized.
        :rtype: str
        """
        return b64encode(attr).decode()

    @staticmethod
    def serialize_base64(attr, **kwargs):
        """Serialize str into base-64 string.

        :param attr: Object to be serialized.
        :rtype: str
        """
        encoded = b64encode(attr).decode('ascii')
        return encoded.strip('=').replace('+', '-').replace('/', '_')

    @staticmethod
    def serialize_decimal(attr, **kwargs):
        """Serialize Decimal object to float.

        :param attr: Object to be serialized.
        :rtype: float
        """
        return float(attr)

    @staticmethod
    def serialize_long(attr, **kwargs):
        """Serialize long (Py2) or int (Py3).

        :param attr: Object to be serialized.
        :rtype: int/long
        """
        try:
            return long(attr)
        except NameError:
            return int(attr)

    @staticmethod
    def serialize_date(attr, **kwargs):
        """Serialize Date object into ISO-8601 formatted string.

        :param Date attr: Object to be serialized.
        :rtype: str
        """
        if isinstance(attr, str):
            attr = isodate.parse_date(attr)
        t = "{:04}-{:02}-{:02}".format(attr.year, attr.month, attr.day)
        return t

    @staticmethod
    def serialize_duration(attr, **kwargs):
        """Serialize TimeDelta object into ISO-8601 formatted string.

        :param TimeDelta attr: Object to be serialized.
        :rtype: str
        """
        if isinstance(attr, str):
            attr = isodate.parse_duration(attr)
        return isodate.duration_isoformat(attr)

    @staticmethod
    def serialize_rfc(attr, **kwargs):
        """Serialize Datetime object into RFC-1123 formatted string.

        :param Datetime attr: Object to be serialized.
        :rtype: str
        :raises: TypeError if format invalid.
        """
        try:
            if not attr.tzinfo:
                _LOGGER.warning(
                    "Datetime with no tzinfo will be considered UTC.")
            utc = attr.utctimetuple()
        except AttributeError:
            raise TypeError("RFC1123 object must be valid Datetime object.")

        return "{}, {:02} {} {:04} {:02}:{:02}:{:02} GMT".format(
            Serializer.days[utc.tm_wday], utc.tm_mday,
            Serializer.months[utc.tm_mon], utc.tm_year,
            utc.tm_hour, utc.tm_min, utc.tm_sec)

    @staticmethod
    def serialize_iso(attr, **kwargs):
        """Serialize Datetime object into ISO-8601 formatted string.

        :param Datetime attr: Object to be serialized.
        :rtype: str
        :raises: SerializationError if format invalid.
        """
        if isinstance(attr, str):
            attr = isodate.parse_datetime(attr)
        try:
            if not attr.tzinfo:
                _LOGGER.warning(
                    "Datetime with no tzinfo will be considered UTC.")
            utc = attr.utctimetuple()
            if utc.tm_year > 9999 or utc.tm_year < 1:
                raise OverflowError("Hit max or min date")

            microseconds = str(float(attr.microsecond)*1e-6)[1:].ljust(4, '0')
            date = "{:04}-{:02}-{:02}T{:02}:{:02}:{:02}".format(
                utc.tm_year, utc.tm_mon, utc.tm_mday,
                utc.tm_hour, utc.tm_min, utc.tm_sec)
            return date + microseconds + 'Z'
        except (ValueError, OverflowError) as err:
            msg = "Unable to serialize datetime object."
            raise_with_traceback(SerializationError, msg, err)
        except AttributeError as err:
            msg = "ISO-8601 object must be valid Datetime object."
            raise_with_traceback(TypeError, msg, err)

    @staticmethod
    def serialize_unix(attr, **kwargs):
        """Serialize Datetime object into IntTime format.
        This is represented as seconds.

        :param Datetime attr: Object to be serialized.
        :rtype: int
        :raises: SerializationError if format invalid
        """
        if isinstance(attr, int):
            return attr
        try:
            if not attr.tzinfo:
                _LOGGER.warning(
                    "Datetime with no tzinfo will be considered UTC.")
            return int(calendar.timegm(attr.utctimetuple()))
        except AttributeError:
            raise TypeError("Unix time object must be valid Datetime object.")


class Deserializer(object):
    """Response object model deserializer.

    :param dict classes: Class type dictionary for deserializing
     complex types.
    """

    basic_types = {str: 'str', int: 'int', bool: 'bool', float: 'float'}
    valid_date = re.compile(
        r'\d{4}[-]\d{2}[-]\d{2}T\d{2}:\d{2}:\d{2}'
        '\.?\d*Z?[-+]?[\d{2}]?:?[\d{2}]?')
    flatten = re.compile(r"(?<!\\)\.")

    def __init__(self, classes=None):
        self.deserialize_type = {
            'iso-8601': Deserializer.deserialize_iso,
            'rfc-1123': Deserializer.deserialize_rfc,
            'unix-time': Deserializer.deserialize_unix,
            'duration': Deserializer.deserialize_duration,
            'date': Deserializer.deserialize_date,
            'decimal': Deserializer.deserialize_decimal,
            'long': Deserializer.deserialize_long,
            'bytearray': Deserializer.deserialize_bytearray,
            'base64': Deserializer.deserialize_base64,
            'object': self.deserialize_object,
            '[]': self.deserialize_iter,
            '{}': self.deserialize_dict
            }
        self.dependencies = dict(classes) if classes else {}

    def __call__(self, target_obj, response_data):
        """Call the deserializer to process a REST response.

        :param str target_obj: Target data type to deserialize to.
        :param requests.Response response_data: REST response object.
        :raises: DeserializationError if deserialization fails.
        :return: Deserialized object.
        """
        data = self._unpack_content(response_data)
        response, class_name = self._classify_target(target_obj, data)

        if isinstance(response, basestring):
            return self.deserialize_data(data, response)
        elif isinstance(response, type) and issubclass(response, Enum):
            return self.deserialize_enum(data, response)

        if data is None:
            return data
        try:
            attributes = response._attribute_map
            d_attrs = {}
            for attr, map in attributes.items():
                attr_type = map['type']
                key = map['key']
                working_data = data

                while '.' in key:
                    dict_keys = self.flatten.split(key)
                    if len(dict_keys) == 1:
                        key = dict_keys[0].replace('\\.', '.')
                        break
                    working_key = dict_keys[0].replace('\\.', '.')
                    working_data = working_data.get(working_key, data)
                    key = '.'.join(dict_keys[1:])

                raw_value = working_data.get(key)
                value = self.deserialize_data(raw_value, attr_type)
                d_attrs[attr] = value
        except (AttributeError, TypeError, KeyError) as err:
            msg = "Unable to deserialize to object: " + class_name
            raise_with_traceback(DeserializationError, msg, err)
        else:
            return self._instantiate_model(response, d_attrs)

    def _classify_target(self, target, data):
        """Check to see whether the deserialization target object can
        be classified into a subclass.
        Once classification has been determined, initialize object.

        :param str target: The target object type to deserialize to.
        :param str/dict data: The response data to deseralize.
        """
        if target is None:
            return None, None

        if isinstance(target, basestring):
            try:
                target = self.dependencies[target]
            except KeyError:
                return target, target

        try:
            target = target._classify(data, self.dependencies)
        except (TypeError, AttributeError):
            pass  # Target has no subclasses, so can't classify further.
        return target, target.__class__.__name__

    def _unpack_content(self, raw_data):
        """Extract data from the body of a REST response object.

        :param raw_data: Data to be processed. This could be a
         requests.Response object, in which case the json content will be
         be returned.
        """
        if raw_data and isinstance(raw_data, bytes):
            data = raw_data.decode(
                encoding=chardet.detect(raw_data)['encoding'])
        else:
            data = raw_data

        if hasattr(raw_data, 'content'):
            if not raw_data.content:
                return None

            if isinstance(raw_data.content, bytes):
                encoding = chardet.detect(raw_data.content)["encoding"]
                data = raw_data.content.decode(encoding=encoding)
            else:
                data = raw_data.content
            try:
                return json.loads(data)
            except (ValueError, TypeError):
                return data

        return data

    def _instantiate_model(self, response, attrs):
        """Instantiate a response model passing in deserialized args.

        :param response: The response model class.
        :param d_attrs: The deserialized response attributes.
        """
        if callable(response):
            subtype = response._get_subtype_map()
            try:
                readonly = [k for k, v in response._validation.items()
                            if v.get('readonly')]
                const = [k for k, v in response._validation.items()
                         if v.get('constant')]
                kwargs = {k: v for k, v in attrs.items()
                          if k not in subtype and k not in readonly + const}
                response_obj = response(**kwargs)
                for attr in readonly:
                    setattr(response_obj, attr, attrs.get(attr))
                return response_obj
            except TypeError as err:
                msg = "Unable to deserialize {} into model {}. ".format(
                    kwargs, response)
                raise DeserializationError(msg + str(err))
        else:
            try:
                for attr, value in attrs.items():
                    setattr(response, attr, value)
                return response
            except Exception as exp:
                msg = "Unable to populate response model. "
                msg += "Type: {}, Error: {}".format(type(response), exp)
                raise DeserializationError(msg)

    def deserialize_data(self, data, data_type):
        """Process data for deserialization according to data type.

        :param str data: The response string to be deserialized.
        :param str data_type: The type to deserialize to.
        :raises: DeserializationError if deserialization fails.
        :return: Deserialized object.
        """
        if data is None:
            return data

        try:
            if not data_type:
                return data
            if data_type in self.basic_types.values():
                return self.deserialize_basic(data, data_type)
            if data_type in self.deserialize_type:
                data_val = self.deserialize_type[data_type](data)
                return data_val

            iter_type = data_type[0] + data_type[-1]
            if iter_type in self.deserialize_type:
                return self.deserialize_type[iter_type](data, data_type[1:-1])

            obj_type = self.dependencies[data_type]
            if issubclass(obj_type, Enum):
                return self.deserialize_enum(data, obj_type)

        except (ValueError, TypeError, AttributeError) as err:
            msg = "Unable to deserialize response data."
            msg += " Data: {}, {}".format(data, data_type)
            raise_with_traceback(DeserializationError, msg, err)
        else:
            return self(obj_type, data)

    def deserialize_iter(self, attr, iter_type):
        """Deserialize an iterable.

        :param list attr: Iterable to be deserialized.
        :param str iter_type: The type of object in the iterable.
        :rtype: list
        """
        if not attr and not isinstance(attr, list):
            return None
        return [self.deserialize_data(a, iter_type) for a in attr]

    def deserialize_dict(self, attr, dict_type):
        """Deserialize a dictionary.

        :param dict/list attr: Dictionary to be deserialized. Also accepts
         a list of key, value pairs.
        :param str dict_type: The object type of the items in the dictionary.
        :rtype: dict
        """
        if isinstance(attr, list):
            return {str(x['key']): self.deserialize_data(
                x['value'], dict_type) for x in attr}
        return {str(k): self.deserialize_data(
            v, dict_type) for k, v in attr.items()}

    def deserialize_object(self, attr, **kwargs):
        """Deserialize a generic object.
        This will be handled as a dictionary.

        :param dict attr: Dictionary to be deserialized.
        :rtype: dict
        :raises: TypeError if non-builtin datatype encountered.
        """
        if attr is None:
            return None
        if isinstance(attr, basestring):
            return self.deserialize_basic(attr, 'str')
        obj_type = type(attr)
        if obj_type in self.basic_types:
            return self.deserialize_basic(attr, self.basic_types[obj_type])

        if obj_type == dict:
            deserialized = {}
            for key, value in attr.items():
                try:
                    deserialized[str(key)] = self.deserialize_object(
                        value, **kwargs)
                except ValueError:
                    deserialized[str(key)] = None
            return deserialized

        if obj_type == list:
            deserialized = []
            for obj in attr:
                try:
                    deserialized.append(self.deserialize_object(
                        obj, **kwargs))
                except ValueError:
                    pass
            return deserialized

        else:
            error = "Cannot deserialize generic object with type: "
            raise TypeError(error + str(obj_type))

    def deserialize_basic(self, attr, data_type):
        """Deserialize baisc builtin data type from string.
        Will attempt to convert to str, int, float and bool.
        This function will also accept '1', '0', 'true' and 'false' as
        valid bool values.

        :param str attr: response string to be deserialized.
        :param str data_type: deserialization data type.
        :rtype: str, int, float or bool
        :raises: TypeError if string format is not valid.
        """
        if data_type == 'bool':
            if attr in [True, False, 1, 0]:
                return bool(attr)
            elif isinstance(attr, basestring):
                if attr.lower() in ['true', '1']:
                    return True
                elif attr.lower() in ['false', '0']:
                    return False
            raise TypeError("Invalid boolean value: {}".format(attr))

        if data_type == 'str':
            return self.deserialize_unicode(attr)
        return eval(data_type)(attr)

    def deserialize_unicode(self, data):
        """Preserve unicode objects in Python 2, otherwise return data
        as a string.

        :param str data: response string to be deserialized.
        :rtype: str or unicode
        """
        try:
            if isinstance(data, unicode):
                return data
        except NameError:
            return str(data)
        else:
            return str(data)

    def deserialize_enum(self, data, enum_obj):
        """Deserialize string into enum object.

        :param str data: response string to be deserialized.
        :param Enum enum_obj: Enum object to deserialize to.
        :rtype: Enum
        :raises: DeserializationError if string is not valid enum value.
        """
        if isinstance(data, int):
            # Workaround. We might consider remove it in the future.
            # https://github.com/Azure/azure-rest-api-specs/issues/141
            try:
                return list(enum_obj.__members__.values())[data]
            except IndexError:
                error = "{!r} is not a valid index for enum {!r}"
                raise DeserializationError(error.format(data, enum_obj))
        try:
            return enum_obj(str(data))
        except ValueError:
            for enum_value in enum_obj:
                if enum_value.value.lower() == str(data).lower():
                    return enum_value
            error = "{!r} is not valid value for enum {!r}"
            raise DeserializationError(error.format(data, enum_obj))

    @staticmethod
    def deserialize_bytearray(attr):
        """Deserialize string into bytearray.

        :param str attr: response string to be deserialized.
        :rtype: bytearray
        :raises: TypeError if string format invalid.
        """
        return bytearray(b64decode(attr))

    @staticmethod
    def deserialize_base64(attr):
        """Deserialize base64 encoded string into string.

        :param str attr: response string to be deserialized.
        :rtype: bytearray
        :raises: TypeError if string format invalid.
        """
        padding = '=' * (3 - (len(attr) + 3) % 4)
        attr = attr + padding
        encoded = attr.replace('-', '+').replace('_', '/')
        return b64decode(encoded)

    @staticmethod
    def deserialize_decimal(attr):
        """Deserialize string into Decimal object.

        :param str attr: response string to be deserialized.
        :rtype: Decimal
        :raises: DeserializationError if string format invalid.
        """
        try:
            return decimal.Decimal(attr)
        except decimal.DecimalException as err:
            msg = "Invalid decimal {}".format(attr)
            raise_with_traceback(DeserializationError, msg, err)

    @staticmethod
    def deserialize_long(attr):
        """Deserialize string into long (Py2) or int (Py3).

        :param str attr: response string to be deserialized.
        :rtype: long or int
        :raises: ValueError if string format invalid.
        """
        try:
            return long(attr)
        except NameError:
            return int(attr)

    @staticmethod
    def deserialize_duration(attr):
        """Deserialize ISO-8601 formatted string into TimeDelta object.

        :param str attr: response string to be deserialized.
        :rtype: TimeDelta
        :raises: DeserializationError if string format invalid.
        """
        try:
            duration = isodate.parse_duration(attr)
        except(ValueError, OverflowError, AttributeError) as err:
            msg = "Cannot deserialize duration object."
            raise_with_traceback(DeserializationError, msg, err)
        else:
            return duration

    @staticmethod
    def deserialize_date(attr):
        """Deserialize ISO-8601 formatted string into Date object.

        :param str attr: response string to be deserialized.
        :rtype: Date
        :raises: DeserializationError if string format invalid.
        """
        return isodate.parse_date(attr)

    @staticmethod
    def deserialize_rfc(attr):
        """Deserialize RFC-1123 formatted string into Datetime object.

        :param str attr: response string to be deserialized.
        :rtype: Datetime
        :raises: DeserializationError if string format invalid.
        """
        try:
            date_obj = datetime.datetime.strptime(
                attr, "%a, %d %b %Y %H:%M:%S %Z")
            if not date_obj.tzinfo:
                date_obj = date_obj.replace(tzinfo=TZ_UTC)
        except ValueError as err:
            msg = "Cannot deserialize to rfc datetime object."
            raise_with_traceback(DeserializationError, msg, err)
        else:
            return date_obj

    @staticmethod
    def deserialize_iso(attr):
        """Deserialize ISO-8601 formatted string into Datetime object.

        :param str attr: response string to be deserialized.
        :rtype: Datetime
        :raises: DeserializationError if string format invalid.
        """
        try:
            attr = attr.upper()
            match = Deserializer.valid_date.match(attr)
            if not match:
                raise ValueError("Invalid datetime string: " + attr)

            check_decimal = attr.split('.')
            if len(check_decimal) > 1:
                decimal = ""
                for digit in check_decimal[1]:
                    if digit.isdigit():
                        decimal += digit
                    else:
                        break
                if len(decimal) > 6:
                    attr = attr.replace(decimal, decimal[0:-1])

            date_obj = isodate.parse_datetime(attr)
            test_utc = date_obj.utctimetuple()
            if test_utc.tm_year > 9999 or test_utc.tm_year < 1:
                raise OverflowError("Hit max or min date")
        except(ValueError, OverflowError, AttributeError) as err:
            msg = "Cannot deserialize datetime object."
            raise_with_traceback(DeserializationError, msg, err)
        else:
            return date_obj

    @staticmethod
    def deserialize_unix(attr):
        """Serialize Datetime object into IntTime format.
        This is represented as seconds.

        :param int attr: Object to be serialized.
        :rtype: Datetime
        :raises: DeserializationError if format invalid
        """
        try:
            date_obj = datetime.datetime.fromtimestamp(attr, TZ_UTC)
        except ValueError as err:
            msg = "Cannot deserialize to unix datetime object."
            raise_with_traceback(DeserializationError, msg, err)
        else:
            return date_obj
