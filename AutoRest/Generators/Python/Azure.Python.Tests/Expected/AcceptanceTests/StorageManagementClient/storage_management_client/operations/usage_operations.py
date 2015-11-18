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


class usageOperations(object):

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
    def list(self, custom_headers={}, raw=False, callback=None):
        """

        Gets the current usage count and the limit for the resources under the
        subscription.

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
        url = '/subscriptions/{subscriptionId}/providers/Microsoft.Storage/usages'
        path_format_arguments = {
            'subscriptionId': self._parse_url("self.config.subscription_id", self.config.subscription_id, 'str', False)}
        url = url.format(**path_format_arguments)

        # Construct parameters
        query = {}
        if self.config.apiversion is not None:
            query['api-version'] = self._parse_url("self.config.apiversion", self.config.apiversion, 'str', False)

        # Construct headers
        headers = {}
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.get(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200]:
            raise HttpOperationException(self._deserialize, response)

        deserialized = None

        if response.status_code == 200:
            deserialized = self._deserialize('UsageListResult', response)

        if raw:
            return deserialized, response

        return deserialized
