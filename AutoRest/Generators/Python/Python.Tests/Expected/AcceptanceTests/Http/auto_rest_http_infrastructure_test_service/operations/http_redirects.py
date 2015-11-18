# --------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
#
# Code generated by Microsoft (R) AutoRest Code Generator 0.13.0.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.
# --------------------------------------------------------------------------

from msrest.service_client import ServiceClient, async_request
from msrest.serialization import Serializer, Deserializer
from msrest.exceptions import (
    SerializationError,
    DeserializationError,
    TokenExpiredError,
    ClientRequestError,
    HttpOperationError)

from ..models import *


class http_redirects(object):

    def __init__(self, client, config, serializer, derserializer):

        self._client = client
        self._serialize = serializer
        self._deserialize = derserializer

        self.config = config

    def _parse_url(self, name, value, datatype):

        try:
            value = self._serialize.serialize_data(value, str(datatype))

        except ValueError:
            raise ValueError("{} must not be None.".format(name))

        except DeserializationError:
            raise TypeError("{} must be type {}.".format(name, datatype))

        else:
            return value

    @async_request
    def head300(self, custom_headers={}, raw=False, callback=None):
        """

        Return 300 status code and redirect to /http/success/200

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/http/redirect/300'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.head(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200, 300]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def get300(self, custom_headers={}, raw=False, callback=None):
        """

        Return 300 status code and redirect to /http/success/200

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: list or (list, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/http/redirect/300'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.get(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200, 300]:
            raise ErrorException(self._deserialize, response)

        deserialized = None

        if response.status_code == 300:
            deserialized = self._deserialize('[str]', response)

        if raw:
            return deserialized, response

        return deserialized

    @async_request
    def head301(self, custom_headers={}, raw=False, callback=None):
        """

        Return 301 status code and redirect to /http/success/200

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/http/redirect/301'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.head(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200, 301]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def get301(self, custom_headers={}, raw=False, callback=None):
        """

        Return 301 status code and redirect to /http/success/200

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/http/redirect/301'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.get(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200, 301]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def put301(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Put true Boolean value in request returns 301.  This request should
        not be automatically redirected, but should return the received 301
        to the caller for evaluation

        :param boolean_value: Simple boolean value true
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type boolean_value: bool or none
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/http/redirect/301'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct body
        content = self._serialize(boolean_value, 'bool')

        # Construct and send request
        request = self._client.put(url, query)
        response = self._client.send(request, headers, content)

        if response.status_code not in [301]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def head302(self, custom_headers={}, raw=False, callback=None):
        """

        Return 302 status code and redirect to /http/success/200

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/http/redirect/302'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.head(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200, 302]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def get302(self, custom_headers={}, raw=False, callback=None):
        """

        Return 302 status code and redirect to /http/success/200

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/http/redirect/302'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.get(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200, 302]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def patch302(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Patch true Boolean value in request returns 302.  This request should
        not be automatically redirected, but should return the received 302
        to the caller for evaluation

        :param boolean_value: Simple boolean value true
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type boolean_value: bool or none
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/http/redirect/302'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct body
        content = self._serialize(boolean_value, 'bool')

        # Construct and send request
        request = self._client.patch(url, query)
        response = self._client.send(request, headers, content)

        if response.status_code not in [302]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def post303(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Post true Boolean value in request returns 303.  This request should
        be automatically redirected usign a get, ultimately returning a 200
        status code

        :param boolean_value: Simple boolean value true
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type boolean_value: bool or none
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/http/redirect/303'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct body
        content = self._serialize(boolean_value, 'bool')

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers, content)

        if response.status_code not in [200, 303]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def head307(self, custom_headers={}, raw=False, callback=None):
        """

        Redirect with 307, resulting in a 200 success

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/http/redirect/307'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.head(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200, 307]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def get307(self, custom_headers={}, raw=False, callback=None):
        """

        Redirect get with 307, resulting in a 200 success

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/http/redirect/307'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.get(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200, 307]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def put307(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Put redirected with 307, resulting in a 200 after redirect

        :param boolean_value: Simple boolean value true
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type boolean_value: bool or none
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/http/redirect/307'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct body
        content = self._serialize(boolean_value, 'bool')

        # Construct and send request
        request = self._client.put(url, query)
        response = self._client.send(request, headers, content)

        if response.status_code not in [200, 307]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def patch307(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Patch redirected with 307, resulting in a 200 after redirect

        :param boolean_value: Simple boolean value true
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type boolean_value: bool or none
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/http/redirect/307'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct body
        content = self._serialize(boolean_value, 'bool')

        # Construct and send request
        request = self._client.patch(url, query)
        response = self._client.send(request, headers, content)

        if response.status_code not in [200, 307]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def post307(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Post redirected with 307, resulting in a 200 after redirect

        :param boolean_value: Simple boolean value true
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type boolean_value: bool or none
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/http/redirect/307'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct body
        content = self._serialize(boolean_value, 'bool')

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers, content)

        if response.status_code not in [200, 307]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def delete307(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Delete redirected with 307, resulting in a 200 after redirect

        :param boolean_value: Simple boolean value true
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type boolean_value: bool or none
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/http/redirect/307'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct body
        content = self._serialize(boolean_value, 'bool')

        # Construct and send request
        request = self._client.delete(url, query)
        response = self._client.send(request, headers, content)

        if response.status_code not in [200, 307]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response
