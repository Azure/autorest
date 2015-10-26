
import time
import keyring
import ast
import base64
import hmac
import hashlib

from requests.auth import AuthBase
from runtime.msrest.authentication import Authentication

try:
    from urlparse import urlparse, parse_qs

except ImportError:
    from urllib.parse import urlparse, parse_qs

class SharedKeyAuth(AuthBase):

    def __init__(self, header, account_name, key):
        self._header = header
        self._account_name = account_name
        self._key = key

    def __call__(self, request):

        url = urlparse(request.url);
        uri_path = url.path;

        # method to sign
        string_to_sign = request.method + '\n'

        # get headers to sign
        headers_to_sign = [
            'content-encoding', 'content-language', 'content-length',
            'content-md5', 'content-type', 'date', 'if-modified-since',
            'if-match', 'if-none-match', 'if-unmodified-since', 'range']

        request_header_dict = dict((name.lower(), value)
                                   for name, value in request.headers.iteritems() if value)
        string_to_sign += '\n'.join(request_header_dict.get(x, '')
                                    for x in headers_to_sign) + '\n'

        # get ocp- header to sign
        ocp_headers = []
        for name, value in request.headers.iteritems():
            if 'ocp-' in name:
                ocp_headers.append((name.lower(), value))
        ocp_headers.sort()
        for name, value in ocp_headers:
            if value:
                string_to_sign += ''.join([name, ':', value, '\n'])

        # get account_name and uri path to sign
        string_to_sign += '/' + self._account_name + uri_path

        # get query string to sign if it is not table service
        query_to_sign = parse_qs(url.query)

        for name in sorted(query_to_sign.iterkeys()):
            if query_to_sign[name][0]:
                string_to_sign += '\n' + name + ':' + query_to_sign[name][0]

        # sign the request
        auth_string = 'SharedKey ' + self._account_name + ':' + \
            self._sign_string(string_to_sign)

        request.headers[self._header] = auth_string

        return request

    def _sign_string(self, string_to_sign):
        if isinstance(self._key, unicode):
            self._key = self._key.encode('utf-8')

        key = base64.b64decode(self._key)
        if isinstance(string_to_sign, unicode):
            string_to_sign = string_to_sign.encode('utf-8')

        signed_hmac_sha256 = hmac.HMAC(key, string_to_sign, hashlib.sha256)
        digest = signed_hmac_sha256.digest()

        return base64.b64encode(digest)

class SharedKeyCredentials(Authentication):

    def __init__(self, account_name, key):
        super(SharedKeyCredentials, self).__init__()
        self.auth = SharedKeyAuth(self.header, account_name, key)
    
    def signed_session(self):

        session = super(SharedKeyCredentials, self).signed_session()
        session.auth = self.auth

        return session