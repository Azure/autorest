# --------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
#
# Code generated by Microsoft (R) AutoRest Code Generator 0.13.0.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.
# --------------------------------------------------------------------------

import sys

from datetime import *

from msrest.service_client import ServiceClient, async_request
from msrest.serialization import Serializer, Deserializer
from msrest.exceptions import (
    SerializationError,
    DeserializationError,
    TokenExpiredError,
    ClientRequestError,
    HttpOperationError)
import uuid

from ..models import *


class durationOperations(object):

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
    def get_null(self, custom_headers={}, raw=False, callback=None):
        """

        Get null duration value

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: timedelta or (timedelta, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/duration/null'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        if self.config.acceptlanguage is not None:
            headers['accept-language'] = self.config.acceptlanguage
        headers.update(custom_headers)
        headers['x-ms-client-request-id'] = str(uuid.uuid1())
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.get(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        deserialized = None

        if response.status_code == 200:
            deserialized = self._deserialize('duration', response)

        if raw:
            return deserialized, response

        return deserialized

    @async_request
    def put_positive_duration(self, duration_body, custom_headers={}, raw=False, callback=None):
        """

        Put a positive duration value

        :param duration_body:
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type duration_body: timedelta
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/duration/positiveduration'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        if self.config.acceptlanguage is not None:
            headers['accept-language'] = self.config.acceptlanguage
        headers.update(custom_headers)
        headers['x-ms-client-request-id'] = str(uuid.uuid1())
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct body
        content = self._serialize(duration_body, 'duration')

        # Construct and send request
        request = self._client.put(url, query)
        response = self._client.send(request, headers, content)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def get_positive_duration(self, custom_headers={}, raw=False, callback=None):
        """

        Get a positive duration value

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: timedelta or (timedelta, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/duration/positiveduration'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        if self.config.acceptlanguage is not None:
            headers['accept-language'] = self.config.acceptlanguage
        headers.update(custom_headers)
        headers['x-ms-client-request-id'] = str(uuid.uuid1())
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.get(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        deserialized = None

        if response.status_code == 200:
            deserialized = self._deserialize('duration', response)

        if raw:
            return deserialized, response

        return deserialized

    @async_request
    def get_invalid(self, custom_headers={}, raw=False, callback=None):
        """

        Get an invalid duration value

        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: timedelta or (timedelta, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/duration/invalid'

        # Construct parameters
        query = {}

        # Construct headers
        headers = {}
        if self.config.acceptlanguage is not None:
            headers['accept-language'] = self.config.acceptlanguage
        headers.update(custom_headers)
        headers['x-ms-client-request-id'] = str(uuid.uuid1())
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.get(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        deserialized = None

        if response.status_code == 200:
            deserialized = self._deserialize('duration', response)

        if raw:
            return deserialized, response

        return deserialized
