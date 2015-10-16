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

from threading import Thread, Event
import time
import pickle

class Paged(object):

    def __init__(self, items, url, command):

        self.items = items
        self.url = url
        self.command = command

    def __iter__(self):
        for i in self.items:
            yield i

        while self.url is not None:
            self.items, self.url = self.command(self.url)

            for i in self.items:
                yield i

    def __len__(self):
        return len(self.items)

    def __getitem__(self, index):
        return self.items[index]


class Polled(object):

    def __init__(self, response, update_cmd):

        self._response = response
        self._url = self._extract_url()
        self._callbacks = []

        self._done = Event()
        self._thread = Thread(target=self._poll, args=(update_cmd,))
        self._thread.start()

    def _extract_url(self):
        if self._response.asyncoperation:
            return self._response.asyncoperation

        elif self._response.location:
            return self._response.location

    def _poll(self, update):
        while True:
            time.sleep(POLLING_DELAY)
            self._response = update(self._url)

            if self._response.status_code in []:
                self._done.set()
                break

        callbacks = list(self._callbacks)
        for call in callbacks:
            call(self._response)

        if len(callbacks) != len(self._callbacks):
            more_calls = [c for c in self._callbacks if c not in callbacks]
            for call in more_calls:
                call(self._response)

    def result(timeout=None):
        self.wait(timeout)
        return self._response

    def wait(timeout=None):
        self._thread.join(timeout=timeout)

    def done(self):
        return not self._thread.isAlive()

    def add_done_callback(func):

        if self._done.is_set():
            raise Exception("Process is complete.")
        
        self._callbacks.append(func)

    def remove_done_callback(func):

        if self._done.is_set():
            raise Exception("Process is complete")
        
        self._callbacks = [c for c in self._callbacks if c != func]