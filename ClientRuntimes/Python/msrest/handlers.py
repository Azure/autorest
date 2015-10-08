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

from requests.packages.urllib3 import Retry

class ClientRetryPolicy(object):

    def __init__(self):
        self.policy = Retry()
        self.policy.total = 10
        self.policy.connect = 3
        self.policy.backoff_factor = 0.8
        self.policy.BACKOFF_MAX = 90

    @property
    def max_retries(self):
        return self.policy.total

    @max_retries.setter
    def max_retries(self, value):
        self.policy.total = value

    @property
    def connect_retries(self):
        return self.policy.connect

    @max_retries.setter
    def connect_retries(self, value):
        self.policy.connect = value

class ClientProxyManager(object):
    pass

class ClientRedirectHandler(object):
    pass
