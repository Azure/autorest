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
from msrest.pipeline import ClientRawResponse
from msrest.exceptions import DeserializationError
from msrestazure.azure_exceptions import CloudError
from threading import Thread, Event
import time
try:
    from urlparse import urlparse

except ImportError:
    from urllib.parse import urlparse


class BadStatus(Exception):
    pass


class BadResponse(Exception):
    pass


class OperationFailed(Exception):
    pass


class LongRunningOperation(object):

    def __init__(self):
        self._status = ""
        self.resource = None
        self.method = None
        self.async_url = None
        self.location_url = None
        self.raw=None

    @property
    def status(self):
        if hasattr(self.resource, 'provisioning_state'):
            if self.resource.provisioning_state:
                return self.resource.provisioning_state.lower()

        return self._status.lower()

    @status.setter
    def status(self, value):
        self._status = value

        if hasattr(self.resource, 'provisioning_state'):
            self.resource.provisioning_state = value

    def _validate(self, url):

        if url is None:
            return None

        parsed = urlparse(url)
        if not parsed.scheme or not parsed.netloc:
            raise ValueError

        return url

    def _is_empty(self, response):

        if not response.content:
            return True

        try:
            body = response.json()
            if not body:
                return True

            return False

        except ValueError:
            raise DeserializationError("Response json invalid.")

    def _deserialize(self, response, cmd):
        resource = cmd(response)
        if isinstance(resource, ClientRawResponse):
            self.resource = resource.output
            self.raw = resource

        else:
            self.resource = resource
        self._status = self.status

    def _get_body_status(self, response):

        if self._is_empty(response):
            return None

        body = response.json()
        if 'status' in body:
            return body['status']

        if 'provisioningState' in body:
            return body['provisioningState']

        return None

    def _object_from_response(self, response): 
        if self.resource is None and self.method not in ['POST', 'DELETE']:
            body = response.json()

            self.resource = type("Resource", (), {})
            for key, value in body.items():
                setattr(self.resource, key, value)

    def _status_200(self, response, outputs):
        self.status = 'Succeeded'
        try:
            self._deserialize(response, outputs)

        except CloudError:
            status = self._get_body_status(response)
            if status:
                self.status = status
            else:
                self._object_from_response(response)

    def _status_201(self, response, outputs):
        try:
            self._deserialize(response, outputs)
            if not self.status:
                self.status = 'Succeeded'

        except CloudError:
            raise BadResponse()

    def _status_202(self, response):
        self.status = 'InProgress'

    def _status_204(self, response):
        self.status = 'Succeeded'
        self.resource = None
    
    def _check_status(self, response):
        code = response.status_code

        if self.method in ['PUT', 'PATCH']:
            if code not in [200, 201, 202]:
                raise BadStatus()

        elif self.method in ['POST', 'DELETE']:
            if code not in [200, 202, 204]:
                raise BadStatus()

    def get_initial_status(self, response, outputs):

        self.method = response.request.method
        self._check_status(response)

        if response.status_code == 204:
            self._status_204(response)
            return

        try:
            self._deserialize(response, outputs)
            if self.status:
                return

        except CloudError:
            raise BadStatus()


        status = self._get_body_status(response)
        if status:
            self.status = status
            return

        if response.status_code == 200:
            self._status_200(response, outputs)
            return

        if response.status_code == 202:
            self._status_202(response)
            return

    def get_status_from_location(self, response, outputs):

        self._check_status(response)

        if self.method in ['POST', 'DELETE']:
            if response.status_code == 202:
                self._status_202(response)
                return

            elif response.status_code == 204:
                self._status_204(response)
                return

            elif response.status_code == 201:
                self._status_201(response, outputs)
                return

            elif response.status_code == 200:
                self._status_200(response, outputs)
                return

        if self.method in ['PUT', 'PATCH']:

            if response.status_code == 202:
                self._status_202(response)
                return

            elif response.status_code == 200:
                if self._is_empty(response):
                    raise BadResponse('The response from long running '
                                      'operation does not contain a body.')

                self._status_200(response, outputs)

            elif response.status_code == 201:
                if self._is_empty(response):
                    raise BadResponse('The response from long running '
                                      'operation does not contain a body.')

                self._status_201(response, outputs)

            else:
                raise BadStatus('Long running operation failed with status '
                                '{}.'.format(response.status_code))
           
    def get_status_from_async(self, response, outputs):

        self._check_status(response)

        if self._is_empty(response):
            raise BadResponse('The response from long running operation '
                              'does not contain a body.')

        self.status = self._get_body_status(response)

        if not self.status:
            raise BadResponse("No status found in body")

        if self.method in ['POST', 'DELETE']:
            try:
                self._deserialize(response, outputs)

            except CloudError:
                pass # Not all accept status will deserialize

    def get_status_from_resource(self, response, outputs):

        self._check_status(response)

        if self.method in ['POST', 'DELETE']:
            if response.status_code == 204:
                self._status_204(response)
                return

            elif response.status_code == 200:
                self._status_200(response, outputs)
                return

            else:
                raise BadResponse('Location header is missing from '
                                  'long running operation.')

        if self._is_empty(response):
            raise BadResponse('The response from long running operation '
                              'does not contain a body.')
        
        self._status_200(response, outputs)

    def get_retry(self, response):

        try:
            self.async_url = self._validate(
                response.headers.get('azure-asyncoperation'))

            # Return if we have a url, in case location header raises error
            if self.async_url:
                return

        except ValueError:
            pass # We can ignore as location header may still be valid

        self.location_url = self._validate(response.headers.get('location'))

        if not self.location_url:

            # TODO: There must be a nicer way to handle this scenario...
            code = response.status_code
            if code not in [200, 204] and self.method in ['POST']:
                raise BadResponse(
                    'Location header is missing from long running operation.')

class AzureOperationPoller(object):

    finished_states = ['succeeded', 'failed', 'canceled']
    failed_states = ['failed', 'canceled']

    def __init__(self, send_cmd, output_cmd, update_cmd,
                 timeout=30, callback=None):
        """
        A container for polling long-running Azure requests.
        """
        self._timeout = timeout
        self._response = None

        self._callbacks = []
        if callback:
            self._callbacks.append(callback)

        self._operation = LongRunningOperation()

        self._done = Event()

        self._thread = Thread(
            target=self._start, args=(send_cmd, update_cmd, output_cmd))

        self._thread.start()

    def _start(self, send_cmd, update_cmd, output_cmd):

        try:
            self._response = send_cmd()
            self._operation.get_initial_status(self._response, output_cmd)      

            self._poll(update_cmd, output_cmd)

        except BadStatus:
            self._operation.status = 'Failed'
            self._operation.resource = CloudError(self._response)

        except BadResponse as err:
            self._operation.status = 'Failed'
            self._operation.resource = CloudError(self._response, str(err))

        except OperationFailed:
            error = "Long running operation failed with status '{}'".format(self._operation.status)
            self._operation.resource = CloudError(self._response, error)

        except Exception as err:
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

    def _polling_cookie(self, url):
        # Collect retry cookie - we only want to do this for the test server
        # at this point, unless we implement a proper cookie policy.

        parsed_url = urlparse(url)
        if parsed_url.hostname == 'localhost':
            return {'cookie': self._response.headers.get('set-cookie', '')}

        return {}

    def _poll(self, update_cmd, output_cmd):

        while self._operation.status not in self.finished_states:

            url = self._response.request.url
            headers = self._polling_cookie(url)
            self._operation.get_retry(self._response)

            if self._operation.async_url:
                self._response = update_cmd(self._operation.async_url, headers)
                self._operation.get_status_from_async(self._response, output_cmd)

            elif self._operation.location_url:
                self._response = update_cmd(self._operation.location_url, headers)
                self._operation.get_status_from_location(self._response, output_cmd)

            else:
                self._response = update_cmd(url, headers)
                self._operation.get_status_from_resource(self._response, output_cmd)

        if self._operation.status in self.failed_states:
            raise OperationFailed()

    def result(self, timeout=None):
        self.wait(timeout)

        if isinstance(self._operation.resource, Exception):
            raise self._operation.resource

        if self._operation.raw:
            return self._operation.raw

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