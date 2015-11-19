#--------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
# 
# Code generated by Microsoft (R) AutoRest Code Generator 0.13.0.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.
#--------------------------------------------------------------------------

import sys


from msrest.service_client import ServiceClient, async_request
from msrest.serialization import Serializer, Deserializer
from msrest.exceptions import (
    SerializationError,
    DeserializationError,
    TokenExpiredError,
    ClientRequestError,
    HttpOperationError)

from ..models import *

class parameter_grouping(object):

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
    def post_required(self, body, path, custom_header, query, custom_headers = {}, raw = False, callback = None):
        """

        Post a bunch of required parameters grouped

        :param body:
        :param path: Path parameter
        :param custom_header:
        :param query: Query parameter with default
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type body: int
        :type path: str
        :type custom_header: str or none
        :type query: int or none
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/parameterGrouping/postRequired/{path}'
        path_format_arguments = {
            'path' : self._parse_url("path", path, 'str', False)}
        url = url.format(**path_format_arguments)

        # Construct parameters
        query = {}
        if query is not None:
            query['query'] = self._parse_url("query", query, 'int', False)

        # Construct headers
        headers = {}
        if custom_header is not None:
            query['customHeader'] = custom_header
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct body
        content = self._serialize(body, 'int')

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers, content)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def post_optional(self, custom_header, query, custom_headers = {}, raw = False, callback = None):
        """

        Post a bunch of optional parameters grouped

        :param custom_header:
        :param query: Query parameter with default
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type custom_header: str or none
        :type query: int or none
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/parameterGrouping/postOptional'

        # Construct parameters
        query = {}
        if query is not None:
            query['query'] = self._parse_url("query", query, 'int', False)

        # Construct headers
        headers = {}
        if custom_header is not None:
            query['customHeader'] = custom_header
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def post_multiple_parameter_groups(self, headerone, queryone, headertwo, querytwo, custom_headers = {}, raw = False, callback = None):
        """

        Post parameters from multiple different parameter groups

        :param headerone:
        :param queryone: Query parameter with default
        :param headertwo:
        :param querytwo: Query parameter with default
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type headerone: str or none
        :type queryone: int or none
        :type headertwo: str or none
        :type querytwo: int or none
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/parameterGrouping/postMultipleParameterGroups'

        # Construct parameters
        query = {}
        if queryone is not None:
            query['query-one'] = self._parse_url("queryone", queryone, 'int', False)
        if querytwo is not None:
            query['query-two'] = self._parse_url("querytwo", querytwo, 'int', False)

        # Construct headers
        headers = {}
        if headerone is not None:
            query['header-one'] = headerone
            if headertwo is not None:
                query['header-two'] = headertwo
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def post_shared_parameter_group_object(self, headerone, queryone, custom_headers = {}, raw = False, callback = None):
        """

        Post parameters with a shared parameter group object

        :param headerone:
        :param queryone: Query parameter with default
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type headerone: str or none
        :type queryone: int or none
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/parameterGrouping/sharedParameterGroupObject'

        # Construct parameters
        query = {}
        if queryone is not None:
            query['query-one'] = self._parse_url("queryone", queryone, 'int', False)

        # Construct headers
        headers = {}
        if headerone is not None:
            query['header-one'] = headerone
        headers.update(custom_headers)
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response
