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
from msrest.exceptions import DeserializationError
from msrestazure.azure_exceptions import CloudError
from threading import Thread, Event
import time
try:
    from urlparse import urlparse

except ImportError:
    from urllib.parse import urlparse

class PollingFinished(Exception):
    pass

class BadStatus(PollingFinished):
    pass

class BadResponse(PollingFinished):
    pass

class OperationFailed(PollingFinished):
    pass

class LongRunningOperation(object):

    def __init__(self):
        self.status = ""
        self.resource = None
        self.method = None
        self.async_url = None
        self.location_url = None

    def _validate(self, url):
        if url is None:
            return None
        parsed = urlparse(url)
        if not parsed.scheme or not parsed.netloc:
            raise ValueError
        return url

    def get_body_status(self, response):

        if self.is_empty(response):
            return None

        body = response.json()
        if 'status' in body:
            return body['status']

        if 'provisioningState' in body:
            return body['provisioningState']

        return None

    def is_empty(self, response):

        if not response.content:
            return True

        try:
            body = response.json()
            if not body:
                return True

            return False

        except ValueError:
            raise DeserializationError("Response invalid json.")

    def check_status(self, response):
        code = response.status_code

        if self.method in ['PUT', 'PATCH']:
            if code not in [200, 201, 202]:
                raise BadStatus()

        elif self.method in ['POST', 'DELETE']:
            if code not in [200, 202, 204]:
                raise BadStatus()

    def get_initial_status(self, response, outputs):

        self.check_status(response)

        if response.status_code == 204:
            self.status = 'Succeeded'
            self.resource = None
            return

        try:
            self.resource = outputs(response)
            if hasattr(self.resource, 'provisioning_state'):
                if self.resource.provisioning_state:
                    self.status = self.resource.provisioning_state
                    return

        except CloudError as err:
            raise BadStatus()


        status = self.get_body_status(response)
        if status:
            self.status = status
            return

        if response.status_code == 200:
            self.status = 'Succeeded'

            if hasattr(self.resource, 'provisioning_state'):
                self.resource.provisioning_state = self.status

        if response.status_code == 202:
            self.status = 'InProgress'


    def get_status_from_location(self, response, outputs):

        self.check_status(response)

        if self.method in ['POST', 'DELETE']:
            if response.status_code == 202:
                self.status = 'InProgress'
                return

            elif response.status_code == 204:
                self.status = 'Succeeded'
                self.resource = None
                return

            elif response.status_code == 201:
                self.resource = outputs(response)
                if hasattr(self.resource, 'provisioning_state') and self.resource.provisioning_state is not None:
                    self.status = self.resource.provisioning_state
                else:
                    self.status = 'Succeeded'

            elif response.status_code == 200:
                self.status = 'Succeeded'
                try:
                    self.resource = outputs(response)
                except CloudError:
                    status = self.get_body_status(response)
                    if status:
                        self.status = status
                    if hasattr(self.resource, 'provisioning_state'):
                        self.resource.provisioning_state = self.status

        if self.method in ['PUT', 'PATCH']:

            if response.status_code == 202:
                self.status = 'InProgress'

            elif response.status_code == 200:
                if self.is_empty(response):
                    raise BadResponse('The response from long running operation does not contain a body.')

                self.status = 'Succeeded'
                try:
                    self.resource = outputs(response)
                    if hasattr(self.resource, 'provisioning_state'):
                        if self.resource.provisioning_state:
                            self.status = self.resource.provisioning_state

                except CloudError:
                    status = self.get_body_status(response)
                    if status:
                        self.status = status
                    if hasattr(self.resource, 'provisioning_state'):
                        self.resource.provisioning_state = self.status

            elif response.status_code == 201:
                if self.is_empty(response):
                    raise BadResponse('The response from long running operation does not contain a body.')

                self.status = 'Succeeded'
                self.resource = outputs(response)

                if hasattr(self.resource, 'provisioning_state'):
                    if self.resource.provisioning_state:
                        self.status = self.resource.provisioning_state

            else:
                raise BadStatus('Long running operation failed with status {}.'.format(response.status_code))
           
    def get_status_from_async(self, response, outputs):
        self.check_status(response)

        if self.is_empty(response):
            raise BadResponse('The response from long running operation does not contain a body.')

        self.status = self.get_body_status(response)

        if not self.status:
            raise BadResponse("No status found in body")


        if self.method in ['POST', 'DELETE']:
            try:
                self.resource = outputs(response)
                if hasattr(self.resource, 'provisioning_state'):
                    if self.resource.provisioning_state:
                        self.status = self.resource.provisioning_state

            except CloudError:
                if hasattr(self.resource, 'provisioning_state'):
                    self.resource.provisioning_state = self.status

        elif hasattr(self.resource, 'provisioning_state'):
            self.resource.provisioning_state = self.status

    def get_status_from_resource(self, response, outputs):

        self.check_status(response)

        if self.method in ['POST', 'DELETE']:
            if response.status_code == 204:
                self.status = 'Succeeded'
                self.resource = None
                return

            elif response.status_code == 200:
                self.status = 'Succeeded'
                try:
                    self.resource = outputs(response)
                    if hasattr(self.resource, 'provisioning_state'):
                        if self.resource.provisioning_state:
                            self.status = self.resource.provisioning_state

                except CloudError:
                    status = self.get_body_status(response)
                    if status:
                        self.status = status
                    if hasattr(self.resource, 'provisioning_state'):
                        self.resource.provisioning_state = self.status
                return

            else:
                raise BadResponse('Location header is missing from long running operation.')


        if self.is_empty(response):
            raise BadResponse('The response from long running operation does not contain a body.')
        
        self.status = 'Succeeded'

        try:
            self.resource = outputs(response)
            if hasattr(self.resource, 'provisioning_state'):
                if self.resource.provisioning_state:
                    self.status = self.resource.provisioning_state

        except CloudError:
            status = self.get_body_status(response)
            if status:
                self.status = status
            if hasattr(self.resource, 'provisioning_state'):
                self.resource.provisioning_state = self.status

    def get_retry(self, response):

        try:
            self.async_url = self._validate(response.headers.get('azure-asyncoperation'))
            if self.async_url:
                return

        except ValueError:
            pass

        self.location_url = self._validate(response.headers.get('location'))

        if not self.location_url:
            if response.status_code not in [200, 204] and self.method in ['POST']:
                raise BadResponse('Location header is missing from long running operation.')

class AzureOperationPoller(object):

    accept_states = [200, 202, 201, 204]
    finished_states = ['failed', 'canceled', 'succeeded']

    def __init__(self, send_cmd, output_cmd, update_cmd, timeout=30):
        """
        A container for polling long-running Azure requests.
        """
        self._timeout = timeout
        self._response = None
        self._no_retry = False
        self._url = None
        self._callbacks = []
        self._operation = LongRunningOperation()
        self._update_cmd = update_cmd
        self._output_cmd = output_cmd

        self._done = Event()

        self._thread = Thread(target=self._start, args=(send_cmd,))
        self._thread.start()

    def _start(self, send_cmd):

        try:
            self._response = send_cmd()
            self._operation.method = self._response.request.method
            self._operation.get_initial_status(self._response, self._output_cmd)      

            self._poll()

        except BadStatus:
            self._operation.status = 'Failed'
            self._operation.resource = CloudError(None, self._response, self._operation.resource)

        except BadResponse as err:
            self._operation.status = 'Failed'
            self._operation.resource = CloudError(None, self._response, str(err))

        except OperationFailed:
            error = "Long running operation failed with status '{}'".format(self._operation.status)
            self._operation.resource = CloudError(None, self._response, error)

        except DeserializationError as err:
            self._operation.resource = err

        except ValueError as err:
            self._operation.resource = err

        finally:
            self._done.set()

        callbacks, self._callbacks = self._callbacks, []
        while callbacks:
            for call in callbacks:
                call(self._response)

            callbacks, self._callbacks = self._callbacks, []

    def _delay(self):
        if self._response is None:
            return 

        if self._response.headers.get('retry-after'):
            time.sleep(int(self._response.headers['retry-after']))

        else:
            time.sleep(self._timeout)

    def _poll(self):

        while self._operation.status.lower() not in self.finished_states:

            headers = {}
            headers['cookie'] = self._response.headers.get('set-cookie', "")

            url = self._response.request.url
            self._operation.get_retry(self._response)

            if self._operation.async_url:
                self._response = self._update_cmd(self._operation.async_url, headers)
                self._operation.get_status_from_async(self._response, self._output_cmd)

            elif self._operation.location_url:
                self._response = self._update_cmd(self._operation.location_url, headers)
                self._operation.get_status_from_location(self._response, self._output_cmd)

            else:
                self._response = self._update_cmd(url, headers)
                self._operation.get_status_from_resource(self._response, self._output_cmd)

        if self._operation.status.lower() in ['failed', 'canceled']:
            raise OperationFailed()



        

    def result(self, timeout=None):
        self.wait(timeout)
        if isinstance(self._operation.resource, Exception):
            raise self._operation.resource
        return self._operation.resource

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