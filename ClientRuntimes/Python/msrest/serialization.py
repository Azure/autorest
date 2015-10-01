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

class Serialized(object):
    def __init__(self, request_obj):
        self.request = request_obj

        self.serialize_type = {
            'datetime':self.serialize_time,
            'duration':self.serialize_duration,
            'complex':self.serialize_object,
            '[]':self.serialize_iter,
            '{}':self.serialize_dict
            # etc
            }

    def __getattr__(self, attr):
        orig_attr = self.request.__getattribute__(attr)
        attr_type = self.request.attribute_map[attr]['type']

        if orig_attr is None or attr_type in ['str', 'int']:
            return orig_attr

        if attr_type in self.serialize_type:
            return self.serialize_type[attr_type](orig_attr)

        iter_type = attr_type[0] + attr_type[-1]
        if iter_type in self.serialize_type:
            return self.serialize_type[iter_type](orig_attr, attr_type[1,-1])

        return self.serialize_object(orig_attr)

    def __call__(self):
        serialized = {}
        for attr in self.request.attribute_map:
            serialized[self.request.attribute_map[attr]['key']] = self.attr

        return serialized

    def serilize_object(self, cmplx_obj):

        serialized = Serialized(cmplx_obj)
        return serialized()

    def serialize_time(self, attr):
        return str(attr)

    def serialize_iter(self, attr, iter_type):

        if iter_type in ['str','int']:
            return attr

        if iter_type in self.serialize_type:
            return [self.serialize_type[iter_type](i) for i in attr]

        return [self.serilize_object(i) for i in attr]

    def serialize_dict(self, attr, dict_type):

        if dict_type in ['str','int']:
            parse = eval(dict_type)
            return {str(x):parse(attr[x]) for x in attr}

        if dict_type in self.serialize_type:
            return {str(x):self.serialize_type[dict_type](attr[x]) for x in attr}

        return {str(x):self.serilize_object(attr[x]) for x in attr} 


class Deserialized(object):

    def __init__(self, response_obj):
        self.response = self.unpack_response(response_obj)

        self.deserialize_type = {
            'str':self.deserialize_str,
            'datetime':self.deserialize_datetime,
            'duration':self.deserialize_int,
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
            raw_value = body.get(self.response.body_map[attr]['name'])

            value = self.deserialize_data(attr, raw_value, attr_type) 
            setattr(self.response, attr, value)

        return response_obj

    def deserialize_data(attr, data, data_type):
        if data is None or data_type in ['str','int','bool']:
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

    def unpack_response(response_type, raw_data):
        response = response_type()

        for attr in response.attributes_map:
            attr_type = response.attributes_map[attr]['type']
            raw_value = getattr(raw_data, response.attributes_map[attr]['name'])

            value = self.deserialize_data(attr, raw_value, attr_type) 
            setattr(response, attr, value)

        for attr in self.headers_map:
            attr_type = response.headers_map[attr]['type']
            raw_value = raw_data.headers.get(response.attributes_map[attr]['name'])

            value = self.deserialize_data(attr, raw_value, attr_type) 
            setattr(response, attr, value)

        return response


