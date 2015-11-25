# coding=utf-8
# --------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
#
# Code generated by Microsoft (R) AutoRest Code Generator 0.13.0.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.
# --------------------------------------------------------------------------

from msrest.service_client import ServiceClient
from msrest import Configuration, Serializer, Deserializer
from msrest.service_client import async_request
from msrest.exceptions import DeserializationError, HttpOperationError
from . import models
from .models import *


class AutoRestValidationTestConfiguration(Configuration):

    def __init__(
            self, subscription_id, api_version, base_url=None, filepath=None):

        if subscription_id is None:
            raise ValueError('subscription_id must not be None.')
        if api_version is None:
            raise ValueError('api_version must not be None.')
        if not base_url:
            base_url = 'http://localhost'

        super(AutoRestValidationTestConfiguration, self).__init__(base_url, filepath)

        self.subscription_id = subscription_id
        self.api_version = api_version


class AutoRestValidationTest(object):

    def __init__(self, config):

        self._client = ServiceClient(None, config)

        client_models = {k: v for k, v in models.__dict__.items() if isinstance(v, type)}
        self._serialize = Serializer()
        self._deserialize = Deserializer(client_models)

        self.config = config

    @async_request
    def validation_of_method_parameters(
            self, resource_group_name, id, custom_headers={}, raw=False, callback=None, **operation_config):
        """

        Validates input parameters on the method. See swagger for details.

        :param resource_group_name: Required string between 3 and 10 chars
        with pattern [a-zA-Z0-9]+.
        :param id: Required int multiple of 10 from 100 to 1000.
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type resource_group_name: str
        :type id: int
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/fakepath/{subscriptionId}/{resourceGroupName}/{id}?api-version={apiVersion}'
        path_format_arguments = {
            'subscriptionId': self._serialize.url("self.config.subscription_id", self.config.subscription_id, 'str'),
            'resourceGroupName': self._serialize.url("resource_group_name", resource_group_name, 'str'),
            'id': self._serialize.url("id", id, 'int')
        }
        url = url.format(**path_format_arguments)

        # Construct parameters
        query_parameters = {}
        query_parameters['apiVersion'] = self._serialize.query("self.config.api_version", self.config.api_version, 'str')

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct and send request
        request = self._client.get(url, query_parameters)
        response = self._client.send(request, header_parameters, **operation_config)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        deserialized = None

        if response.status_code == 200:
            deserialized = self._deserialize('Product', response)

        if raw:
            return deserialized, response

        return deserialized

    @async_request
    def validation_of_body(
            self, resource_group_name, id, body=None, custom_headers={}, raw=False, callback=None, **operation_config):
        """

        Validates body parameters on the method. See swagger for details.

        :param resource_group_name: Required string between 3 and 10 chars
        with pattern [a-zA-Z0-9]+.
        :param id: Required int multiple of 10 from 100 to 1000.
        :param body:
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type resource_group_name: str
        :type id: int
        :type body: object or none
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: object or (object, requests.response) or
        concurrent.futures.Future
        """

        # Construct URL
        url = '/fakepath/{subscriptionId}/{resourceGroupName}/{id}?api-version={apiVersion}'
        path_format_arguments = {
            'subscriptionId': self._serialize.url("self.config.subscription_id", self.config.subscription_id, 'str'),
            'resourceGroupName': self._serialize.url("resource_group_name", resource_group_name, 'str'),
            'id': self._serialize.url("id", id, 'int')
        }
        url = url.format(**path_format_arguments)

        # Construct parameters
        query_parameters = {}
        query_parameters['apiVersion'] = self._serialize.query("self.config.api_version", self.config.api_version, 'str')

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct body
        if body is not None:
            body_content = self._serialize.body(body, 'Product')
        else:
            body_content = None

        # Construct and send request
        request = self._client.put(url, query_parameters)
        response = self._client.send(
            request, header_parameters, body_content, **operation_config)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        deserialized = None

        if response.status_code == 200:
            deserialized = self._deserialize('Product', response)

        if raw:
            return deserialized, response

        return deserialized
