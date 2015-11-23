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

from msrest.exceptions import ClientException
from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError
from requests import RequestException


class CloudException(object):

    _response_map = {
        'status_code': {'key':'status_code', 'type':'str'}
        }

    _attribute_map = {
        'error': {'key':'code', 'type':'str'},
        'message': {'key':'message', 'type':'{str}'},
        'data': {'key':'values', 'type':'{str}'}
        }


    def __init__(self, *args, **kwargs):

        self.error = None
        self.status_code = None
        self._message = None
        self.request_id = None
        self.error_time = None
        self.data = None

        super(CloudError, self).__init__(*args)

    def __str__(self):
        return self._message

    @property
    def message(self):
        return self._message

    @message.setter
    def message(self,value):
        try:
            if value.get('value'):
                msg_data = value['value'].split('\n')
                self._message = msg_data[0]
                self.request_id = msg_data[1].split(':')[1]
                self.error_time = Deserializer.deserialize_iso(
                    msg_data[2].split(':')[1])

        except (AttributeError, IndexError):
            self._message = value

class CloudError(ClientException):

    def __str__(self):
        return str(self.message)

    def __init__(self, deserializer, response, output=None, *args):

        deserialize = deserializer if deserializer else Deserializer()
        self.error = None
        self.message = None
        self.response = response

        if output:
            raise_states = ['failed', 'canceled']

            if hasattr(output, 'provisioning_state'):
                if output.provisioning_state.lower() in raise_states:
                    self.error = output
                    self.message = "Long running operation failed"

        else:
            try:
                self.error = deserialize(CloudException, response)
                self.message = self.error.message

            except (DeserializationError, AttributeError, KeyError):
                pass
        
        if not self.error or not self.message:

            try:
                response.raise_for_status()

            except RequestException as err:
                if not self.error:
                    self.error = err

                if not self.message:
                    msg = ("Operation returned an invalid status code "
                           "'{}'".format(response.reason))
                    self.message = msg

            else:
                self.error = output if output else response
                self.message = "Long running operation failed"

        super(CloudError, self).__init__(self.message, self.error, *args)
