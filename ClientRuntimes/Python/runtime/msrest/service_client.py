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

try:
    from urlparse import urljoin
    from urllib import quote

except ImportError:
    from urllib.parse import urljoin, quote

from .request import ClientRequest
from .adapter import ClientHTTPAdapter
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

        self._adapter = ClientHTTPAdapter()
        self._adapter.retry_handler(config)

        self._adapter.add_hook("request", log_request)
        self._adapter.add_hook("response", log_response, precall=False)

    def _format_url(self, url):
       
        url = quote(url)
        url = urljoin(self.config.base_url, url)
        return url

    def _request(self, url, params):
        request = ClientRequest(self.config)

        if url:
            request.url = self._format_url(url)

        if params:
            request.params = params

        return request

    def send(self, request, **kwargs):
        session = self.creds.signed_session()
        session.proxies = self.config.proxies

        for protocol in self.config.protocols:
            session.mount(protocol, self._adapter)

        prepped = session.prepare_request(request)
        return session.send(prepped)

    def add_hook(self, hook):
        self.adapter.add_hook(event, hook)

    def add_header(self, header, value):
        self._adapter.client_headers[header] = value

    def get(self, url=None, params={}):
        request = self._request(url, params)
        request.method = 'GET'
        return request

    def put(self, url=None, params={}):
        request = self._request(url, params)
        request.method = 'PUT'
        return request

    def post(self, url=None, params={}):
        request = self._request(url, params)
        request.method = 'POST'
        return request

    def patch(self, url=None, params={}):
        request = self._request(url, params)
        request.method = 'PATCH'
        return request

    def delete(self, url=None, params={}):
        request = self._request(url, params)
        request.method = 'DELETE'
        return request

    def merge(self, url=None, params={}):
        request = self._request(url, params)
        request.method = 'MERGE'
        return request