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

from requests import RequestException

from msrest.exceptions import ClientException
from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError


class CloudErrorData(object):
    """Cloud Error Data object, deserialized from error data returned
    during a failed REST API call.
    """

    _validation = {}
    _attribute_map = {
        'error': {'key': 'code', 'type': 'str'},
        'message': {'key': 'message', 'type': 'str'},
        'data': {'key': 'values', 'type': '{str}'}
        }

    def __init__(self, *args, **kwargs):
        self.error = None
        self._message = None
        self.request_id = None
        self.error_time = None
        self.data = None
        super(CloudErrorData, self).__init__(*args)

    def __str__(self):
        """Cloud error message."""
        return str(self._message)

    @classmethod
    def _get_subtype_map(cls):
        return {}

    @property
    def message(self):
        """Cloud error message."""
        return self._message

    @message.setter
    def message(self, value):
        """Attempt to deconstruct error message to retrieve further
        error data.
        """
        try:
            value = eval(value)
        except (SyntaxError, TypeError):
            pass
        try:
            value = value.get('value', value)
            msg_data = value.split('\n')
            self._message = msg_data[0]
        except AttributeError:
            self._message = value
            return
        try:
            self.request_id = msg_data[1].partition(':')[2]
            time_str = msg_data[2].partition(':')
            self.error_time = Deserializer.deserialize_iso(
                "".join(time_str[2:]))
        except (IndexError, DeserializationError):
            pass


class CloudError(ClientException):
    """ClientError, exception raised for failed Azure REST call.
    Will attempt to deserialize response into meaningful error
    data.

    :param requests.Response response: Response object.
    :param str error: Optional error message.
    """

    def __init__(self, response, error=None, *args):
        deserialize = Deserializer()
        self.error = None
        self.message = None
        self.response = response
        self.status_code = self.response.status_code
        self.request_id = None

        if error:
            self.message = error
            self.error = response
        else:
            try:
                data = response.json()
            except ValueError:
                data = response
            else:
                data = data.get('error', data)
            try:
                self.error = deserialize(CloudErrorData(), data)
            except DeserializationError:
                self.error = None
            try:
                self.message = self.error.message
            except AttributeError:
                self.message = None

        if not self.error or not self.message:
            try:
                content = response.json()
            except ValueError:
                server_message = "none"
            else:
                server_message = content.get('message', "none")
            try:
                response.raise_for_status()
            except RequestException as err:
                if not self.error:
                    self.error = err
                if not self.message:
                    if server_message == "none":
                        server_message = str(err)
                    msg = "Operation failed with status: {!r}. Details: {}"
                    self.message = msg.format(response.reason, server_message)
            else:
                if not self.error:
                    self.error = response
                if not self.message:
                    msg = "Operation failed with status: {!r}. Details: {}"
                    self.message = msg.format(
                        response.status_code, server_message)

        super(CloudError, self).__init__(self.message, self.error, *args)

    def __str__(self):
        """Cloud error message"""
        return str(self.message)
