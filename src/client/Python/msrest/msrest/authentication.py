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

import requests
from requests.auth import HTTPBasicAuth
import requests_oauthlib as oauth


class Authentication(object):
    """Default, simple auth object.
    Doesn't actually add any auth headers.
    """

    header = "Authorization"

    def signed_session(self):
        """Create requests session with any required auth headers
        applied.

        :rtype: requests.Session.
        """
        return requests.Session()


class BasicAuthentication(Authentication):
    """Implmentation of Basic Authentication.

    :param str username: Authentication username.
    :param str password: Authentication password.
    """

    def __init__(self, username, password):
        self.scheme = 'Basic'
        self.username = username
        self.password = password

    def signed_session(self):
        """Create requests session with any required auth headers
        applied.

        :rtype: requests.Session.
        """
        session = super(BasicAuthentication, self).signed_session()
        session.auth = HTTPBasicAuth(self.username, self.password)
        return session


class BasicTokenAuthentication(Authentication):
    """Simple Token Authentication.
    Does not adhere to OAuth, simply adds provided token as a header.

    :param dict token: Authentication token, must have 'access_token' key.
    """

    def __init__(self, token):
        self.scheme = 'Bearer'
        self.token = token

    def signed_session(self):
        """Create requests session with any required auth headers
        applied.

        :rtype: requests.Session.
        """
        session = super(BasicTokenAuthentication, self).signed_session()
        header = "{} {}".format(self.scheme, self.token['access_token'])
        session.headers['Authorization'] = header
        return session


class OAuthTokenAuthentication(Authentication):
    """OAuth Token Authentication.
    Requires that supplied token contains an expires_in field.

    :param str client_id: Account Client ID.
    :param dict token: OAuth2 token.
    """

    def __init__(self, client_id, token):
        self.scheme = 'Bearer'
        self.id = client_id
        self.token = token
        self.store_key = self.id

    def construct_auth(self):
        """Format token header.

        :rtype: str.
        """
        return "{} {}".format(self.scheme, self.token)

    def refresh_session(self):
        """Return updated session if token has expired, attempts to
        refresh using refresh token.

        :rtype: requests.Session.
        """
        return self.signed_session()

    def signed_session(self):
        """Create requests session with any required auth headers
        applied.

        :rtype: requests.Session.
        """
        return oauth.OAuth2Session(self.id, token=self.token)
