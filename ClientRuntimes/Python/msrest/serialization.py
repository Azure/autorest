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

from response import HTTPResponse
import json

from .exceptions import SerializationError, DeserializationError

class Serialized(object):

    basic_types = ['str', 'int', 'bool', 'float']

    def __init__(self, request_obj):
        self.request = request_obj

        self.serialize_type = {
            'datetime':self.serialize_time,
            'duration':self.serialize_duration,
            '[]':self.serialize_iter,
            '{}':self.serialize_dict
            # etc
            }

    def __getattr__(self, attr):

        try:
            orig_attr = getattr(self.request, attr)
            attr_type = self.request.attribute_map[attr]['type']

            return self._serialize_data(orig_attr, attr_type)

        except (AttributeError, KeyError, TypeError) as err:
            raise SerializationError("Object cannot be serialized: {0}".format(err))

    def __call__(self):
        serialized = {}

        try:
            for attr in self.request.attribute_map:
                serialized[self.request.attribute_map[attr]['key']] = getattr(self, attr)

        except (AttributeError, KeyError, TypeError) as err:
            raise SerializationError("Object cannot be serialized: {0}".format(err))

        return serialized

    def _serialize_data(self, data, data_type):

        if data is None:
            return data

        if data_type in self.basic_types:
            try:
                return eval(data_type)(data)
            except ValueError as err:
                raise SerializationError("Unable to serialize value: '{0}' as type: {1}".format(data, data_type))

        if data_type in self.serialize_type:
            return self.serialize_type[data_type](data)

        iter_type = data_type[0] + data_type[-1]
        if iter_type in self.serialize_type:
            return self.serialize_type[iter_type](data, data_type[1:-1])

        return self.serialize_object(data)

    def serialize_object(self, cmplx_obj):
        serialized = Serialized(cmplx_obj)
        return serialized()

    def serialize_iter(self, attr, iter_type):
        return [self._serialize_data(i, iter_type) for i in attr]

    def serialize_dict(self, attr, dict_type):
        return {str(x):self._serialize_data(attr[x], dict_type) for x in attr}

    def serialize_duration(self, attr):
        pass

    def serialize_time(self, attr):
        pass


class Deserialized(object):

    basic_types = ['str', 'int', 'bool', 'float']

    def __init__(self, response_obj, response_data):

        try:
            self.response = self.unpack_response(response_obj, response_data)

        except (AttributeError, TypeError, KeyError) as err:
            raise DeserializationError("Unable to deserialize to type: '{0}' because: '{1}'.".format(response_obj, err))

        self.deserialize_type = {
            'datetime':self.deserialize_datetime,
            'duration':self.deserialize_duration,
            'time':self.deserialize_time,
            '[]':self.deserialize_iter,
            '{}':self.deserialize_dict
            # etc
            }

    def __call__(self, raw):

        if raw and self.response.body_map:
            body = json.loads(raw)

            for attr in self.response.body_map:
                attr_type = self.response.body_map[attr]['type']
                raw_value = body.get(self.response.body_map[attr]['key'])

                value = self.deserialize_data(attr, raw_value, attr_type) 
                setattr(self.response, attr, value)

        return self.response

    def _deserialize_data(self, attr, data, data_type):
        if data is None or data_type in self.basic_types:
            return data

        if data_type in self.deserialize_type:
            data_val = self.deserialize_type[data_type](data)
            return data_val

        iter_type = data_type[0] + data_type[-1]
        if iter_type in self.deserialize_type:
            return self.deserialize_type[iter_type](data, data_type[1,-1])

        else:
            deserialize_obj = Deserialized(eval(data_type))
            return deserialize_obj(raw_data)

    def unpack_response(self, response_type, raw_data):
        response = response_type()

        for attr in response.attributes_map:
            attr_type = response.attributes_map[attr]['type']
            attr_name = response.attributes_map[attr]['key']

            try:
                raw_value = getattr(raw_data, attr_name)

                value = self._deserialize_data(attr, raw_value, attr_type) 
                setattr(response, attr, value)

            except AttributeError as err:
                raise DeserializationError("Unable to deserialize response data: {0}".format(err))

        for attr in response.headers_map:
            attr_type = response.headers_map[attr]['type']
            attr_name = response.headers_map[attr]['key']

            try:
                raw_value = raw_data.headers[attr_name]

                value = self._deserialize_data(attr, raw_value, attr_type) 
                setattr(response, attr, value)

            except KeyError as err:
                raise DeserializationError("Unable to deserialize response data: {0}".format(err))

        return response

    def deserialize_iter(self, attr, iter_type):
        return [self._deserialize_data(i, iter_type) for i in attr]

    def deserialize_dict(self, attr, dict_type):
        return {str(x):self._deserialize_data(attr[x], dict_type) for x in attr}

    def deserialize_duration(self, attr):
        pass

    def deserialize_time(self, attr):
        pass

    def deserialize_datetime(self, attr):
        pass


