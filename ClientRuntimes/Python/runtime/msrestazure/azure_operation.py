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

from ..msrest.serialization import Deserializer
from threading import Thread, Event
import time

class AzureOperationPoller(object):

    def __init__(self, response, update_cmd, status_codes, timeout=30):
        """
        A container for polling long-running Azure requests.
        """
        self._timeout = timeout
        self._response = response
        self._url = self._extract_url()
        self._callbacks = []
        self._status_codes = status_codes

        self._done = Event()
        self._thread = Thread(target=self._poll, args=(update_cmd,))
        self._thread.start()

    def _extract_url(self):
        if self._response.headers['azure-asyncoperation']:
            return self._response.asyncoperation

        elif self._response.headers['location']:
            return self._response.location

    def _delay(self):
        if self._response.headers.get('retry_after'):
            time.sleep(int(self._response.headers['retry_after']))

        else:
            time.sleep(self._timeout)

    def _poll(self, update):
        while True:
            self._delay()
            try:
                self._response = update(self._url)

            except Exception as err:
                self._response = err
                self._done.set()
                return


            if self._response.status_code in [200, 201, 204]:
                self._done.set()
                break

        callbacks, self._callbacks = self._callbacks, []
        while callbacks:
            for call in callbacks:
                call(self._response)

            callbacks, self._callbacks = self._callbacks, []

    def result(timeout=None):
        self.wait(timeout)
        return self._response

    def wait(timeout=None):
        self._thread.join(timeout=timeout)

    def done(self):
        return not self._thread.isAlive()

    def add_done_callback(func):

        if self._done.is_set():
            raise ValueError("Process is complete.")
        
        self._callbacks.append(func)

    def remove_done_callback(func):

        if self._done.is_set():
            raise ValueError("Process is complete.")
        
        self._callbacks = [c for c in self._callbacks if c != func]