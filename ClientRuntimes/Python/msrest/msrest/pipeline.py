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

import functools
import json
import logging

import requests
from requests.packages.urllib3 import Retry
from requests.packages.urllib3.poolmanager import pool_classes_by_scheme
from requests.packages.urllib3 import HTTPConnectionPool

from .serialization import Deserializer


class ClientHTTPAdapter(requests.adapters.HTTPAdapter):
    """HTTP Adapter to customize REST pipeline in Requests.
    Handles both request and response objects.
    """

    def __init__(self, config):
        self._log = logging.getLogger(config.log_name)
        self._client_hooks = {
            'request': ClientPipelineHook(),
            'response': ClientPipelineHook()}

        super(ClientHTTPAdapter, self).__init__()

    def event_hook(event):
        """Function decorator to wrap events with hook callbacks."""
        def event_wrapper(func):

            @functools.wraps(func)
            def execute_hook(self, *args, **kwargs):
                return self._client_hooks[event](func, self, *args, **kwargs)

            return execute_hook
        return event_wrapper

    def add_hook(self, event, callback, precall=True, overwrite=False):
        """Add an event callback to hook into the REST pipeline.

        :param str event: The event to hook. Currently supports 'request'
         and 'response'.
        :param callable callback: The function to call.
        :param bool precall: Whether the function will be called before or
         after the event.
        :param bool overwrite: Whether the function will overwrite the
         original event.
        :raises: TypeError if the callback is not a function.
        :raises: KeyError if the event is not supported.
        """
        if not callable(callback):
            raise TypeError("Callback must be callable.")

        if event not in self._client_hooks:
            raise KeyError(
                "Event: {!r} is not able to be hooked.".format(event))

        if precall:
            debug = "Adding %r callback before event: %r"
            self._log.debug(debug, callback.__name__, event)
            self._client_hooks[event].precalls.append(callback)
        else:
            debug = "Adding %r callback after event: %r"
            self._log.debug(debug, callback.__name__, event)
            self._client_hooks[event].postcalls.append(callback)

        debug = "Callback to overwrite original call: %r"
        self._log.debug(debug, overwrite)
        self._client_hooks[event].overwrite_call = overwrite

    def remove_hook(self, event, callback):
        """Remove a specified event hook from the pipeline.

        :param str event: The event to hook. Currently supports 'request'
         and 'response'.
        :param callable callback: The function to remove.
        :raises: KeyError if the event is not supported.
        """
        try:
            hook_event = self._client_hooks[event]
        except KeyError:
            raise KeyError(
                "Event: {!r} is not able to be hooked.".format(event))
        else:
            self._client_hooks[event].precalls = [
                c for c in hook_event.precalls if c != callback]
            self._client_hooks[event].postcalls = [
                c for c in hook_event.postcalls if c != callback]

    @event_hook("request")
    def send(self, request, stream=False, timeout=None, verify=True,
             cert=None, proxies=None):
        """Sends the request object."""
        return super(ClientHTTPAdapter, self).send(
            request, stream, timeout, verify, cert, proxies)

    @event_hook("response")
    def build_response(self, req, resp):
        """Builds the response object."""
        return super(ClientHTTPAdapter, self).build_response(req, resp)


class ClientPipelineHook(object):
    """Pipeline hook to wrap a specific event.

    :param bool overwrite: Whether to overwrite the original event.
    """

    def __init__(self, overwrite=False):
        self.precalls = []
        self.postcalls = []
        self.overwrite_call = overwrite

    def __call__(self, func, *args, **kwargs):
        """Execute event and any wrapping callbacks.
        The result of the event is passed into all post-event
        callbacks with a 'result' keyword arg.
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
    """Wrapper for requests.Request object."""

    def add_header(self, header, value):
        """Add a header to the single request.

        :param str header: The header name.
        :param str value: The header value.
        """
        self.headers[header] = value

    def add_headers(self, headers):
        """Add multiple headers to the single request.

        :param dict headers: A dictionary of headers.
        """
        for key, value in headers.items():
            self.add_header(key, value)

    def format_parameters(self, params):
        """Format parameters into a valid query string.
        It's assumed all parameters have already been quoted as
        valid URL strings.

        :param dict params: A dictionary of parameters.
        """
        query_params = ["{}={}".format(k, v) for k, v in params.items()]
        query = '?' + '&'.join(query_params)
        self.url = self.url + query

    def add_content(self, data):
        """Add a body to the request.

        :param data: Request body data, can be a json serializable
         object (e.g. dictionary) or a generator (e.g. file data).
        """
        if data is None and self.method == 'GET':
            return

        try:
            self.data = json.dumps(data)
            self.headers['Content-Length'] = len(self.data)
        except TypeError:
            self.data = data


class ClientRawResponse(object):
    """Wrapper for response object.
    This allows for additional data to be gathereded from the response,
    for example deserialized headers.
    It also allows the raw response object to be passed back to the user.

    :param output: Deserialized response object.
    :param response: Raw response object.
    """

    def __init__(self, output, response):
        self.response = response
        self.output = output
        self.headers = {}
        self._deserialize = Deserializer()

    def add_headers(self, header_dict):
        """Deserialize a specific header.

        :param dict header_dict: A dictionary containing the name of the
         header and the type to deserialize to.
        """
        for name, data_type in header_dict.items():
            value = self.response.headers.get(name)
            value = self._deserialize(data_type, value)
            self.headers[name] = value


class ClientRetry(Retry):
    """Wrapper for urllib3 Retry object.

    :param str log_name: Name of the client session logger.
    """

    def __init__(self, log_name=None, **kwargs):
        self.retry_cookie = None
        self._log = logging.getLogger(log_name)

        return super(ClientRetry, self).__init__(**kwargs)

    def increment(self, method=None, url=None, response=None,
                  error=None, _pool=None, _stacktrace=None):
        increment = super(ClientRetry, self).increment(
            method, url, response, error, _pool, _stacktrace)

        if response:
            # Fixes open socket warnings in Python 3.
            response.close()
            response.release_conn()

            # Collect retry cookie - we only do this for the test server
            # at this point, unless we implement a proper cookie policy.
            increment.retry_cookie = response.getheader("Set-Cookie")
        return increment

    def is_forced_retry(self, method, status_code):
        debug = "Received status: %r for method %r"
        self._log.debug(debug, status_code, method)
        output = super(ClientRetry, self).is_forced_retry(method, status_code)
        self._log.debug("Is forced retry: %r", output)
        return output


class ClientRetryPolicy(object):
    """Retry configuration settings.
    Container for retry policy object.

    :param str log_name: Name of the client session logger.
    """

    safe_codes = [i for i in range(500) if i != 408] + [501, 505]

    def __init__(self, log_name):
        self._log = logging.getLogger(log_name)
        self.policy = ClientRetry(log_name)
        self.policy.total = 3
        self.policy.connect = 3
        self.policy.read = 3
        self.policy.backoff_factor = 0.8
        self.policy.BACKOFF_MAX = 90

        retry_codes = [i for i in range(999) if i not in self.safe_codes]
        self.policy.status_forcelist = retry_codes
        self.policy.method_whitelist = ['HEAD', 'TRACE', 'GET', 'PUT',
                                        'OPTIONS', 'DELETE', 'POST', 'PATCH']

    def __call__(self):
        """Return configuration to be applied to connection."""
        debug = ("Configuring retry: max_retries=%r, "
                 "backoff_factor=%r, max_backoff=%r")
        self._log.debug(
            debug, self.retries, self.backoff_factor, self.max_backoff)
        return self.policy

    @property
    def retries(self):
        """Total number of allowed retries."""
        return self.policy.total

    @retries.setter
    def retries(self, value):
        self.policy.total = value
        self.policy.connect = value
        self.policy.read = value

    @property
    def backoff_factor(self):
        """Factor by which back-off delay is incementally increased."""
        return self.policy.backoff_factor

    @backoff_factor.setter
    def backoff_factor(self, value):
        self.policy.backoff_factor = value

    @property
    def max_backoff(self):
        """Max retry back-off delay."""
        return self.policy.BACKOFF_MAX

    @max_backoff.setter
    def max_backoff(self, value):
        self.policy.BACKOFF_MAX = value


class ClientRedirectPolicy(object):
    """Redirect configuration settings.

    :param str log_name: Name of the client session logger.
    """

    def __init__(self, log_name):
        self._log = logging.getLogger(log_name)
        self.allow = True
        self.max_redirects = 30

    def __bool__(self):
        """Whether redirects are allowed."""
        return self.allow

    def __call__(self):
        """Return configuration to be applied to connection."""
        debug = "Configuring redirects: allow=%r, max=%r"
        self._log.debug(debug, self.allow, self.max_redirects)
        return self.max_redirects

    def check_redirect(self, resp, request):
        """Whether redirect policy should be applied based on status code."""
        if resp.status_code in (301, 302) and \
                request.method not in ['GET', 'HEAD']:
            return False
        return True


class ClientProxies(object):
    """Proxy configuration settings.
    Proxies can also be configured using HTTP_PROXY and HTTPS_PROXY
    environment variables, in which case set use_env_settings to True.

    :param str log_name: Name of the client session logger.
    """

    def __init__(self, log_name):
        self._log = logging.getLogger(log_name)
        self.proxies = {}
        self.use_env_settings = True

    def __call__(self):
        """Return configuration to be applied to connection."""
        proxy_string = "\n".join(
            ["    {}: {}".format(k, v) for k, v in self.proxies.items()])

        self._log.debug("Configuring proxies: %r", proxy_string)
        debug = "Evaluate proxies against ENV settings: %r"
        self._log.debug(debug, self.use_env_settings)
        return self.proxies

    def add(self, protocol, proxy_url):
        """Add proxy.

        :param str protocol: Protocol for which proxy is to be applied. Can
         be 'http', 'https', etc. Can also include host.
        :param str proxy_url: The proxy URL. Where basic auth is required,
         use the format: http://user:password@host
        """
        self.proxies[protocol] = proxy_url


class ClientConnection(object):
    """Request connection configuration settings.

    :param str log_name: Name of the client session logger.
    """

    def __init__(self, log_name):
        self._log = logging.getLogger(log_name)
        self.timeout = 100
        self.verify = True
        self.cert = None
        self.data_block_size = 4096

    def __call__(self):
        """Return configuration to be applied to connection."""
        debug = "Configuring request: timeout=%r, verify=%r, cert=%r"
        self._log.debug(debug, self.timeout, self.verify, self.cert)
        return {'timeout': self.timeout,
                'verify': self.verify,
                'cert': self.cert}


class ClientHTTPConnectionPool(HTTPConnectionPool):
    """Cookie logic only used for test server (localhost)"""

    def urlopen(self, method, url, body=None, headers=None,
                retries=None, *args, **kwargs):
        host = self.host.strip('.')
        if retries.retry_cookie and host == 'localhost':
            if headers:
                headers['cookie'] = retries.retry_cookie
            else:
                self.headers['cookie'] = retries.retry_cookie

        response = super(ClientHTTPConnectionPool, self).urlopen(
            method, url, body, headers, retries, *args, **kwargs)

        if retries.retry_cookie and host == 'localhost':
            retries.retry_cookie = None
            if headers:
                del headers['cookie']
            else:
                del self.headers['cookie']
        return response

pool_classes_by_scheme['http'] = ClientHTTPConnectionPool
