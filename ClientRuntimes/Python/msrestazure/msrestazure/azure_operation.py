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

import threading
import time
try:
    from urlparse import urlparse
except ImportError:
    from urllib.parse import urlparse

from msrest.pipeline import ClientRawResponse
from msrest.exceptions import DeserializationError
from msrestazure.azure_exceptions import CloudError


FINISHED = frozenset(['succeeded', 'canceled', 'failed'])
FAILED = frozenset(['canceled', 'failed'])
SUCCEEDED = frozenset(['succeeded'])


def finished(status):
    return str(status).lower() in FINISHED


def failed(status):
    return str(status).lower() in FAILED


def succeeded(status):
    return str(status).lower() in SUCCEEDED


class BadStatus(Exception):
    pass


class BadResponse(Exception):
    pass


class OperationFailed(Exception):
    pass


class OperationFinished(Exception):
    pass


class SimpleResource:
    """An implementation of Python 3 SimpleNamespace.
    Used to deserialize resource objects from response bodies where
    no particular object type has been specified.
    """

    def __init__(self, **kwargs):
        self.__dict__.update(kwargs)

    def __repr__(self):
        keys = sorted(self.__dict__)
        items = ("{}={!r}".format(k, self.__dict__[k]) for k in keys)
        return "{}({})".format(type(self).__name__, ", ".join(items))

    def __eq__(self, other):
        return self.__dict__ == other.__dict__


class LongRunningOperationMixin(object):
    """LongRunningOperation Mixin
    Provides default logic for interpreting operation responses
    and status updates.
    """

    def _validate(self, url):
        """Validate header url

        :param str url: Polling URL extracted from response header.
        :returns: URL if valid.
        :raises: ValueError if URL has not scheme or host.
        """
        if url is None:
            return None
        parsed = urlparse(url)
        if not parsed.scheme or not parsed.netloc:
            raise ValueError("Invalid URL header")
        return url

    def _is_empty(self, response):
        """Check if response body contains meaningful content.

        :rtype: bool
        :raises: DeserializationError if response body contains invalid
         json data.
        """
        if not response.content:
            return True
        try:
            body = response.json()
            return not body
        except ValueError:
            raise DeserializationError("Response json invalid")

    def _deserialize(self, response):
        """Attempt to deserialize resource from response.

        :raises: OperationFailed if deserialized resource has status of
         failed or cancelled.
        :raises: OperationFinished if deserialised resource has status
         succeeded.
        """
        resource = self.get_outputs(response)
        if isinstance(resource, ClientRawResponse):
            self.resource = resource.output
            self.raw = resource
        else:
            self.resource = resource

        try:
            if failed(self.resource.provisioning_state):
                self.status = self.resource.provisioning_state
                raise OperationFailed("Operation failed or cancelled")
            elif succeeded(self.resource.provisioning_state):
                raise OperationFinished("Operation succeeded")
            elif self.resource.provisioning_state:
                self.status = self.resource.provisioning_state
        except AttributeError:
            pass

    def _get_body_status(self, response):
        """Attempt to find status info in response body.

        :param requests.Response response: latest REST call response.
        :rtype: str
        :returns: Status if found, else 'None'.
        """
        if self._is_empty(response):
            return None

        body = response.json()
        return body.get('status')

    def _get_resource_status(self):
        """
        Attempt to get provisioning state from resource.
        :returns: Status if found, else 'None'.
        """
        try:
            return self.resource.provisioning_state
        except AttributeError:
            pass
        try:
            return self.resource.properties.provisioning_state
        except AttributeError:
            return None

    def _object_from_response(self, response):
        """If deserialization fails, attempt to create object from
        response body regardless.
        Required functionality for Azure LRO's....

        :param requests.Response response: latest REST call response.
        """
        body = response.json()
        state = body.get('properties', body).get('provisioningState')

        if self.resource is None:
            self.resource = SimpleResource(**body)
        elif state:
            if hasattr(self.resource, 'provisioning_state'):
                self.resource.provisioning_state = state

    def _process_status(self, response):
        """Process response based on specific status code.

        :param requests.Response response: latest REST call response.
        """
        method = getattr(self, '_status_' + str(response.status_code))
        method(response)

    def _status_200(self, response):
        """Process response with status code 200.

        :param requests.Response response: latest REST call response.
        """
        status = self._get_body_status(response)
        self.status = status if status else 'Succeeded'
        if not status:
            try:
                # Even if this fails, status '200' should be successful.
                self._deserialize(response)
            except CloudError:
                self._object_from_response(response)

    def _status_201(self, response):
        """Process response with status code 201.

        :param requests.Response response: latest REST call response.
        :raises: BadResponse if response deserializes to CloudError.
        """
        try:
            self._deserialize(response)
            if not self.status:
                self.status = 'Succeeded'
        except CloudError as err:
            raise BadResponse(str(err))

    def _status_202(self, response):
        """Process response with status code 202.
        Just sets status to 'InProgress'.

        :param requests.Response response: latest REST call response.
        """
        self.status = 'InProgress'

    def _status_204(self, response):
        """Process response with status code 204.
        Interpretted as successful with no payload.

        :param requests.Response response: latest REST call response.
        """
        self.status = 'Succeeded'
        self.resource = None

    def is_done(self):
        """Check whether the operation can be considered complete.
        This is based on whether the data in the resource matches the current
        status. If there is not resource, we assume it's complete.

        :rtype: bool
        """
        resouce_state = self._get_resource_status()
        try:
            return self.status.lower() == resouce_state.lower()
        except AttributeError:
            return True

    def get_initial_status(self, response):
        """Process first response after initiating long running
        operation.

        :param requests.Response response: initial REST call response.
        """
        self._check_status(response)
        if response.status_code == 204:
            self._status_204(response)
            return
        try:
            self._deserialize(response)
            if self.status:
                return
        except CloudError as err:
            raise BadStatus(str(err))

        status = self._get_body_status(response)
        if status:
            self.status = status
        if response.status_code in [200, 202]:
            self._process_status(response)

    def get_retry(self, response, *args):
        """Retrieve the URL that will be polled for status. First looks for
        'azure-asyncoperation' header, if not found or invalid, check for
        'location' header.

        :param requests.Response response: latest REST call response.
        """
        try:
            self.async_url = self._validate(
                response.headers.get('azure-asyncoperation'))

            # Return if we have a url, in case location header raises error.
            if self.async_url:
                return
        except ValueError:
            pass  # We can ignore as location header may still be valid.
        self.location_url = self._validate(response.headers.get('location'))


class PostDeleteOperation(LongRunningOperationMixin):
    """LongRunningOperation object for a POST or DELETE request.

    :param requests.Response response: initial REST call response.
    :param callable outputs: Function to deserialize operation resource.
    """

    def __init__(self, response, outputs):
        self.method = response.request.method
        self.status = ""
        self.resource = None
        self.get_outputs = outputs
        self.async_url = None
        self.location_url = None
        self.raw = None

    def _check_status(self, response):
        """Check response status code is valid for a Put or Patch
        reqest. Must be 200, 202, or 204.

        :raises: BadStatus if invalid status.
        """
        if response.status_code not in [200, 202, 204]:
            raise BadStatus(
                "Invalid return status for 'POST' or 'DELETE' call")

    def get_status_from_location(self, response):
        """Process the latest status update retrieved from a 'location'
        header.

        :param requests.Response response: latest REST call response.
        """
        self._check_status(response)
        self._process_status(response)

    def get_status_from_resource(self, response):
        """Process the latest status update retrieved from the same URL as
        the previous request.

        :param requests.Response response: latest REST call response.
        :raises: BadResponse if status not 200 or 204.
        """
        self._check_status(response)
        if response.status_code in [200, 204]:
            self._process_status(response)
        else:
            raise BadResponse('Location header is missing from '
                              'long running operation.')

    def get_status_from_async(self, response):
        """Process the latest status update retrieved from a
        'azure-asyncoperation' header.

        :param requests.Response response: latest REST call response.
        :raises: BadResponse if response has no body, or body does not
         contain status.
        """
        self._check_status(response)
        if self._is_empty(response):
            raise BadResponse('The response from long running operation '
                              'does not contain a body.')

        self.status = self._get_body_status(response)
        if not self.status:
            raise BadResponse("No status found in body")
        try:
            self._deserialize(response)
        except CloudError:
            pass  # Not all 'accept' statuses will deserialize.

    def _object_from_response(self, response):
        """For a POST of DELETE request, there's no need to attempt
        resource deserialization.
        """
        pass

    def get_retry(self, response, first_call):
        """Add addtional logic to super get_retry to accommodate POST
        calls which must fail if no 'Location' or 'Async' headers are found
        and status code is 202.
        """
        super(PostDeleteOperation, self).get_retry(response)
        if not self.location_url and not self.async_url:
            code = response.status_code
            if code == 202 and self.method == 'POST':
                raise BadResponse(
                    'Location header is missing from long running operation.')


class PutPatchOperation(LongRunningOperationMixin):
    """LongRunningOperation object for a PUT or PATCH request.

    :param requests.Response response: initial REST call response.
    :param callable outputs: Function to deserialize operation resource.
    """

    def __init__(self, response, outputs):
        self.status = ""
        self.resource = None
        self.get_outputs = outputs
        self.async_url = None
        self.location_url = None
        self.raw = None

    def _check_status(self, response):
        """Check response status code is valid for a Put or Patch
        reqest. Must be 200, 201, or 202.

        :raises: BadStatus if invalid status.
        """
        if response.status_code not in [200, 201, 202]:
            raise BadStatus("Invalid return status for 'PUT' or 'PATCH' call")

    def is_done(self):
        """Check whether the operation can be considered complete.
        For a PUT or PATCH function, result should include a deserialized
        payload.

        :rtype: bool
        """
        is_done = super(PutPatchOperation, self).is_done()
        if not self.resource:
            return False
        return is_done

    def get_status_from_location(self, response):
        """Process the latest status update retrieved from a 'location'
        header.

        :param requests.Response response: latest REST call response.
        :raises: BadResponse if response has no body and not status 202.
        """
        self._check_status(response)
        if response.status_code == 202:
            self._status_202(response)
        else:
            if self._is_empty(response):
                raise BadResponse('The response from long running '
                                  'operation does not contain a body.')
            self._process_status(response)

    def get_status_from_resource(self, response):
        """Process the latest status update retrieved from the same URL as
        the previous request.

        :param requests.Response response: latest REST call response.
        :raises: BadResponse if response has no body.
        """
        self._check_status(response)
        if self._is_empty(response):
            raise BadResponse('The response from long running operation '
                              'does not contain a body.')

        self._status_200(response)

    def get_status_from_async(self, response):
        """Process the latest status update retrieved from a
        'azure-asyncoperation' header.

        :param requests.Response response: latest REST call response.
        :raises: BadResponse if response has no body, or body does not
         contain status.
        """
        self._check_status(response)
        if self._is_empty(response):
            raise BadResponse('The response from long running operation '
                              'does not contain a body.')

        self.status = self._get_body_status(response)
        if not self.status:
            raise BadResponse("No status found in body")


class AzureOperationPoller(object):
    """Initiates long running operation and polls status in separate
    thread.

    :param callable send_cmd: The API request to initiate the operation.
    :param callable update_cmd: The API reuqest to check the status of
        the operation.
    :param callable output_cmd: The function to deserialize the resource
        of the operation.
    :param int timeout: Time in seconds to wait between status calls,
        default is 30.
    :param callable func: Callback function that takes at least one
        argument, a completed LongRunningOperation (optional).
    """

    operations = {'PUT': PutPatchOperation,
                  'PATCH': PutPatchOperation,
                  'POST': PostDeleteOperation,
                  'DELETE': PostDeleteOperation}

    def __init__(self, send_cmd, output_cmd, update_cmd, timeout=30):
        self._timeout = timeout
        self._response = None
        self._operation = None
        self._exception = None
        self._callbacks = []
        self._done = threading.Event()
        self._thread = threading.Thread(
            target=self._start, args=(send_cmd, update_cmd, output_cmd))
        self._thread.start()

    def _start(self, send_cmd, update_cmd, output_cmd):
        """Start the long running operation.
        On completetion, runs any callbacks.

        :param callable send_cmd: The API request to initiate the operation.
        :param callable update_cmd: The API reuqest to check the status of
         the operation.
        :param callable output_cmd: The function to deserialize the resource
         of the operation.
        """
        try:
            self._response = send_cmd()
            try:
                op_type = self.operations[self._response.request.method]
                self._operation = op_type(self._response, output_cmd)
                self._operation.get_initial_status(self._response)
            except KeyError:
                error = "Request type {!r} is not a valid polling request"
                raise TypeError(error.format(self._response.request.method))
            else:
                self._poll(update_cmd)

        except BadStatus:
            self._operation.status = 'Failed'
            self._exception = CloudError(self._response)

        except BadResponse as err:
            self._operation.status = 'Failed'
            self._exception = CloudError(self._response, str(err))

        except OperationFailed:
            error = "Long running operation failed with status {!r}".format(
                str(self._operation.status))
            self._exception = CloudError(self._response, error)

        except OperationFinished:
            pass

        except Exception as err:
            self._exception = err

        finally:
            self._done.set()

        callbacks, self._callbacks = self._callbacks, []
        while callbacks:
            for call in callbacks:
                call(self._operation)
            callbacks, self._callbacks = self._callbacks, []

    def _delay(self):
        """Check for a 'retry-after' header to set timeout,
        otherwise use configured timeout.
        """
        if self._response is None:
            return
        if self._response.headers.get('retry-after'):
            time.sleep(int(self._response.headers['retry-after']))
        else:
            time.sleep(self._timeout)

    def _polling_cookie(self):
        """Collect retry cookie - we only want to do this for the test server
        at this point, unless we implement a proper cookie policy.

        :returns: Dictionary containing a cookie header if required,
         otherwise an empty dictionary.
        """
        parsed_url = urlparse(self._response.request.url)
        host = parsed_url.hostname.strip('.')
        if host == 'localhost':
            return {'cookie': self._response.headers.get('set-cookie', '')}
        return {}

    def _poll(self, update_cmd):
        """Poll status of operation so long as operation is incomplete and
        we have an endpoint to query.

        :param callable update_cmd: The function to call to retrieve the
         latest status of the long running operation.
        :raises: OperationFinished if operation status 'Succeeded'.
        :raises: OperationFailed if operation status 'Failed' or 'Cancelled'.
        :raises: BadStatus if response status invalid.
        :raises: BadResponse if response invalid.
        """
        initial_url = self._response.request.url

        while not finished(self._operation.status):
            self._delay()
            url = self._response.request.url
            headers = self._polling_cookie()
            self._operation.get_retry(self._response, initial_url)

            if self._operation.async_url:
                self._response = update_cmd(
                    self._operation.async_url, headers)
                self._operation.get_status_from_async(
                    self._response)
            elif self._operation.location_url:
                self._response = update_cmd(
                    self._operation.location_url, headers)
                self._operation.get_status_from_location(
                    self._response)
            else:
                self._response = update_cmd(url, headers)
                self._operation.get_status_from_resource(
                    self._response)

        if failed(self._operation.status):
            raise OperationFailed("Operation failed or cancelled")
        elif not self._operation.is_done():
            self._response = update_cmd(initial_url)
            self._operation.get_status_from_resource(
                self._response)

    def result(self, timeout=None):
        """Return the result of the long running operation, or
        the result available after the specified timeout.

        :returns: The deserialized resource of the long running operation,
         if one is available.
        """
        self.wait(timeout)
        try:
            raise self._exception
        except TypeError:
            pass
        if self._operation.raw:
            return self._operation.raw
        else:
            return self._operation.resource

    def wait(self, timeout=None):
        """Wait on the long running operation for a specified length
        of time.

        :param int timeout: Perion of time to wait for the long running
         operation to complete.
        """
        self._thread.join(timeout=timeout)

    def done(self):
        """Check status of the long running operation.

        :returns: 'True' if the process has completed, else 'False'.
        """
        return not self._thread.isAlive()

    def add_done_callback(self, func):
        """Add callback function to be run once the long running operation
        has completed - regardless of the status of the operation.

        :param callable func: Callback function that takes at least one
         argument, a completed LongRunningOperation.
        :raises: ValueError if the long running operation has already
         completed.
        """
        if self._done.is_set():
            raise ValueError("Process is complete.")
        self._callbacks.append(func)

    def remove_done_callback(self, func):
        """Remove a callback from the long running operation.

        :param callable func: The function to be removed from the callbacks.
        :raises: ValueError if the long running operation has already
         completed.
        """
        if self._done.is_set():
            raise ValueError("Process is complete.")
        self._callbacks = [c for c in self._callbacks if c != func]
