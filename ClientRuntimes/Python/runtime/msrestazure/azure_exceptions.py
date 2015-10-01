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

from ..msrest.serialization import Deserialized


class CloudError(Exception):

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
                self.error_time = Deserialized.deserialize_date(msg_data[2].split(':')[1])

        except (AttributeError, IndexError):
            self._message = value
