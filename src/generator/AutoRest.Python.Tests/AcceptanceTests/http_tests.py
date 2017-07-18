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

import unittest
import subprocess
import sys
import isodate
import tempfile
import requests
from requests.packages.urllib3 import HTTPConnectionPool, Retry
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.poolmanager import (
    PoolManager,
    PoolKey,
    _default_key_normalizer
)
from datetime import date, datetime, timedelta
import os
from os.path import dirname, pardir, join, realpath

cwd = dirname(realpath(__file__))
log_level = int(os.environ.get('PythonLogLevel', 30))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "Http"))

from msrest.exceptions import DeserializationError, HttpOperationError

from auto_rest_http_infrastructure_test_service import AutoRestHttpInfrastructureTestService
from auto_rest_http_infrastructure_test_service.models import (
    A, B, C, D, ErrorException)


class TestRetry(Retry):
    """Wrapper for urllib3 Retry object.
    """

    def __init__(self, **kwargs):
        self.retry_cookie = None

        return super(TestRetry, self).__init__(**kwargs)

    def increment(self, method=None, url=None, response=None,
                  error=None, _pool=None, _stacktrace=None):
        increment = super(TestRetry, self).increment(
            method, url, response, error, _pool, _stacktrace)

        if response:
            # Fixes open socket warnings in Python 3.
            response.close()
            response.release_conn()

            # Collect retry cookie - we only do this for the test server
            # at this point, unless we implement a proper cookie policy.
            increment.retry_cookie = response.getheader("Set-Cookie")
        return increment

class TestHTTPConnectionPool(HTTPConnectionPool):
    """Cookie logic only used for test server (localhost)"""

    def _add_test_cookie(self, retries, headers):
        host = self.host.strip('.')
        if retries.retry_cookie and host == 'localhost':
            if headers:
                headers['cookie'] = retries.retry_cookie
            else:
                self.headers['cookie'] = retries.retry_cookie

    def _remove_test_cookie(self, retries, headers):
        host = self.host.strip('.')
        if retries.retry_cookie and host == 'localhost':
            retries.retry_cookie = None
            if headers:
                del headers['cookie']
            else:
                del self.headers['cookie']

    def urlopen(self, method, url, body=None, headers=None,
                retries=None, *args, **kwargs):
        if hasattr(retries, 'retry_cookie'):
            self._add_test_cookie(retries, headers)

        response = super(TestHTTPConnectionPool, self).urlopen(
            method, url, body, headers, retries, *args, **kwargs)

        if hasattr(retries, 'retry_cookie'):
            self._remove_test_cookie(retries, headers)
        return response

class TestAdapter(HTTPAdapter):

    def init_poolmanager(self, connections, maxsize, block=False):
        self.poolmanager = PoolManager(
            num_pools=connections,
            maxsize=maxsize,
            block=block)
        context = {
            "scheme": "http",
            "host": "localhost",
            "port": 3000,
            "block": block,
            "maxsize": maxsize
        }
        test_hosts = [_default_key_normalizer(PoolKey, context)]
        for host in test_hosts:
            self.poolmanager.pools[host] = \
                TestHTTPConnectionPool(host[1], port=host[2])
        self.max_retries = TestRetry()
        self.max_retries.status_forcelist.add(408)
        self.max_retries.status_forcelist.add(500)
        self.max_retries.status_forcelist.add(502)
        self.max_retries.status_forcelist.add(503)
        self.max_retries.status_forcelist.add(504)
        self.max_retries.method_whitelist = {'HEAD', 'GET', 'PUT', 'DELETE', 'OPTIONS', 'TRACE', 'PATCH', 'POST'}

class TestAuthentication(object):
    def signed_session(self):
        session = requests.Session()
        session.mount('http://localhost:3000/', TestAdapter())
        return session

class HttpTests(unittest.TestCase):

    def setUp(self):
        self.client = AutoRestHttpInfrastructureTestService(base_url="http://localhost:3000")
        self.client._client.creds = TestAuthentication()
        return super(HttpTests, self).setUp()

    def assertStatus(self, code, func, *args, **kwargs):
        kwargs['raw'] = True
        raw = func(*args, **kwargs)
        self.assertEqual(raw.response.status_code, code)

    def assertRaisesWithMessage(self, msg, func, *args, **kwargs):
        try:
            func(*args, **kwargs)
            self.assertFail()

        except HttpOperationError as err:
            self.assertEqual(err.message, msg)

    def assertRaisesWithModel(self, code, model, func, *args, **kwargs):
        try:
            func(*args, **kwargs)
            self.assertFail()

        except HttpOperationError as err:
            self.assertIsInstance(err.error, model)
            self.assertEqual(err.response.status_code, code)

    def assertRaisesWithStatus(self, code, func, *args, **kwargs):
        try:
            func(*args, **kwargs)
            self.assertFail()

        except HttpOperationError as err:
            self.assertEqual(err.response.status_code, code)

    def assertRaisesWithStatusAndMessage(self, code, msg, func, *args, **kwargs):
        try:
            func(*args, **kwargs)
            self.assertFail()

        except HttpOperationError as err:
            self.assertEqual(err.message, msg)
            self.assertEqual(err.response.status_code, code)

    def assertRaisesWithStatusAndResponseContains(self, code, msg, func, *args, **kwargs):
        try:
            func(*args, **kwargs)
            self.assertFail()

        except HttpOperationError as err:
            self.assertEqual(err.response.status_code, code)
            self.assertTrue(msg in err.response.content.decode("utf-8"))

    def test_response_modeling(self):

        r = self.client.multiple_responses.get200_model204_no_model_default_error200_valid()
        self.assertEqual('200', r.status_code)

        self.assertRaisesWithStatus(201,
            self.client.multiple_responses.get200_model204_no_model_default_error201_invalid)

        self.assertRaisesWithStatus(202,
            self.client.multiple_responses.get200_model204_no_model_default_error202_none)

        self.assertIsNone(self.client.multiple_responses.get200_model204_no_model_default_error204_valid())

        self.assertRaisesWithStatusAndMessage(400, "client error",
            self.client.multiple_responses.get200_model204_no_model_default_error400_valid)

        self.assertStatus(200, self.client.multiple_responses.get200_model201_model_default_error200_valid)

        b_model = self.client.multiple_responses.get200_model201_model_default_error201_valid()
        self.assertIsNotNone(b_model)
        self.assertEqual(b_model.status_code, "201")
        self.assertEqual(b_model.text_status_code, "Created")

        self.assertRaisesWithStatusAndMessage(400, "client error",
            self.client.multiple_responses.get200_model201_model_default_error400_valid)

        a_model = self.client.multiple_responses.get200_model_a201_model_c404_model_ddefault_error200_valid()
        self.assertIsNotNone(a_model)
        self.assertEqual(a_model.status_code, "200")

        c_model = self.client.multiple_responses.get200_model_a201_model_c404_model_ddefault_error201_valid()
        self.assertIsNotNone(c_model)
        self.assertEqual(c_model.http_code, "201")

        d_model = self.client.multiple_responses.get200_model_a201_model_c404_model_ddefault_error404_valid()
        self.assertIsNotNone(d_model)
        self.assertEqual(d_model.http_status_code, "404")

        self.assertRaisesWithStatusAndMessage(400, "client error",
            self.client.multiple_responses.get200_model_a201_model_c404_model_ddefault_error400_valid)

        self.client.multiple_responses.get202_none204_none_default_error202_none()
        self.client.multiple_responses.get202_none204_none_default_error204_none()

        self.assertRaisesWithStatusAndMessage(400, "client error",
            self.client.multiple_responses.get202_none204_none_default_error400_valid)

        self.client.multiple_responses.get202_none204_none_default_none202_invalid()
        self.client.multiple_responses.get202_none204_none_default_none204_none()

        self.assertRaisesWithStatus(400,
            self.client.multiple_responses.get202_none204_none_default_none400_none)

        self.assertRaisesWithStatus(400,
            self.client.multiple_responses.get202_none204_none_default_none400_invalid)

        self.assertStatus(200, self.client.multiple_responses.get_default_model_a200_valid)

        self.assertIsNone(self.client.multiple_responses.get_default_model_a200_none())
        self.client.multiple_responses.get_default_model_a200_valid()
        self.client.multiple_responses.get_default_model_a200_none()

        self.assertRaisesWithModel(400, A,
            self.client.multiple_responses.get_default_model_a400_valid)

        self.assertRaisesWithModel(400, A,
            self.client.multiple_responses.get_default_model_a400_none)

        self.client.multiple_responses.get_default_none200_invalid()
        self.client.multiple_responses.get_default_none200_none()

        self.assertRaisesWithStatus(400,
            self.client.multiple_responses.get_default_none400_invalid)

        self.assertRaisesWithStatus(400,
            self.client.multiple_responses.get_default_none400_none)

        self.assertIsNone(self.client.multiple_responses.get200_model_a200_none())

        self.assertStatus(200, self.client.multiple_responses.get200_model_a200_valid)

        self.assertIsNone(self.client.multiple_responses.get200_model_a200_invalid().status_code)

        self.assertRaisesWithStatus(400,
            self.client.multiple_responses.get200_model_a400_none)
        self.assertRaisesWithStatus(400,
            self.client.multiple_responses.get200_model_a400_valid)
        self.assertRaisesWithStatus(400,
            self.client.multiple_responses.get200_model_a400_invalid)
        self.assertRaisesWithStatus(202,
            self.client.multiple_responses.get200_model_a202_valid)

    def test_server_error_status_codes(self):

        self.assertRaisesWithStatus(requests.codes.not_implemented,
            self.client.http_server_failure.head501)

        self.assertRaisesWithStatus(requests.codes.not_implemented,
            self.client.http_server_failure.get501)

        self.assertRaisesWithStatus(requests.codes.http_version_not_supported,
            self.client.http_server_failure.post505, True)

        self.assertRaisesWithStatus(requests.codes.http_version_not_supported,
            self.client.http_server_failure.delete505, True)

        self.client.http_retry.head408()
        self.client.http_retry.get502()

        # TODO, 4042586: Support options operations in swagger modeler
        #self.client.http_retry.options429()

        self.client.http_retry.put500(True)
        self.client.http_retry.patch500(True)
        self.client.http_retry.post503(True)
        self.client.http_retry.delete503(True)
        self.client.http_retry.put504(True)
        self.client.http_retry.patch504(True)

    def test_client_error_status_codes(self):

        self.assertRaisesWithStatus(requests.codes.bad_request,
            self.client.http_client_failure.head400)

        self.assertRaisesWithStatus(requests.codes.bad_request,
            self.client.http_client_failure.get400)

        # TODO, 4042586: Support options operations in swagger modeler
        #self.assertRaisesWithStatus(requests.codes.bad_request,
        #    self.client.http_client_failure.options400)

        self.assertRaisesWithStatus(requests.codes.bad_request,
            self.client.http_client_failure.put400, True)

        self.assertRaisesWithStatus(requests.codes.bad_request,
            self.client.http_client_failure.patch400, True)

        self.assertRaisesWithStatus(requests.codes.bad_request,
            self.client.http_client_failure.post400, True)

        self.assertRaisesWithStatus(requests.codes.bad_request,
            self.client.http_client_failure.delete400, True)

        self.assertRaisesWithStatus(requests.codes.unauthorized,
            self.client.http_client_failure.head401)

        self.assertRaisesWithStatus(requests.codes.payment_required,
            self.client.http_client_failure.get402)

        # TODO, 4042586: Support options operations in swagger modeler
        #self.assertRaisesWithStatus(requests.codes.forbidden,
        #    self.client.http_client_failure.options403)

        self.assertRaisesWithStatus(requests.codes.forbidden,
            self.client.http_client_failure.get403)

        self.assertRaisesWithStatus(requests.codes.not_found,
            self.client.http_client_failure.put404, True)

        self.assertRaisesWithStatus(requests.codes.method_not_allowed,
            self.client.http_client_failure.patch405, True)

        self.assertRaisesWithStatus(requests.codes.not_acceptable,
            self.client.http_client_failure.post406, True)

        self.assertRaisesWithStatus(requests.codes.proxy_authentication_required,
            self.client.http_client_failure.delete407, True)

        self.assertRaisesWithStatus(requests.codes.conflict,
            self.client.http_client_failure.put409, True)

        self.assertRaisesWithStatus(requests.codes.gone,
            self.client.http_client_failure.head410)

        self.assertRaisesWithStatus(requests.codes.length_required,
            self.client.http_client_failure.get411)

        # TODO, 4042586: Support options operations in swagger modeler
        #self.assertRaisesWithStatus(requests.codes.precondition_failed,
        #    self.client.http_client_failure.options412)

        self.assertRaisesWithStatus(requests.codes.precondition_failed,
            self.client.http_client_failure.get412)

        self.assertRaisesWithStatus(requests.codes.request_entity_too_large,
            self.client.http_client_failure.put413, True)

        self.assertRaisesWithStatus(requests.codes.request_uri_too_large,
            self.client.http_client_failure.patch414, True)

        self.assertRaisesWithStatus(requests.codes.unsupported_media,
            self.client.http_client_failure.post415, True)

        self.assertRaisesWithStatus(requests.codes.requested_range_not_satisfiable,
            self.client.http_client_failure.get416)

        self.assertRaisesWithStatus(requests.codes.expectation_failed,
            self.client.http_client_failure.delete417, True)

        self.assertRaisesWithStatus(429,
            self.client.http_client_failure.head429)

    def test_redirect_status_codes(self):

        #TODO: 300 is user choice, so should we automatic redirect?
        #self.assertStatus(200, self.client.http_redirects.head300)
        #self.assertStatus(200, self.client.http_redirects.get300)
        self.assertStatus(200, self.client.http_redirects.head302)
        self.assertStatus(200, self.client.http_redirects.head301)
        self.assertStatus(200, self.client.http_redirects.get301)

        self.assertStatus(requests.codes.moved_permanently, self.client.http_redirects.put301, True)
        self.assertStatus(200, self.client.http_redirects.get302)
        self.assertStatus(requests.codes.found, self.client.http_redirects.patch302, True)

        self.assertStatus(200, self.client.http_redirects.post303, True)
        self.assertStatus(200, self.client.http_redirects.head307)
        self.assertStatus(200, self.client.http_redirects.get307)

        # TODO, 4042586: Support options operations in swagger modeler
        #self.assertStatus(200, self.client.http_redirects.options307)

        self.assertStatus(200, self.client.http_redirects.put307, True)
        self.assertStatus(200, self.client.http_redirects.post307, True)
        self.assertStatus(200, self.client.http_redirects.patch307, True)
        self.assertStatus(200, self.client.http_redirects.delete307, True)

    def test_success_status_codes(self):

        self.assertRaisesWithMessage("Operation returned an invalid status code 'Bad Request'",
            self.client.http_failure.get_empty_error)
        self.assertRaisesWithStatusAndResponseContains(requests.codes.bad_request, "NoErrorModel",
            self.client.http_failure.get_no_model_error);
        self.client.http_success.head200()
        self.assertTrue(self.client.http_success.get200())
        self.client.http_success.put200(True)
        self.client.http_success.post200(True)
        self.client.http_success.patch200(True)
        self.client.http_success.delete200(True)

        # TODO, 4042586: Support options operations in swagger modeler
        #self.assertTrue(self.client.http_success.options200())

        self.client.http_success.put201(True)
        self.client.http_success.post201(True)
        self.client.http_success.put202(True)
        self.client.http_success.post202(True)
        self.client.http_success.patch202(True)
        self.client.http_success.delete202(True)
        self.client.http_success.head204()
        self.client.http_success.put204(True)
        self.client.http_success.post204(True)
        self.client.http_success.delete204(True)
        self.client.http_success.head404()
        self.client.http_success.patch204(True)


if __name__ == '__main__':
    unittest.main()
