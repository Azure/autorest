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

"""
Define custom HTTP Adapter
"""
import requests
import logging
import json
import functools
import types

from .serialization import Deserializer

from requests.packages.urllib3 import Retry
from requests.packages.urllib3.poolmanager import pool_classes_by_scheme
from requests.packages.urllib3 import HTTPConnectionPool


class ClientHTTPAdapter(requests.adapters.HTTPAdapter):
    """
    HTTP Adapter to customize REST pipeline in Requests.
    """

    def __init__(self, config):

        self._log = logging.getLogger(config.log_name)
        self._client_hooks = {
            'request': ClientPipelineHook(),
            'response': ClientPipelineHook()}

        super(ClientHTTPAdapter, self).__init__()

    def event_hook(event):
        """
        Function decorator to wrap events with hook callbacks.
        """
        def event_wrapper(func):

            @functools.wraps(func)
            def execute_hook(self, *args, **kwargs):
                return self._client_hooks[event](func, self, *args, **kwargs)

            return execute_hook
        return event_wrapper

    def add_hook(self, event, callback, precall=True, overwrite=False):
        """
        Add an event callback to hook into the REST pipeline.

        :Args:
            - event (str): The event to hook. Currently supports 'request'
              and 'response'.
            - callback (func): The function to call.
            - precall (bool): Whether the function will be called before or
              after the event.
            - overwrite (bool): Whether the function will overwrite the
              original event.

        :Raises:
            - TypeError: The callback is not a function.
            - KeyError: The event is not supported.
        """

        if not callable(callback):
            raise TypeError("Callback must be callable.")

        if event not in self._client_hooks:
            raise KeyError(
                "Event: '{0}' is not able to be hooked.".format(event))

        if precall:
            self._log.debug("Adding '{0}' callback before event: "
                            "{1}".format(callback.__name__, event))
            self._client_hooks[event].precalls.append(callback)

        else:
            self._log.debug("Adding '{0}' callback after event: "
                            "{1}".format(callback.__name__, event))
            self._client_hooks[event].postcalls.append(callback)

        self._log.debug("Callback to overwrite original call: "
                        "{0}".format(overwrite))
        self._client_hooks[event].overwrite_call = overwrite

    def remove_hook(self, event, hook):

        try:
            self._client_hooks[event].precalls = [
                c for c in self._client_hooks[event].precalls if c != hook]

            self._client_hooks[event].postcalls = [
                c for c in self._client_hooks[event].postcalls if c != hook]

        except KeyError:
            raise KeyError(
                "Event: '{0}' is not able to be hooked.".format(event))

    @event_hook("request")
    def send(self, request, stream=False, timeout=None, verify=True,
             cert=None, proxies=None):
        """
        Sends the request object.
        """
        return super(ClientHTTPAdapter, self).send(
            request, stream, timeout, verify, cert, proxies)

    @event_hook("response")
    def build_response(self, req, resp):
        """
        Builds the response object.
        """
        return super(ClientHTTPAdapter, self).build_response(req, resp)


class ClientPipelineHook(object):
    """
    Pipeline hook to wrap a specific event.
    """

    def __init__(self, overwrite=False):
        self.precalls = []
        self.postcalls = []
        self.overwrite_call = overwrite

    def __call__(self, func, *args, **kwargs):
        """
        Execute event and any wrapping callbacks. The result of the event is
        passed into all post-event callbacks with a 'result' keyword arg.
        """
        result = requests.Response()

        for call in self.precalls:
            # Execute any pre-event callabcks
            call(*args, **kwargs)

        if not self.overwrite_call:
            # Execute original event
            result = func(*args, **kwargs)

        for call in self.postcalls:
            # Execute any post-event callbacks
            result = call(result=result, *args, **kwargs)

        return result


class ClientRequest(requests.Request):
    """
    Wrapper for requests' Request object.
    """

    def add_header(self, header, value):
        self.headers[header] = value

    def add_headers(self, headers):
        for key, value in headers.items():
            self.add_header(key, value)

    def format_parameters(self, params):
        query_params = []
        for key, value in params.items():
            query_params.append("{}={}".format(key, value))
        query = '?' + '&'.join(query_params)
        self.url = self.url + query

    def add_content(self, data, **kwargs):

        if isinstance(data, types.GeneratorType):
            self.data = data

        else:
            self.data = json.dumps(data)
            self.headers['Content-Length'] = len(self.data)
        return kwargs


class ClientRawResponse(object):

    def __init__(self, output, response):

        self.response = response
        self.output = output
        self.headers = {}

        self._deserialize = Deserializer()

    def add_header(self, name, data_type):

        value = self.response.headers.get(name)
        if value:
            value = self._deserialize(data_type, value)

        self.headers[name] = value


class ClientRetry(Retry):

    def __init__(self, log_name=None, **kwargs):
        self.retry_cookie = None
        self._log = logging.getLogger(log_name)

        return super(ClientRetry, self).__init__(**kwargs)

    def increment(self, method=None, url=None, response=None,
                  error=None, _pool=None, _stacktrace=None):

        increment = super(ClientRetry, self).increment(
            method, url, response, error, _pool, _stacktrace)

        # Collect retry cookie - currently only used for non-HTTPS connections
        # TODO: Look up correct cookie handling protocol

        if response:
            # Fixes open socket warnings in Python 3
            response.close()
            response.release_conn()

            response_cookie = response.getheader("Set-Cookie")
            if response_cookie:
                self._log.debug("Adding cookie to pool headers for retry: "
                                "{}".format(response_cookie))
                increment.retry_cookie = response_cookie

        return increment

    def is_forced_retry(self, method, status_code):
        self._log.debug(
            "Received status: {} for method {}".format(status_code, method))
        output = super(ClientRetry, self).is_forced_retry(method, status_code)

        self._log.debug("Is forced retry: {0}".format(output))
        return output

    def is_exhausted(self):
        return super(ClientRetry, self).is_exhausted()


class ClientRetryPolicy(object):
    """
    Wrapper for urllib Retry object.
    """

    def __init__(self, log_name):

        self._log = logging.getLogger(log_name)
        self.policy = ClientRetry(log_name)
        self.policy.total = 3
        self.policy.connect = 3
        self.policy.read = 3
        self.policy.backoff_factor = 0.8
        self.policy.BACKOFF_MAX = 90

        safe_codes = [i for i in range(500) if i != 408]
        safe_codes.append(501)
        safe_codes.append(505)

        retry_codes = [i for i in range(999) if i not in safe_codes]
        self.policy.status_forcelist = retry_codes
        self.policy.method_whitelist = ['HEAD', 'TRACE', 'GET', 'PUT',
                                        'OPTIONS', 'DELETE', 'POST', 'PATCH']

    def __call__(self):
        self._log.debug("Configuring retry: max_retries={}, backoff_factor={}"
                        "max_backoff={}".format(self.retries,
                                                self.backoff_factor,
                                                self.max_backoff))
        return self.policy

    @property
    def retries(self):
        return self.policy.total

    @retries.setter
    def retries(self, value):
        self.policy.total = value
        self.policy.connect = value
        self.policy.read = value

    @property
    def backoff_factor(self):
        return self.policy.backoff_factor

    @backoff_factor.setter
    def backoff_factor(self, value):
        self.policy.backoff_factor = value

    @property
    def max_backoff(self):
        return self.policy.BACKOFF_MAX

    @max_backoff.setter
    def max_backoff(self, value):
        self.policy.BACKOFF_MAX = value


class ClientRedirectPolicy(object):

    def __init__(self, log_name):

        self._log = logging.getLogger(log_name)
        self.allow = True
        self.max_redirects = 30

    def __bool__(self):
        return self.allow

    def __call__(self):
        self._log.debug("Configuring redirects: allow={}, max={}".format(
            self.allow, self.max_redirects))
        return self.max_redirects

    def check_redirect(self, resp, request):
        if resp.status_code == 301 and request.method not in ['GET', 'HEAD']:
            return False
        elif resp.status_code == 302 and request.method not in ['GET', 'HEAD']:
            return False
        else:
            return True


class ClientProxies(object):

    def __init__(self, log_name):

        self._log = logging.getLogger(log_name)
        self.proxies = {}
        self.use_env_settings = True

    def __call__(self):
        proxy_string = "\n".join(
            ["    "+k+": "+v for k, v in self.proxies.items()])

        self._log.debug("Configuring proxies:{}".format(proxy_string))
        self._log.debug("Evaluate proxies against ENV settings: {}".format(
            self.use_env_settings))

        return self.proxies

    def add(self, key, value):
        self.proxies[key] = value


class ClientConnection(object):

    def __init__(self, log_name):

        self._log = logging.getLogger(log_name)
        self.timeout = 100
        self.verify = True
        self.cert = None
        self.data_block_size = 4096

    def __call__(self):
        self._log.debug("Configuring request: timeout={}, verify={}, "
                        "cert={}".format(self.timeout, self.verify, self.cert))
        return {'timeout': self.timeout,
                'verify': self.verify,
                'cert': self.cert}


# This is only used against test server
class ClientHTTPConnectionPool(HTTPConnectionPool):

    def urlopen(self, method, url, body=None, headers=None,
                retries=None, *args, **kwargs):

        if retries.retry_cookie:
            if headers:
                headers['cookie'] = retries.retry_cookie
            else:
                self.headers['cookie'] = retries.retry_cookie

        response = super(ClientHTTPConnectionPool, self).urlopen(
            method, url, body, headers, retries, *args, **kwargs)

        if retries.retry_cookie:
            retries.retry_cookie = None
            if headers:
                del headers['cookie']
            else:
                del self.headers['cookie']

        return response

pool_classes_by_scheme['http'] = ClientHTTPConnectionPool
