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

from . import request
from .adapter import ClientHTTPAdapter
from .logger import log_request, log_response

class ServiceClient(object):

    def __init__(self, config, creds):
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
        self._adapter.add_hook("response", log_response)

    def add_hook(self, hook):
        self.adapter.add_hook(event, hook)

    def add_header(self, header, value):
        self._adapter.client_headers[header] = value

    def send(self, request, **kwargs):
        session = self.creds.signed_session()

        for protocol in self.config.protocols:
            self.session.mount(protocol, self._adapter)

        request.prepare()
        return self.session.send(request)

    def get(self, url):
        req = request.get(self.config)
        req.url = url
        return reg

    def put(self, url):
        req = request.put(self.config)
        req.url = url
        return reg

    def post(self, url):
        req = request.post(self.config)
        req.url = url
        return reg

    def patch(self, url):
        req = request.patch(self.config)
        req.url = url
        return reg

    def delete(self, url):
        req = request.delete(self.config)
        req.url = url
        return reg

    def merge(self, url):
        req = request.merge(self.config)
        req.url = url
        return reg