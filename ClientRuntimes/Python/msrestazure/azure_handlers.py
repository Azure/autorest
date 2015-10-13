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

from multiprocessing import Process, Queue, Value, Lock
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

    def __init__(self, response, command):

        self._lock = Lock()
        kwargs = {}
        url = self._extract_url(response)

        setattr(Poller, "command", staticmethod(command))

        for attr,value in Poller._extract_attributes(response).items():
            attr_name = '_' + attr
            attr_val = Value('c_char_p', False)
            attr_val.value = pickle.dumps(value)

            setattr(self, attr_name, attr_val)

            def get_attr(s):
                with s._lock:
                    return pickle.loads(getattr(s, attr_name).value)

            setattr(Poller, attr, property(get_attr))
            kwargs[attr] = attr_val
            

        self.p = Process(target=Poller.poll, args=(self._lock, url, kwargs))
        self.p.start()

    def _extract_attributes(self, response):
        attrs = response.__dict__
        attrs.pop('attributes_map')
        attrs.pop('headers_map')
        attrs.pop('body_map')
        return attrs

    def _extract_url(self, response):
        if response.asyncoperation:
            return response.asyncoperation

        elif response.location:
            status_link = response.location

    @staticmethod
    def poll(lock, url, kwargs):

        while True:
            response = Poller.command()

            with lock:
                for attr in kwargs:
                    kwargs[attr].value = pickle.dumps(getattr(response, attr))

            if response.status_code in ['x','y','z']:
                break

            time.sleep(POLLING_DELAY)