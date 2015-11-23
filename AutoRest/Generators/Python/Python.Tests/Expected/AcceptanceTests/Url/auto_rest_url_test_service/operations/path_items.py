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

from msrest.serialization import Serializer, Deserializer
from msrest.service_client import async_request
from msrest.exceptions import DeserializationError, HttpOperationError

from ..models import *


class path_items(object):

    def __init__(self, client, config, serializer, derserializer):

        self._client = client
        self._serialize = serializer
        self._deserialize = derserializer

        self.config = config

    @async_request
    def get_all_with_values(self, local_string_path, path_item_string_path, local_string_query=None, path_item_string_query=None, custom_headers={}, raw=False, callback=None):
        """

        send globalStringPath='globalStringPath',
        pathItemStringPath='pathItemStringPath',
        localStringPath='localStringPath',
        globalStringQuery='globalStringQuery',
        pathItemStringQuery='pathItemStringQuery',
        localStringQuery='localStringQuery'

        :param local_string_path: should contain value 'localStringPath'
        :param path_item_string_path: A string value 'pathItemStringPath' that
        appears in the path
        :param local_string_query: should contain value 'localStringQuery'
        :param path_item_string_query: A string value 'pathItemStringQuery'
        that appears as a query parameter
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type local_string_path: str
        :type path_item_string_path: str
        :type local_string_query: str or none
        :type path_item_string_query: str or none
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/globalStringQuery/pathItemStringQuery/localStringQuery'
        path_format_arguments = {
            'localStringPath': self._serialize.url("local_string_path", local_string_path, 'str'),
            'pathItemStringPath': self._serialize.url("path_item_string_path", path_item_string_path, 'str'),
            'globalStringPath': self._serialize.url("self.config.global_string_path", self.config.global_string_path, 'str')
        }
        url = url.format(**path_format_arguments)

        # Construct parameters
        query_parameters = {}
        if local_string_query is not None:
            query_parameters['localStringQuery'] = self._serialize.query("local_string_query", local_string_query, 'str')
        if path_item_string_query is not None:
            query_parameters['pathItemStringQuery'] = self._serialize.query("path_item_string_query", path_item_string_query, 'str')
        if self.config.global_string_query is not None:
            query_parameters['globalStringQuery'] = self._serialize.query("self.config.global_string_query", self.config.global_string_query, 'str')

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct and send request
        request = self._client.get(url, query_parameters)
        response = self._client.send(request, header_parameters)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def get_global_query_null(self, local_string_path, path_item_string_path, local_string_query=None, path_item_string_query=None, custom_headers={}, raw=False, callback=None):
        """

        send globalStringPath='globalStringPath',
        pathItemStringPath='pathItemStringPath',
        localStringPath='localStringPath', globalStringQuery=null,
        pathItemStringQuery='pathItemStringQuery',
        localStringQuery='localStringQuery'

        :param local_string_path: should contain value 'localStringPath'
        :param path_item_string_path: A string value 'pathItemStringPath' that
        appears in the path
        :param local_string_query: should contain value 'localStringQuery'
        :param path_item_string_query: A string value 'pathItemStringQuery'
        that appears as a query parameter
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type local_string_path: str
        :type path_item_string_path: str
        :type local_string_query: str or none
        :type path_item_string_query: str or none
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/null/pathItemStringQuery/localStringQuery'
        path_format_arguments = {
            'localStringPath': self._serialize.url("local_string_path", local_string_path, 'str'),
            'pathItemStringPath': self._serialize.url("path_item_string_path", path_item_string_path, 'str'),
            'globalStringPath': self._serialize.url("self.config.global_string_path", self.config.global_string_path, 'str')
        }
        url = url.format(**path_format_arguments)

        # Construct parameters
        query_parameters = {}
        if local_string_query is not None:
            query_parameters['localStringQuery'] = self._serialize.query("local_string_query", local_string_query, 'str')
        if path_item_string_query is not None:
            query_parameters['pathItemStringQuery'] = self._serialize.query("path_item_string_query", path_item_string_query, 'str')
        if self.config.global_string_query is not None:
            query_parameters['globalStringQuery'] = self._serialize.query("self.config.global_string_query", self.config.global_string_query, 'str')

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct and send request
        request = self._client.get(url, query_parameters)
        response = self._client.send(request, header_parameters)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def get_global_and_local_query_null(self, local_string_path, path_item_string_path, local_string_query=None, path_item_string_query=None, custom_headers={}, raw=False, callback=None):
        """

        send globalStringPath=globalStringPath,
        pathItemStringPath='pathItemStringPath',
        localStringPath='localStringPath', globalStringQuery=null,
        pathItemStringQuery='pathItemStringQuery', localStringQuery=null

        :param local_string_path: should contain value 'localStringPath'
        :param path_item_string_path: A string value 'pathItemStringPath' that
        appears in the path
        :param local_string_query: should contain null value
        :param path_item_string_query: A string value 'pathItemStringQuery'
        that appears as a query parameter
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type local_string_path: str
        :type path_item_string_path: str
        :type local_string_query: str or none
        :type path_item_string_query: str or none
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/null/pathItemStringQuery/null'
        path_format_arguments = {
            'localStringPath': self._serialize.url("local_string_path", local_string_path, 'str'),
            'pathItemStringPath': self._serialize.url("path_item_string_path", path_item_string_path, 'str'),
            'globalStringPath': self._serialize.url("self.config.global_string_path", self.config.global_string_path, 'str')
        }
        url = url.format(**path_format_arguments)

        # Construct parameters
        query_parameters = {}
        if local_string_query is not None:
            query_parameters['localStringQuery'] = self._serialize.query("local_string_query", local_string_query, 'str')
        if path_item_string_query is not None:
            query_parameters['pathItemStringQuery'] = self._serialize.query("path_item_string_query", path_item_string_query, 'str')
        if self.config.global_string_query is not None:
            query_parameters['globalStringQuery'] = self._serialize.query("self.config.global_string_query", self.config.global_string_query, 'str')

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct and send request
        request = self._client.get(url, query_parameters)
        response = self._client.send(request, header_parameters)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response

    @async_request
    def get_local_path_item_query_null(self, local_string_path, path_item_string_path, local_string_query=None, path_item_string_query=None, custom_headers={}, raw=False, callback=None):
        """

        send globalStringPath='globalStringPath',
        pathItemStringPath='pathItemStringPath',
        localStringPath='localStringPath',
        globalStringQuery='globalStringQuery', pathItemStringQuery=null,
        localStringQuery=null

        :param local_string_path: should contain value 'localStringPath'
        :param path_item_string_path: A string value 'pathItemStringPath' that
        appears in the path
        :param local_string_query: should contain value null
        :param path_item_string_query: should contain value null
        :param custom_headers: headers that will be added to the request
        :param raw: returns the direct response alongside the deserialized
        response
        :param callback: if provided, the call will run asynchronously and
        call the callback when complete.  When specified the function returns
        a concurrent.futures.Future
        :type local_string_path: str
        :type path_item_string_path: str
        :type local_string_query: str or none
        :type path_item_string_query: str or none
        :type custom_headers: dict
        :type raw: boolean
        :type callback: Callable[[concurrent.futures.Future], None] or None
        :rtype: None or (None, requests.response) or concurrent.futures.Future
        """

        # Construct URL
        url = '/pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/globalStringQuery/null/null'
        path_format_arguments = {
            'localStringPath': self._serialize.url("local_string_path", local_string_path, 'str'),
            'pathItemStringPath': self._serialize.url("path_item_string_path", path_item_string_path, 'str'),
            'globalStringPath': self._serialize.url("self.config.global_string_path", self.config.global_string_path, 'str')
        }
        url = url.format(**path_format_arguments)

        # Construct parameters
        query_parameters = {}
        if local_string_query is not None:
            query_parameters['localStringQuery'] = self._serialize.query("local_string_query", local_string_query, 'str')
        if path_item_string_query is not None:
            query_parameters['pathItemStringQuery'] = self._serialize.query("path_item_string_query", path_item_string_query, 'str')
        if self.config.global_string_query is not None:
            query_parameters['globalStringQuery'] = self._serialize.query("self.config.global_string_query", self.config.global_string_query, 'str')

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct and send request
        request = self._client.get(url, query_parameters)
        response = self._client.send(request, header_parameters)

        if response.status_code not in [200]:
            raise ErrorException(self._deserialize, response)

        if raw:
            return None, response
