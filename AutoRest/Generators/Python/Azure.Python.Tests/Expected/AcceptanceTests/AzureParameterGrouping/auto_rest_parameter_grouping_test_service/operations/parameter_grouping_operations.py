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


class parameter_groupingOperations(object):

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
    def post_required(self, parameter_groupingpost_required_parameters, custom_headers={}, raw=False, callback=None):
        """

        Post a bunch of required parameters grouped

        :param parameter_groupingpost_required_parameters: Additional
        parameters for the operation
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type parameter_groupingpost_required_parameters: object
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/parameterGrouping/postRequired/{path}'
        path_format_arguments = {
            'path': self._parse_url("path", path, 'str', False)}
        url = url.format(**path_format_arguments)

        # Construct parameters
        query = {}
        if query is not None:
            query['query'] = self._parse_url("query", query, 'int', False)

        # Construct headers
        headers = {}
        if self.config.acceptlanguage is not None:
            headers['accept-language'] = self.config.acceptlanguage
        if custom_header is not None:
            headers['customHeader'] = custom_header
        headers.update(custom_headers)
        headers['x-ms-client-request-id'] = str(uuid.uuid1())
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def post_optional(self, parameter_groupingpost_optional_parameters, custom_headers={}, raw=False, callback=None):
        """

        Post a bunch of optional parameters grouped

        :param parameter_groupingpost_optional_parameters: Additional
        parameters for the operation
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type parameter_groupingpost_optional_parameters: object or none
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
        if self.config.acceptlanguage is not None:
            headers['accept-language'] = self.config.acceptlanguage
        if custom_header is not None:
            headers['customHeader'] = custom_header
        headers.update(custom_headers)
        headers['x-ms-client-request-id'] = str(uuid.uuid1())
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def post_multiple_parameter_groups(self, firstparametergroup, parameter_groupingpost_multiple_parameter_groupssecondparametergroup, custom_headers={}, raw=False, callback=None):
        """

        Post parameters from multiple different parameter groups

        :param firstparametergroup: Additional parameters for the operation
        :param
        parameter_groupingpost_multiple_parameter_groupssecondparametergroup:
        Additional parameters for the operation
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type firstparametergroup: object or none
        :type
        parameter_groupingpost_multiple_parameter_groupssecondparametergroup:
        object or none
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
        if self.config.acceptlanguage is not None:
            headers['accept-language'] = self.config.acceptlanguage
        if headerone is not None:
            headers['header-one'] = headerone
        if headertwo is not None:
            headers['header-two'] = headertwo
        headers.update(custom_headers)
        headers['x-ms-client-request-id'] = str(uuid.uuid1())
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def post_shared_parameter_group_object(self, firstparametergroup, custom_headers={}, raw=False, callback=None):
        """

        Post parameters with a shared parameter group object

        :param firstparametergroup: Additional parameters for the operation
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type firstparametergroup: object or none
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
        if self.config.acceptlanguage is not None:
            headers['accept-language'] = self.config.acceptlanguage
        if headerone is not None:
            headers['header-one'] = headerone
        headers.update(custom_headers)
        headers['x-ms-client-request-id'] = str(uuid.uuid1())
        headers['Content-Type'] = 'application/json; charset=utf-8'

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response
