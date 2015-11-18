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


class http_client_failure(object):

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
    def head400(self, custom_headers={}, raw=False, callback=None):
        """

        Return 400 status code - should be represented in the client as an
        error

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/400'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.head(url, query)
        response = self._client.send(request, headers)

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def get400(self, custom_headers={}, raw=False, callback=None):
        """

        Return 400 status code - should be represented in the client as an
        error

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/400'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.get(url, query)
        response = self._client.send(request, headers)

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def put400(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Return 400 status code - should be represented in the client as an
        error

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
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/400'

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

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def patch400(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Return 400 status code - should be represented in the client as an
        error

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
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/400'

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

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def post400(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Return 400 status code - should be represented in the client as an
        error

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
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/400'

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

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def delete400(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Return 400 status code - should be represented in the client as an
        error

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
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/400'

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

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def head401(self, custom_headers={}, raw=False, callback=None):
        """

        Return 401 status code - should be represented in the client as an
        error

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/401'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.head(url, query)
        response = self._client.send(request, headers)

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def get402(self, custom_headers={}, raw=False, callback=None):
        """

        Return 402 status code - should be represented in the client as an
        error

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/402'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.get(url, query)
        response = self._client.send(request, headers)

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def get403(self, custom_headers={}, raw=False, callback=None):
        """

        Return 403 status code - should be represented in the client as an
        error

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/403'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.get(url, query)
        response = self._client.send(request, headers)

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def put404(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Return 404 status code - should be represented in the client as an
        error

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
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/404'

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

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def patch405(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Return 405 status code - should be represented in the client as an
        error

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
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/405'

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

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def post406(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Return 406 status code - should be represented in the client as an
        error

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
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/406'

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

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def delete407(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Return 407 status code - should be represented in the client as an
        error

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
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/407'

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

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def put409(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Return 409 status code - should be represented in the client as an
        error

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
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/409'

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

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def head410(self, custom_headers={}, raw=False, callback=None):
        """

        Return 410 status code - should be represented in the client as an
        error

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/410'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.head(url, query)
        response = self._client.send(request, headers)

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def get411(self, custom_headers={}, raw=False, callback=None):
        """

        Return 411 status code - should be represented in the client as an
        error

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/411'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.get(url, query)
        response = self._client.send(request, headers)

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def get412(self, custom_headers={}, raw=False, callback=None):
        """

        Return 412 status code - should be represented in the client as an
        error

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/412'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.get(url, query)
        response = self._client.send(request, headers)

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def put413(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Return 413 status code - should be represented in the client as an
        error

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
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/413'

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

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def patch414(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Return 414 status code - should be represented in the client as an
        error

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
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/414'

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

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def post415(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Return 415 status code - should be represented in the client as an
        error

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
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/415'

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

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def get416(self, custom_headers={}, raw=False, callback=None):
        """

        Return 416 status code - should be represented in the client as an
        error

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/416'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.get(url, query)
        response = self._client.send(request, headers)

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def delete417(self, boolean_value, custom_headers={}, raw=False, callback=None):
        """

        Return 417 status code - should be represented in the client as an
        error

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
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/417'

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

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def head429(self, custom_headers={}, raw=False, callback=None):
        """

        Return 429 status code - should be represented in the client as an
        error

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/http/failure/client/429'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.head(url, query)
        response = self._client.send(request, headers)

        if reponse.status_code < 200 or reponse.status_code >= 300:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response
