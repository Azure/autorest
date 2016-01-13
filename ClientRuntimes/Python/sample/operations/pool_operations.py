
import sys
import functools
from datetime import datetime

try:
    from urlparse import urljoin

except ImportError:
    from urllib.parse import urljoin


from msrest.paging import Paged
from msrest.exceptions import (
    SerializationError,
    DeserializationError,
    TokenExpiredError,
    ClientRequestError)

from msrestazure.azure_operation import AzureOperationPoller
from msrestazure.azure_exceptions import CloudError
from msrest.service_client import ServiceClient, async_request

from ..batch_exception import BatchStatusError
from ..models import *


class PoolManager(object):

    def __init__(self, client, config, serializer, deserializer):

        self._client = client
        self._serialize = serializer
        self._deserialize = deserializer

        self.config = config

    def _verify_response(self, response, accept_status, error):
        
        if response.status_code != accept_status:
            deserialized = self.deserialize(
                error, response, self._deserialize.dependencies)

            raise deserialized

    def _join_url(self, *extension):
        path = [x.strip('/') for x in extension if x]
        return '/' + '/'.join(path)

    @async_request
    def add(self, pool_parameters, raw=False, callback=None):
        """
        Add a new pool.
        """

        # Validate
        if not pool_parameters:
            raise ValueError("pool cannot be None")

        # Construct URL
        url = self._join_url('pools')

        # Construct parameters
        query = {}
        query['api-version'] = self.config.api_version
        query['timeout'] = self.config.request_timeout

        # Construct headers
        headers = {}
        headers['ocp-date'] = self._serialize.serialize_rfc(datetime.utcnow())
        headers['Content-Type'] = 'application/json;odata=minimalmetadata'

        # Construct body
        content = self.serializer(pool_parameters)

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers, content)

        self._verify_response(response, 201, CloudError)

        if raw:
            return None, response

        #def get_status(status_link):
        #    accept_status = [200, 201, 202, 204]
        #    request = self._client.get()
        #    request.url = status_link
        #    return self._send(request, accept_status)

        #return AzureOperationPoller(response, get_status)

    @async_request
    def delete(self, pool_name=None, access=AccessCondition(), raw=False, callback=None):
        """
        Delete a pool.
        """

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        # Construct URL
        url = self._join_url('pools', pool_name)

        # Construct parameters
        query = {}
        query['api-version'] = self.config.api_version
        query['timeout'] = self.config.request_timeout

        # Construct headers
        headers = {}
        headers['ocp-date'] =self._serialize.serialize_rfc(datetime.utcnow())
        headers.update(access.get_headers())

        # Construct and send request
        request = self._client.delete(url, query)
        response = self._client.send(request, headers)

        self._verify_response(response, 201, CloudError)

        if raw:
            return None, response

    @async_request
    def disable_auto_scale(self, pool_name=None, access=AccessCondition(), raw=False, callback=None):
        """
        Disable auto-scale on a pool.
        """

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        # Construct URL
        url = self._join_url('pools', pool_name, 'disableautoscale')

        # Construct parameters
        query = {}
        query['api-version'] = self.config.api_version
        query['timeout'] = self.config.request_timeout

        # Construct headers
        headers = {}
        headers['ocp-date'] = self._serialize.serialize_rfc(datetime.utcnow())
        headers.update(access.get_headers())

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers)

        self._verify_response(response, 202, CloudError)

        if raw:
            return None, response

    @async_request
    def enable_auto_scale(self, auto_scale_parameters, pool_name=None, access=AccessCondition(), raw=False, callback=None):
        """
        Enable auto-scale on a pool using given formula.
        """

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not auto_scale_parameters:
            raise ValueError('auto_scale_parameters cannot be None.')

        # Construct URL
        url = self._join_url('pools', pool_name, 'enableautoscale')

        # Construct parameters
        query = {}
        query['api-version'] = self.config.api_version
        query['timeout'] = self.config.request_timeout

        # Construct headers
        headers = {}
        headers['ocp-date'] = self._serialize.serialize_rfc(datetime.utcnow())
        headers['Content-Type'] = 'application/json;odata=minimalmetadata'
        headers.update(access.get_headers())

        # Construct body
        content = self._serialize(auto_scale_parameters)

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers, content)

        self._verify_response(response, 202, CloudError)

        if raw:
            return None, response

    @async_request
    def evaluate_auto_scale(self, evaluation_parameters, pool_name=None, access=AccessCondition(), raw=False, callback=None):
        """
        Evaluate pool auto-scale formula.
        """

        # Validate
        if (pool_name is None):
            raise ValueError('pool_name cannot be None.')
        
        if (evaluation_parameters is None):
            raise ValueError('parameters cannot be None.')

        # Construct URL
        url = self._join_url('pools', pool_name, 'evaluateautoscale')

        # Construct parameters
        query = {}
        query['api-version'] = self.config.api_version
        query['timeout'] = self.config.request_timeout

        # Construct headers
        headers = {}
        headers['ocp-date'] = self._serialize.serialize_rfc(datetime.utcnow())
        headers['Content-Type'] = 'application/json;odata=minimalmetadata'
        headers.update(access.get_headers())

        # Construct body
        content = self._serialize(evaluation_parameters)

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers, content)

        self._verify_response(response, 202, CloudError)

        if raw:
            return None, response

    @async_request
    def get(self, pool_name=None, filter=DetailLevel(), access=AccessCondition(), raw=False, callback=None):
        """
        Get details on a pool.
        """

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        # Construct URL
        url = self._join_url('pools', pool_name)

        # Construct parameters
        query = {}
        query['api-version'] = self.config.api_version
        query['timeout'] = self.config.request_timeout
        query.update(filter.get_parameters())

        # Construct headers
        headers = {}
        headers['ocp-date'] = self._serialize.serialize_rfc(datetime.utcnow())
        headers.update(access.get_headers())

        # Construct and send request
        request = self._client.get(url, query)
        response = self._client.send(request, headers)

        self._verify_response(response, 200, CloudError)

        # Deserialize response
        deserialized = self._deserialize(Pool, response)
            
        if raw:
            return deserialized, response

        return deserialized

    @async_request
    def list(self, max_results=None, filter=DetailLevel(), access=AccessCondition(), raw=False, callback=None):
        """
        List pools in account.
        """

        def paging(next=None, raw=False):

            if next is None:
                # Construct URL
                url = self._join_url('pools')

                # Construct parameters
                query = {}
                query['api-version'] = self.config.api_version
                query['timeout'] = self.config.request_timeout
                query.update(filter.get_parameters())
                if max_results:
                    query['maxresults'] = str(max_results)

                request = self._client.get(url, query)

            else:
                request = self._client.get()
                request.url = next

            # Construct headers
            headers = {}
            headers['ocp-date'] = self._serialize.serialize_rfc(datetime.utcnow())
            headers.update(access.get_headers())

            # Construct and send request
            response = self._client.send(request, headers)

            self._verify_response(response, 200, CloudError)
                    
            return response

        response = paging()

        # Deserialize response
        deserialized = PoolsPaged(response, paging, self._deserialize.dependencies)

        if raw:
            return deserialized, response

        return deserialized

    @async_request
    def patch(self, patch_parameters, pool_name=None, access=AccessCondition(), raw=False, callback=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not patch_parameters:
            raise ValueError('patch_parameters cannot be None.')

        # Construct URL
        url = self._join_url('pools', pool_name)

        # Construct parameters
        query = {}
        query['api-version'] = self.config.api_version
        query['timeout'] = self.config.request_timeout

        # Construct headers
        headers = {}
        headers['ocp-date'] = self._serialize.serialize_rfc(datetime.utcnow())
        headers['Content-Type'] = 'application/json;odata=minimalmetadata'
        headers.update(access.get_headers())

        # Construct body
        content = self._serialize(patch_parameters)

        # Construct and send request
        request = self._client.patch(url, query)
        response = self._client.send(request, headers, content)

        self._verify_response(response, 200, CloudError)

        if raw:
            return None, response

    @async_request
    def resize(self, resize_parameters, pool_name=None, access=AccessCondition(), raw=False, callback=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not resize_parameters:
            raise ValueError('resize_parameters cannot be None.')

        # Construct URL
        url = self._join_url('pools', pool_name, 'resize')

        # Construct parameters
        query = {}
        query['api-version'] = self.config.api_version
        query['timeout'] = self.config.request_timeout

        # Construct headers
        headers = {}
        headers['ocp-date'] = self._serialize.serialize_rfc(datetime.utcnow())
        headers['Content-Type'] = 'application/json;odata=minimalmetadata'
        headers.update(access.get_headers())

        # Construct body
        content = self._serialize(resize_parameters)

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers, content)

        self._verify_response(response, 202, CloudError)

        if raw:
            return None, response

    @async_request
    def stop_resize(self, pool_name=None, access=AccessCondition(), raw=False, callback=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        # Construct URL
        url = self._join_url('pools', pool_name, 'stopresize')

        # Construct parameters
        query = {}
        query['api-version'] = self.config.api_version
        query['timeout'] = self.config.request_timeout

        # Construct headers
        headers = {}
        headers['ocp-date'] = self._serialize.serialize_rfc(datetime.utcnow())
        headers['Content-Type'] = 'application/json;odata=minimalmetadata'
        headers.update(access.get_headers())

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers)

        self._verify_response(response, 202, CloudError)

        if raw:
            return None, response

    @async_request
    def update_properties(self, update_properties, pool_name=None, access=AccessCondition(), raw=False, callback=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        if not update_properties:
            raise ValueError('update_properties cannot be None.')

        # Construct URL
        url = self._join_url('pools', pool_name, 'updateproperties')

        # Construct parameters
        query = {}
        query['api-version'] = self.config.api_version
        query['timeout'] = self.config.request_timeout

        # Construct headers
        headers = {}
        headers['ocp-date'] = self._serialize.serialize_rfc(datetime.utcnow())
        headers['Content-Type'] = 'application/json;odata=minimalmetadata'
        headers.update(access.get_headers())

        # Construct body
        content = self._serialize(update_properties)

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers, content)

        self._verify_response(response, 204, CloudError)

        if raw:
            return None, response

    @async_request
    def upgrade_os(self, os_parameters, pool_name=None, access=AccessCondition(), raw=False, callback=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not os_parameters:
            raise ValueError('os_parameters cannot be None.')

        # Construct URL
        url = self._join_url('pools', pool_name, 'upgradeos')

        # Construct parameters
        query = {}
        query['api-version'] = self.config.api_version
        query['timeout'] = self.config.request_timeout

        # Construct headers
        headers = {}
        headers['ocp-date'] = self._serialize.serialize_rfc(datetime.utcnow())
        headers['Content-Type'] = 'application/json;odata=minimalmetadata'
        headers.update(access.get_headers())

        # Construct body
        content = self._serialize(os_parameters)

        # Construct and send request
        request = self._client.post(url, query)
        response = self._client.send(request, headers, content)

        self._verify_response(response, 202, CloudError)

        if raw:
            return None, response

    @async_request
    def stream_download(self, parameters, raw=False, callback=None):

        if not parameters:
            raise ValueError()

        url = self._join_url('pools')

        query = {}
        query['api-version'] = self.config.api_version
        query['timeout'] = self.config.request_timeout

        headers = {}
        headers['ocp-date'] = self._client.serializer.serialize_rfc(datetime.utcnow())

        request = self._client.get(url, query)
        response = self._client.send(request, headers, stream=True)

        self._verify_response(response, 200, CloudError)

        def download_gen():
            for data in response.iter_content(self.config.connection.data_block_size):
                if not data:
                    break

                yield data

        if raw:
            return download_gen(), response

        return download_gen()

    @async_request
    def stream_upload(self, file_obj, parameters, raw=False, callback=None):

        if not parameters:
            raise ValueError()

        def upload_gen(file_handle):    
            while True:
                data = file_handle.read(self.config.connection.data_block_size)

                if not data:
                    break

                if callback and callable(callback):
                    callback(None, data=data)

                yield data

        url = self._join_url('pools')

        query = {}
        query['api-version'] = self.config.api_version
        query['timeout'] = self.config.request_timeout

        headers = {}
        headers['ocp-date'] = self._client.serializer.serialize_rfc(datetime.utcnow())

        request = self._client.put(url, query)
        response = self._client.send(request, headers, upload_gen(file_obj))

        self._verify_response(response, 200, CloudError)

        return response





