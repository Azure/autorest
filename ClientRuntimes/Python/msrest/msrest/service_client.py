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

import logging
import requests
from oauthlib import oauth2
import functools

from concurrent.futures import ThreadPoolExecutor

try:
    from urlparse import urljoin, urlparse
    from urllib import quote

except ImportError:
    from urllib.parse import urljoin, quote, urlparse

from .authentication import Authentication
from .pipeline import ClientHTTPAdapter, ClientRequest
from .logger import log_request, log_response
from .exceptions import (
    TokenExpiredError,
    ClientRequestError,
    raise_with_traceback)


def async_request(func):

    @functools.wraps(func)
    def request(self, *args, **kwargs):

        if kwargs.get('callback') and callable(kwargs['callback']):
            response = self._client.send_async(func, self, *args, **kwargs)
            response.add_done_callback(kwargs['callback'])
            return response

        return func(self, *args, **kwargs)

    return request


class ServiceClient(object):

    def __init__(self, creds, config):
        """
        Create service client.

        :Args:
            - config (`.Configuration`): Service configuration.
            - creds (`.Authentication`): Authenticated credentials.

        """
        self.config = config
        self.creds = creds if creds else Authentication()

        self._log = logging.getLogger(config.log_name)

        self._adapter = ClientHTTPAdapter(config)
        self._protocols = ['http://', 'https://']
        self._headers = {}

        self._adapter.add_hook("request", log_request)
        self._adapter.add_hook("response", log_response, precall=False)

    def _format_url(self, url, skip_quote):

        parsed = urlparse(url)

        if not parsed.scheme or not parsed.netloc:
            if not skip_quote:
                url = quote(url)

            url = url.lstrip('/')
            url = urljoin(self.config.base_url, url)
            return url

        else:
            return url

    def _request(self, url, params, skip_quote):
        request = ClientRequest()

        if url:
            request.url = self._format_url(url, skip_quote)

        if params:
            request.params = params

        return request

    def _configure_session(self, session):
        """
        Apply configuration to session.
        """
        session.headers.update(self._headers)

        session.max_redirects = self.config.redirect_policy()
        session.proxies = self.config.proxies()
        session.trust_env = self.config.proxies.use_env_settings

        self._adapter.max_retries = self.config.retry_policy()

        for protocol in self._protocols:
            session.mount(protocol, self._adapter)

    def send_async(self, request_cmd, *args, **kwargs):
        """
        Prepare and send request object asynchronously.
        """
        with ThreadPoolExecutor(max_workers=1) as executor:
            future = executor.submit(request_cmd, *args, **kwargs)
            return future

    def send(self, request, headers={}, content=None, **kwargs):
        """
        Prepare and send request object according to configuration.
        """
        session = self.creds.signed_session()
        self._configure_session(session)

        kwargs.update(self.config.connection())

        request.add_headers(headers)
        #if content is not None:
        request.add_content(content, **kwargs)
   

        try:

            try:
                response = session.request(
                    request.method, request.url, data=request.data,
                    headers=request.headers, params=request.params,
                    allow_redirects=bool(self.config.redirect_policy),
                    **kwargs)

                response.raise_for_status()
                return response

            except (oauth2.rfc6749.errors.InvalidGrantError,
                    oauth2.rfc6749.errors.TokenExpiredError) as err:

                self._log.warning(
                    "Token expired or is invalid. Attempting to refresh.")

            try:
                session = self.creds.refresh_session()
                self._configure_session(session)

                response = session.request(
                    request.method, request.url, request.data,
                    request.headers, params=request.params,
                    allow_redirects=bool(self.config.redirect_policy),
                    **kwargs)

                response.raise_for_status()
                return response

            except (oauth2.rfc6749.errors.InvalidGrantError,
                    oauth2.rfc6749.errors.TokenExpiredError) as err:

                msg = "Token expired or is invalid."
                raise_with_traceback(TokenExpiredError, msg, err)

        except (requests.RequestException,
                oauth2.rfc6749.errors.OAuth2Error) as err:

            msg = "Error occurred in request."
            raise_with_traceback(ClientRequestError, msg, err)

    def add_hook(self, event, hook, precall=True, overwrite=False):
        """
        Add event callback.

        :Args:
            - event (str): The pipeline event to hook. Currently supports
              'request' and 'response'.
            - hook (func): The callback function.
        """
        self._adapter.add_hook(event, hook, precall, overwrite)

    def remove_hook(self, event, hook):
        """
        Remove event callback.

        :Args:
            - event (str): The pipeline event to hook. Currently supports
              'request' and 'response'.
            - hook (func): The callback function.
        """
        self._adapter.remove_hook(event, hook)

    def add_header(self, header, value):
        """
        Add a persistent header - this header will be applied to all
        requests sent during the current client session.

        :Args:
            - header (str): The header name.
            - value (str): The header value.
        """
        self._headers[header] = value

    def get(self, url=None, params={}, skip_quote=False):
        """
        Create a GET request object.
        """
        request = self._request(url, params, skip_quote)
        request.method = 'GET'
        return request

    def put(self, url=None, params={}, skip_quote=False):
        """
        Create a PUT request object.
        """
        request = self._request(url, params, skip_quote)
        request.method = 'PUT'
        return request

    def post(self, url=None, params={}, skip_quote=False):
        """
        Create a POST request object.
        """
        request = self._request(url, params, skip_quote)
        request.method = 'POST'
        return request

    def head(self, url=None, params={}, skip_quote=False):
        """
        Create a HEAD request object.
        """
        request = self._request(url, params, skip_quote)
        request.method = 'HEAD'
        return request

    def patch(self, url=None, params={}, skip_quote=False):
        """
        Create a PATCH request object.
        """
        request = self._request(url, params, skip_quote)
        request.method = 'PATCH'
        return request

    def delete(self, url=None, params={}, skip_quote=False):
        """
        Create a DELETE request object.
        """
        request = self._request(url, params, skip_quote)
        request.method = 'DELETE'
        return request

    def merge(self, url=None, params={}, skip_quote=False):
        """
        Create a MERGE request object.
        """
        request = self._request(url, params, skip_quote)
        request.method = 'MERGE'
        return request
