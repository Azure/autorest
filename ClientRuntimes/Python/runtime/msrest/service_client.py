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

import logging

try:
    from urlparse import urljoin
    from urllib import quote

except ImportError:
    from urllib.parse import urljoin, quote

from .pipeline import ClientHTTPAdapter, ClientRequest
from .logger import log_request, log_response

class ServiceClient(object):

    def __init__(self, creds, config):
        """
        Create service client.

        :Args:
            - config (`.Configuration`): Service configuration.
            - creds (`.Authentication`): Authenticated credentials.

        """
        self.config = config
        self.creds = creds

        self._log = logging.getLogger(config.log_name)

        self._adapter = ClientHTTPAdapter(config)
        self._protocols = ['http://', 'https://']
        self._headers = {}

        self._adapter.add_hook("request", log_request)
        self._adapter.add_hook("response", log_response, precall=False)

    def _format_url(self, url):
       
        url = quote(url)
        url = url.lstrip('/')
        url = urljoin(self.config.base_url, url)
        return url

    def _request(self, url, params):
        request = ClientRequest()

        if url:
            request.url = self._format_url(url)

        if params:
            request.params = params

        return request

    def send(self, request, **kwargs):
        """
        Prepare and send request object according to configuration.
        """
        session = self.creds.signed_session()
        session.headers.update(self._headers)

        session.max_redirects = self.config.redirect_policy()
        session.proxies = self.config.proxies()
        session.trust_env = self.config.proxies.use_env_settings

        self._adapter.max_retries = self.config.retry_policy()

        for protocol in self._protocols:
            session.mount(protocol, self._adapter)

        prepped = session.prepare_request(request)
        kwargs.update(self.config.connection())

        return session.send(prepped, 
                            allow_redirects=bool(self.config.redirect_policy),
                            **kwargs)

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

    def get(self, url=None, params={}):
        """
        Create a GET request object.
        """
        request = self._request(url, params)
        request.method = 'GET'
        return request

    def put(self, url=None, params={}):
        """
        Create a PUT request object.
        """
        request = self._request(url, params)
        request.method = 'PUT'
        return request

    def post(self, url=None, params={}):
        """
        Create a POST request object.
        """
        request = self._request(url, params)
        request.method = 'POST'
        return request

    def head(self, url=None, params={}):
        """
        Create a HEAD request object.
        """
        request = self._request(url, params)
        request.method = 'HEAD'
        return request

    def patch(self, url=None, params={}):
        """
        Create a PATCH request object.
        """
        request = self._request(url, params)
        request.method = 'PATCH'
        return request

    def delete(self, url=None, params={}):
        """
        Create a DELETE request object.
        """
        request = self._request(url, params)
        request.method = 'DELETE'
        return request

    def merge(self, url=None, params={}):
        """
        Create a MERGE request object.
        """
        request = self._request(url, params)
        request.method = 'MERGE'
        return request