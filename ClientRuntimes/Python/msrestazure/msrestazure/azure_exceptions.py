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

from msrest.exceptions import ClientException
from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError
from requests import RequestException


class CloudException(object):

    _attribute_map = {
        'error': {'key': 'code', 'type': 'str'},
        'message': {'key': 'message', 'type': 'str'},
        'data': {'key': 'values', 'type': '{str}'}
        }

    def __init__(self, *args, **kwargs):

        self.error = None
        self.status_code = None
        self._message = None
        self.request_id = None
        self.error_time = None
        self.data = None

        super(CloudException, self).__init__(*args)

    def __setattr__(self, attr, value):
        if attr == 'message':
            self._set_message(value)

        else:
            super(CloudException, self).__setattr__(attr, value)

    def __str__(self):
        return self._message

    @property
    def message(self):
        return self._message

    def _set_message(self, value):

        try:
            value = eval(value)

        except (SyntaxError, TypeError):
            pass

        try:
            if value.get('value'):
                msg_data = value['value'].split('\n')
                self._message = msg_data[0]
                self.request_id = msg_data[1].split(':')[1]

                time_str = msg_data[2].split(':')
                self.error_time = Deserializer.deserialize_iso(
                    ":".join(time_str[1:]))

        except (AttributeError, IndexError,
                DeserializationError):
            self._message = value


class CloudError(ClientException):

    def __str__(self):
        return str(self.message)

    def __init__(self, response, error=None, *args):

        deserialize = Deserializer()
        self.error = None
        self.message = None
        self.response = response
        self.status_code = self.response.status_code

        if error:
            self.message = error
            self.error = response

        else:
            try:
                data = response.json()
                data = data.get('error', data)
                self.error = deserialize(CloudException, data)
                self.message = self.error.message

            except (DeserializationError, AttributeError,
                    KeyError, ValueError):
                pass

        if not self.error or not self.message:

            try:
                content = response.json()
                server_message = content.get('message', "none")

            except ValueError as err:
                server_message = ("none")

            try:
                response.raise_for_status()

            except RequestException as err:
                if not self.error:
                    self.error = err

                if not self.message:

                    if server_message == "none":
                        server_message = str(err)

                    msg = ("Operation failed with status: "
                           "'{}'. Details: {}".format(response.reason,
                                                      server_message))
                    self.message = msg

            else:
                if not self.error:
                    self.error = response

                if not self.message:
                    self.message = ("Operation failed with "
                                    "status: '{}'. Details: {}".format(
                                        response.status_code, server_message))

        super(CloudError, self).__init__(self.message, self.error, *args)
