
import sys
from datetime import datetime

try:
    from urlparse import urljoin

except ImportError:
    from urllib.parse import urljoin

from runtime.msrest.serialization import Serializer, Deserializer
from runtime.msrest.paging import Paged
from runtime.msrest.exceptions import (
    SerializationError,
    DeserializationError,
    TokenExpiredError,
    ClientRequestError)

from runtime.msrestazure.azure_operation import AzureOperationPoller

from ..batch_exception import BatchStatusError

from .. import models
from ..models import *


class PoolManager(object):

    def __init__(self, client, config):

        self._client = client
        self._config = config
        self._classes = {k:v for k,v in models.__dict__.items() if isinstance(v, type)}

        self.serializer = Serializer()
        self.deserializer = Deserializer(self._classes)

    def _url(self, *extension):
        path = [x.strip('/') for x in extension if x]
        return '/' + '/'.join(path)

    def _send(self, request, accept_status, headers, content=None):

        try:
            request.add_headers(headers)
            if content:
                request.add_content(content)

            response =  self._client.send(request)

            if response.status_code not in accept_status:
       
                deserialized = self.deserializer(BatchStatusError, response, self._classes)
                raise deserialized

            return response

        except TokenExpiredError:
            raise # If client defines own exception, raise here

        except ClientRequestError:
            raise # If client defines own exception, raise here

    def add(self, pool_parameters, raw=False):
        """
        Add a new pool.
        """
        accept_status = [201]

        # Validate
        if not pool_parameters:
            raise ValueError("pool cannot be None")

        try:
            # Construct URL
            url = self._url('pools')

            # Construct parameters
            query = {}
            query['api-version'] = self._config.api_version
            query['timeout'] = self._config.request_timeout

            # Construct headers
            headers = {}
            headers['ocp-date'] = self.serializer.serialize_opc_date(datetime.utcnow())
            headers['Content-Type'] = 'application/json;odata=minimalmetadata'

            # Construct body
            content = self.serializer(pool_parameters)

            # Construct and send request
            request = self._client.post(url, query)
            response = self._send(request, accept_status, headers, content)

            if raw:
                return response

            #def get_status(status_link):
            #    accept_status = [200, 201, 202, 204]
            #    request = self._client.get()
            #    request.url = status_link
            #    return self._send(request, accept_status)

            #return AzureOperationPoller(response, get_status)

        except (SerializationError, DeserializationError):
            raise #TODO: Wrap in client-specific error?


    def delete(self, pool_name=None, access=AccessCondition(), raw=False):
        """
        Delete a pool.
        """

        accept_status = [201]

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        try:
            # Construct URL
            url = self._url('pools', pool_name)

            # Construct parameters
            query = {}
            query['api-version'] = self._config.api_version
            query['timeout'] = self._config.request_timeout

            # Construct headers
            headers = {}
            headers['ocp-date'] = self.serializer.serialize_opc_date(datetime.utcnow())
            headers.update(access.get_headers())

            # Construct and send request
            request = self._client.delete(url, query)
            response = self._send(request, accept_status, headers)

            if raw:
                return response

        except (SerializationError, DeserializationError):
            raise #TODO: Wrap in client-specific error?

    def disable_auto_scale(self, pool_name=None, access=AccessCondition(), raw=False):
        """
        Disable auto-scale on a pool.
        """

        accept_status = [202]

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        try:
            # Construct URL
            url = self._url('pools', pool_name, 'disableautoscale')

            # Construct parameters
            query = {}
            query['api-version'] = self._config.api_version
            query['timeout'] = self._config.request_timeout

            # Construct headers
            headers = {}
            headers['ocp-date'] = self.serializer.serialize_opc_date(datetime.utcnow())
            headers.update(access.get_headers())

            # Construct and send request
            request = self._client.post(url, query)
            response = self._send(request, accept_status, headers)

            if raw:
                return response

        except (SerializationError, DeserializationError):
            raise #TODO: Wrap in client-specific error?

    def enable_auto_scale(self, auto_scale_parameters, pool_name=None, access=AccessCondition(), raw=False):
        """
        Enable auto-scale on a pool using given formula.
        """

        accept_status = [202]

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not auto_scale_parameters:
            raise ValueError('auto_scale_parameters cannot be None.')

        try:
            # Construct URL
            url = self._url('pools', pool_name, 'enableautoscale')

            # Construct parameters
            query = {}
            query['api-version'] = self._config.api_version
            query['timeout'] = self._config.request_timeout

            # Construct headers
            headers = {}
            headers['ocp-date'] = self.serializer.serialize_opc_date(datetime.utcnow())
            headers['Content-Type'] = 'application/json;odata=minimalmetadata'
            headers.update(access.get_headers())

            # Construct body
            content = self.serializer(auto_scale_parameters)

            # Construct and send request
            request = self._client.post(url, query)
            response = self._send(request, accept_status, headers, content)

            if raw:
                return response

        except (SerializationError, DeserializationError):
            raise #TODO: Wrap in client-specific error?

    def evaluate_auto_scale(self, evaluation_parameters, pool_name=None, access=AccessCondition(), raw=False):
        """
        Evaluate pool auto-scale formula.
        """

        accept_status = [202]

        # Validate
        if (pool_name is None):
            raise ValueError('pool_name cannot be None.')
        
        if (evaluation_parameters is None):
            raise ValueError('parameters cannot be None.')

        try:
            # Construct URL
            url = self._url('pools', pool_name, 'evaluateautoscale')

            # Construct parameters
            query = {}
            query['api-version'] = self._config.api_version
            query['timeout'] = self._config.request_timeout

            # Construct headers
            headers = {}
            headers['ocp-date'] = self.serializer.serialize_opc_date(datetime.utcnow())
            headers['Content-Type'] = 'application/json;odata=minimalmetadata'
            headers.update(access.get_headers())

            # Construct body
            content = self.serializer(evaluation_parameters)

            # Construct and send request
            request = self._client.post(url, query)
            response = self._send(request, accept_status, headers, content)

            if raw:
                return response

        except (SerializationError, DeserializationError):
            raise #TODO: Wrap in client-specific error?

    def get(self, pool_name=None, filter=DetailLevel(), access=AccessCondition(), raw=False):
        """
        Get details on a pool.
        """
        accept_status = [200]

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        try:
            # Construct URL
            url = self._url('pools', pool_name)

            # Construct parameters
            query = {}
            query['api-version'] = self._config.api_version
            query['timeout'] = self._config.request_timeout
            query.update(filter.get_parameters())

            # Construct headers
            headers = {}
            headers['ocp-date'] = self.serializer.serialize_opc_date(datetime.utcnow())
            headers.update(access.get_headers())

            # Construct and send request
            request = self._client.get(url, query)
            response = self._send(request, accept_status, headers)

            if raw:
                return response

            # Deserialize response
            return self.deserializer(Pool, response, self._classes)

        except (SerializationError, DeserializationError):
            raise #TODO: Wrap in client-specific error?

    def list(self, max_results=None, filter=DetailLevel(), access=AccessCondition(), raw=False):
        """
        List pools in account.
        """

        def paging(next=None, raw=False):

            accept_status = [200]

            try:
                if next is None:
                    # Construct URL
                    url = self._url('pools')

                    # Construct parameters
                    query = {}
                    query['api-version'] = self._config.api_version
                    query['timeout'] = self._config.request_timeout
                    query.update(filter.get_parameters())
                    if max_results:
                        query['maxresults'] = str(max_results)

                    request = self._client.get(url, query)

                else:
                    request = self._client.get()
                    request.url = next

                # Construct headers
                headers = {}
                headers['ocp-date'] = self.serializer.serialize_opc_date(datetime.utcnow())
                headers.update(access.get_headers())

                # Construct and send request
                response = self._send(request, accept_status, headers)
                    
                return response

            except (SerializationError, DeserializationError):
                raise #TODO: Wrap in client-specific error?

        response = paging()

        if raw:
            return response

        return PoolsPaged(response, paging, self._classes)

        

    def patch(self, patch_parameters, pool_name=None, access=AccessCondition(), raw=False):

        accept_status = [200]

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not patch_parameters:
            raise ValueError('patch_parameters cannot be None.')

        try:
            # Construct URL
            url = self._url('pools', pool_name)

            # Construct parameters
            query = {}
            query['api-version'] = self._config.api_version
            query['timeout'] = self._config.request_timeout

            # Construct headers
            headers = {}
            headers['ocp-date'] = self.serializer.serialize_opc_date(datetime.utcnow())
            headers['Content-Type'] = 'application/json;odata=minimalmetadata'
            headers.update(access.get_headers())

            # Construct body
            content = self.serializer(patch_parameters)

            # Construct and send request
            request = self._client.patch(url, query)
            response = self._send(request, accept_status, headers, content)

            if raw:
                return response

        except (SerializationError, DeserializationError):
            raise #TODO: Wrap in client-specific error?

    def resize(self, resize_parameters, pool_name=None, access=AccessCondition(), raw=False):

        accept_status = [202]

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not resize_parameters:
            raise ValueError('resize_parameters cannot be None.')

        try:
            # Construct URL
            url = self._url('pools', pool_name, 'resize')

            # Construct parameters
            query = {}
            query['api-version'] = self._config.api_version
            query['timeout'] = self._config.request_timeout

            # Construct headers
            headers = {}
            headers['ocp-date'] = self.serializer.serialize_opc_date(datetime.utcnow())
            headers['Content-Type'] = 'application/json;odata=minimalmetadata'
            headers.update(access.get_headers())

            # Construct body
            content = self.serializer(resize_parameters)

            # Construct and send request
            request = self._client.post(url, query)
            response = self._send(request, accept_status, headers, content)

            if raw:
                return response

        except (SerializationError, DeserializationError):
            raise #TODO: Wrap in client-specific error?

    def stop_resize(self, pool_name=None, access=AccessCondition(), raw=False):

        accept_status = [202]

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        try:
            # Construct URL
            url = self._url('pools', pool_name, 'stopresize')

            # Construct parameters
            query = {}
            query['api-version'] = self._config.api_version
            query['timeout'] = self._config.request_timeout

            # Construct headers
            headers = {}
            headers['ocp-date'] = self.serializer.serialize_opc_date(datetime.utcnow())
            headers['Content-Type'] = 'application/json;odata=minimalmetadata'
            headers.update(access.get_headers())

            # Construct and send request
            request = self._client.post(url, query)
            response = self._send(request, accept_status, headers)

            if raw:
                return response
           
        except (SerializationError, DeserializationError):
            raise #TODO: Wrap in client-specific error?

    def update_properties(self, update_properties, pool_name=None, access=AccessCondition(), raw=False):

        accept_status = [204]

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        if not update_properties:
            raise ValueError('update_properties cannot be None.')

        try:
            # Construct URL
            url = self._url('pools', pool_name, 'updateproperties')

            # Construct parameters
            query = {}
            query['api-version'] = self._config.api_version
            query['timeout'] = self._config.request_timeout

            # Construct headers
            headers = {}
            headers['ocp-date'] = self.serializer.serialize_opc_date(datetime.utcnow())
            headers['Content-Type'] = 'application/json;odata=minimalmetadata'
            headers.update(access.get_headers())

            # Construct body
            content = self.serializer(update_properties)

            # Construct and send request
            request = self._client.post(url, query)
            response = self._send(request, accept_status, headers, content)

            if raw:
                return response

        except (SerializationError, DeserializationError):
            raise #TODO: Wrap in client-specific error?

    def upgrade_os(self, os_parameters, pool_name=None, access=AccessCondition(), raw=False):

        accept_status = [202]

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not os_parameters:
            raise ValueError('os_parameters cannot be None.')

        try:
            # Construct URL
            url = self._url('pools', pool_name, 'upgradeos')

            # Construct parameters
            query = {}
            query['api-version'] = self._config.api_version
            query['timeout'] = self._config.request_timeout

            # Construct headers
            headers = {}
            headers['ocp-date'] = self.serializer.serialize_opc_date(datetime.utcnow())
            headers['Content-Type'] = 'application/json;odata=minimalmetadata'
            headers.update(access.get_headers())

            # Construct body
            content = self.serializer(os_parameters)

            # Construct and send request
            request = self._client.post(url, query)
            response = self._send(request, accept_status, headers, content)

            if raw:
                return response

        except (SerializationError, DeserializationError):
            raise #TODO: Wrap in client-specific error?



