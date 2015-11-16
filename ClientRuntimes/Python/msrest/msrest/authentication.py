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

import time
import requests
import requests_oauthlib as oauth
from requests.auth import HTTPBasicAuth


class Authentication(object):

    header = "Authorization"

    def signed_session(self):
        session = requests.Session()
        return session


class BasicAuthentication(Authentication):

    def __init__(self, username, passw):
        self.scheme = 'Basic'
        self.username = username
        self.password = passw

    def signed_session(self):
        session = super(BasicAuthentication, self).signed_session()
        session.auth = HTTPBasicAuth(self.username, self.password)

        return session


class TokenAuthentication(Authentication):

    def __init__(self, client_id, token):
        self.scheme = 'Bearer'
        self.id = client_id
        self.token = token

    def construct_auth(self):
        return "{0} {1}".format(self.scheme, self.token)

    def refresh_session(self):
        return self.signed_session()

    def signed_session(self):

        expiry = self.token.get('expires_at')

        if expiry:
            countdown = float(expiry) - time.time()
            self.token['expires_in'] = countdown

        session = oauth.OAuth2Session(self.id, token=self.token)

        return session
