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

"""
Define custom HTTP Adapter
"""
import requests
from .hooks import ClientPipelineHook
from .exceptions import InvalidHookError


class ClientHTTPAdapter(requests.adapters.HTTPAdapter):
    

    def __init__(self):
        
        self._client_headers = {}
        self._client_hooks = {
            'request':ClientPipelineHook(),
            'response':ClientPipelineHook()}

        super(ClientHTTPAdapter, self).__init__()

    def event_hook(event):
        def event_wrapper(func):
            def execute_hook(self, *args, **kwargs):
                return self._client_hooks[event](func, self, *args, **kwargs)
            return execute_hook
        return event_wrapper

    def retry_handler(self, config):
        pass

    def proxy_handler(self, config):
        pass

    def redirect_handler(self, config):
        pass

    def add_hook(self, event, callback, precall=True, overwrite=False):

        if not callable(callback):
            raise InvalidHookError("Callback must be callable.")

        if event not in self._client_hooks:
            raise InvalidHookError("Event: '{0}' is not able to be hooked.".format(event))

        if precall:
            self._client_hooks[event].precalls.append(callback)
        else:
            self._client_hooks[event].postcalls.append(callback)
        self._client_hooks[event].overwrite_call = overwrite

    @event_hook("response")
    def build_response(self, req, resp):
        return super(ClientHTTPAdapter, self).build_response(req, resp)

    @event_hook("request")
    def send(self, request, stream = False, timeout = None, verify = True, cert = None, proxies = None):
        return super(ClientHTTPAdapter, self).send(request, stream, timeout, verify, cert, proxies)


        