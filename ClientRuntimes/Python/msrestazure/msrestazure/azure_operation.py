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

from msrest.serialization import Deserializer
from msrestazure.azure_exceptions import CloudError
from threading import Thread, Event
import time
try:
    from urlparse import urlparse

except ImportError:
    from urllib.parse import urlparse

class PollingFinished(Exception):
    pass

class NoRetryUrl(PollingFinished):
    pass

class BadReturnStatus(PollingFinished):
    pass

class OperationFinished(PollingFinished):
    pass

class AzureOperationPoller(object):

    accept_states = [200, 202, 201, 204]
    raise_states = ['failed', 'canceled']
    done_states = ['succeeded']

    def __init__(self, send_cmd, output_cmd, update_cmd, timeout=30):
        """
        A container for polling long-running Azure requests.
        """
        self._timeout = timeout
        self._response = None
        self._no_retry = False
        self._url = None
        self._callbacks = []
        self._output = None

        self._done = Event()
        self._thread = Thread(target=self._poll, args=(send_cmd, update_cmd, output_cmd))
        self._thread.start()

    def _extract_url(self):

        if self._response.headers.get('azure-asyncoperation'):
            self._no_retry = True
            self._url = self._response.headers.get('azure-asyncoperation')

        elif self._response.headers.get('location'):
            self._no_retry = True
            self._url = self._response.headers['location']

        elif not self._no_retry and self._response.content:
            self._url = self._response.request.url

        else:
            raise NoRetryUrl()
        self._validate_url()

    def _check_state(self):

        if isinstance(self._output, Exception):
            raise OperationFinished()

        if self._response.status_code not in self.accept_states:
            raise BadReturnStatus()

        if hasattr(self._output, 'provisioning_state'):
            if self._output.provisioning_state is None:
                raise OperationFinished()

            if self._output.provisioning_state.lower() in self.raise_states:
                self._output = CloudError(None, self._response, self._output)
                raise OperationFinished()

            if self._output.provisioning_state.lower() in self.done_states:
                raise OperationFinished()

    def _set_implicit_state(self):
        if hasattr(self._output, 'provisioning_state'):
            self._output.provisioning_state = 'Succeeded'

    def _validate_url(self):
        parsed = urlparse(self._url)
        if not parsed.scheme or not parsed.netloc:
            raise ValueError("Invalid URL: {}".format(self._url))

    def _delay(self):
        if self._response is None:
            return 

        if self._response.headers.get('retry-after'):
            time.sleep(int(self._response.headers['retry-after']))

        else:
            time.sleep(self._timeout)

    def _poll(self, send, update, outputs):
        try:
            while True:
                self._delay()

                if self._response is None:
                    self._response = send()

                else:
                    self._response = update(self._url)

                self._extract_url()
                self._output = outputs(self._response)
                self._check_state()

        except NoRetryUrl:
            if self._response.status_code in self.accept_states:
                if self._output:
                    self._set_implicit_state()

        except PollingFinished:
            pass

        except Exception as err:
            self._output = err

        finally:
            self._done.set()

        callbacks, self._callbacks = self._callbacks, []
        while callbacks:
            for call in callbacks:
                call(self._response)

            callbacks, self._callbacks = self._callbacks, []

    def result(self, timeout=None):
        self.wait(timeout)
        if isinstance(self._output, Exception):
            raise self._output
        return self._output

    def wait(self, timeout=None):
        self._thread.join(timeout=timeout)

    def done(self):
        return not self._thread.isAlive()

    def add_done_callback(self, func):

        if self._done.is_set():
            raise ValueError("Process is complete.")
        
        self._callbacks.append(func)

    def remove_done_callback(self, func):

        if self._done.is_set():
            raise ValueError("Process is complete.")
        
        self._callbacks = [c for c in self._callbacks if c != func]