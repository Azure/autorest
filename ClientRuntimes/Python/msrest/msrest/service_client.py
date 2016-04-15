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

import contextlib
import logging
import os
try:
    from urlparse import urljoin, urlparse
except ImportError:
    from urllib.parse import urljoin, urlparse

from oauthlib import oauth2
import requests

from .authentication import Authentication
from .pipeline import ClientHTTPAdapter, ClientRequest
from .http_logger import log_request, log_response
from .exceptions import (
    TokenExpiredError,
    ClientRequestError,
    raise_with_traceback)


_LOGGER = logging.getLogger(__name__)


class ServiceClient(object):
    """REST Service Client.
    Maintains client pipeline and handles all requests and responses.

    :param Configuration config: Service configuration.
    :param Authentication creds: Authenticated credentials.
    """

    _protocols = ['http://', 'https://']

    def __init__(self, creds, config):
        self.config = config
        self.creds = creds if creds else Authentication()

        self._adapter = ClientHTTPAdapter(config)
        self._headers = {}

        self._adapter.add_hook("request", log_request)
        self._adapter.add_hook("response", log_response, precall=False)

    def _format_data(self, data):
        """Format field data according to whether it is a stream or
        a string for a form-data request.

        :param data: The request field data.
        :type data: str or file-like object.
        """
        content = [None, data]
        if hasattr(data, 'read'):
            content.append("application/octet-stream")
            try:
                if data.name[0] != '<' and data.name[-1] != '>':
                    content[0] = os.path.basename(data.name)
            except (AttributeError, TypeError):
                pass
        return tuple(content)

    def _request(self, url, params):
        """Create ClientRequest object.

        :param str url: URL for the request.
        :param dict params: URL query parameters.
        """
        request = ClientRequest()

        if url:
            request.url = self.format_url(url)

        if params:
            request.format_parameters(params)

        return request

    def _configure_session(self, session, **config):
        """Apply configuration to session.

        :param requests.Session session: Current request session.
        :param config: Specific configuration overrides.
        """
        kwargs = self.config.connection()
        for opt in ['timeout', 'verify', 'cert']:
            kwargs[opt] = config.get(opt, kwargs[opt])
        for opt in ['cookies', 'files']:
            kwargs[opt] = config.get(opt)
        kwargs['stream'] = True
        kwargs['allow_redirects'] = config.get(
            'allow_redirects', bool(self.config.redirect_policy))

        session.headers.update(self._headers)
        session.headers['User-Agent'] = self.config.user_agent
        session.headers['Accept'] = 'application/json'
        session.max_redirects = config.get(
            'max_redirects', self.config.redirect_policy())
        session.proxies = config.get(
            'proxies', self.config.proxies())
        session.trust_env = config.get(
            'use_env_proxies', self.config.proxies.use_env_settings)
        redirect_logic = session.resolve_redirects

        def wrapped_redirect(resp, req, **kwargs):
            attempt = self.config.redirect_policy.check_redirect(resp, req)
            return redirect_logic(resp, req, **kwargs) if attempt else []

        session.resolve_redirects = wrapped_redirect
        self._adapter.max_retries = config.get(
            'retries', self.config.retry_policy())
        for protocol in self._protocols:
            session.mount(protocol, self._adapter)

        return kwargs

    def send_formdata(self, request, headers={}, content={}, **config):
        """Send data as a multipart form-data request.
        We only deal with file-like objects or strings at this point.
        The requests is not yet streamed.

        :param ClientRequest request: The request object to be sent.
        :param dict headers: Any headers to add to the request.
        :param dict content: Dictionary of the fields of the formdata.
        :param config: Any specific config overrides.
        """
        file_data = {f: self._format_data(d) for f, d in content.items()}
        try:
            del headers['Content-Type']
        except KeyError:
            pass
        return self.send(request, headers, None, files=file_data, **config)

    def send(self, request, headers=None, content=None, **config):
        """Prepare and send request object according to configuration.

        :param ClientRequest request: The request object to be sent.
        :param dict headers: Any headers to add to the request.
        :param content: Any body data to add to the request.
        :param config: Any specific config overrides
        """
        response = None
        session = self.creds.signed_session()
        kwargs = self._configure_session(session, **config)

        request.add_headers(headers if headers else {})
        if not kwargs.get('files'):
            request.add_content(content)
        try:

            try:
                response = session.request(
                    request.method, request.url,
                    data=request.data,
                    headers=request.headers,
                    **kwargs)
                return response

            except (oauth2.rfc6749.errors.InvalidGrantError,
                    oauth2.rfc6749.errors.TokenExpiredError) as err:
                error = "Token expired or is invalid. Attempting to refresh."
                _LOGGER.warning(error)

            try:
                session = self.creds.refresh_session()
                kwargs = self._configure_session(session)

                response = session.request(
                    request.method, request.url,
                    request.data,
                    request.headers,
                    **kwargs)
                return response
            except (oauth2.rfc6749.errors.InvalidGrantError,
                    oauth2.rfc6749.errors.TokenExpiredError) as err:
                msg = "Token expired or is invalid."
                raise_with_traceback(TokenExpiredError, msg, err)

        except (requests.RequestException,
                oauth2.rfc6749.errors.OAuth2Error) as err:
            msg = "Error occurred in request."
            raise_with_traceback(ClientRequestError, msg, err)
        finally:
            if not response or response._content_consumed:
                session.close()

    def stream_download(self, data, callback):
        """Generator for streaming request body data.

        :param data: A response object to be streamed.
        :param callback: Custom callback for monitoring progress.
        """
        block = self.config.connection.data_block_size
        if not data._content_consumed:
            with contextlib.closing(data) as response:
                for chunk in response.iter_content(block):
                    if not chunk:
                        break
                    if callback and callable(callback):
                        callback(chunk, response=response)
                    yield chunk
        else:
            for chunk in data.iter_content(block):
                if not chunk:
                    break
                if callback and callable(callback):
                    callback(chunk, response=data)
                yield chunk
        data.close()
        self._adapter.close()

    def stream_upload(self, data, callback):
        """Generator for streaming request body data.

        :param data: A file-like object to be streamed.
        :param callback: Custom callback for monitoring progress.
        """
        while True:
            chunk = data.read(self.config.connection.data_block_size)
            if not chunk:
                break
            if callback and callable(callback):
                callback(chunk, response=None)
            yield chunk

    def format_url(self, url, **kwargs):
        """Format request URL with the client base URL, unless the
        supplied URL is already absolute.

        :param str url: The request URL to be formatted if necessary.
        """
        url = url.format(**kwargs)
        parsed = urlparse(url)
        if not parsed.scheme or not parsed.netloc:
            url = url.lstrip('/')
            base = self.config.base_url.format(**kwargs).rstrip('/')
            url = urljoin(base + '/', url)
        return url

    def add_hook(self, event, hook, precall=True, overwrite=False):
        """
        Add event callback.

        :param str event: The pipeline event to hook. Currently supports
         'request' and 'response'.
        :param callable hook: The callback function.
        """
        self._adapter.add_hook(event, hook, precall, overwrite)

    def remove_hook(self, event, hook):
        """
        Remove event callback.

        :param str event: The pipeline event to hook. Currently supports
         'request' and 'response'.
        :param callable hook: The callback function.
        """
        self._adapter.remove_hook(event, hook)

    def add_header(self, header, value):
        """Add a persistent header - this header will be applied to all
        requests sent during the current client session.

        :param str header: The header name.
        :param str value: The header value.
        """
        self._headers[header] = value

    def get(self, url=None, params={}):
        """Create a GET request object.

        :param str url: The request URL.
        :param dict params: Request URL parameters.
        """
        request = self._request(url, params)
        request.method = 'GET'
        return request

    def put(self, url=None, params={}):
        """Create a PUT request object.

        :param str url: The request URL.
        :param dict params: Request URL parameters.
        """
        request = self._request(url, params)
        request.method = 'PUT'
        return request

    def post(self, url=None, params={}):
        """Create a POST request object.

        :param str url: The request URL.
        :param dict params: Request URL parameters.
        """
        request = self._request(url, params)
        request.method = 'POST'
        return request

    def head(self, url=None, params={}):
        """Create a HEAD request object.

        :param str url: The request URL.
        :param dict params: Request URL parameters.
        """
        request = self._request(url, params)
        request.method = 'HEAD'
        return request

    def patch(self, url=None, params={}):
        """Create a PATCH request object.

        :param str url: The request URL.
        :param dict params: Request URL parameters.
        """
        request = self._request(url, params)
        request.method = 'PATCH'
        return request

    def delete(self, url=None, params={}):
        """Create a DELETE request object.

        :param str url: The request URL.
        :param dict params: Request URL parameters.
        """
        request = self._request(url, params)
        request.method = 'DELETE'
        return request

    def merge(self, url=None, params={}):
        """Create a MERGE request object.

        :param str url: The request URL.
        :param dict params: Request URL parameters.
        """
        request = self._request(url, params)
        request.method = 'MERGE'
        return request
