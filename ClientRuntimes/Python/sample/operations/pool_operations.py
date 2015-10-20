
import sys
from datetime import datetime

try:
    from urlparse import urljoin

except ImportError:
    from urllib.parse import urljoin

from runtime.msrest.serialization import Serialized, Deserialized
from runtime.msrest.exceptions import ResponseStatusError
from runtime.msrest.utils import *

from runtime.msrestazure.azure_handlers import Paged, Polled

from ..batch_constants import ContentTypes
from ..batch_exception import BatchStatusError

from ..models import pool_models
from ..models.pool_models import *
from ..models.pool_responses import *


class PoolManager(object):

    def __init__(self, client):

        self._client = client
        self._classes = {k:v for k,v in pool_models.__dict__.items() if isinstance(v, type)}

        self.access_condition = None
        self.max_results = None
        self.filter = None

    def __getitem__(self, name):
        response = self.get(name)
        print(response, type(response), dir(response))
        return response.pool

    def __setitem__(self, name, value):
        raise InvalidOperationError("Pool cannot be overwritten.")

    def __iter__(self):
        pools = self.list(self.max_results)
        
        for p in pools:
            yield p

    def _url(self, *extension):
        path = ['/pools']
        path += [x.strip('/') for x in extension if x]
        return '/'.join(path)

    def _parameters(self, filter=False, max=False, **params):
        params = {}
        params['api-version'] = '2015-06-01.2.0'
        params['timeout'] = '30'

        if filter and self.filter:
            params.update(self.filter.get_parameters())

        if max and self.max_results:
            params['maxresults'] = str(self.max_results)

        return params

    def _headers(self, access=True, content=None):
        headers = {}
        headers['ocp-date'] = format_datetime_header(datetime.utcnow())

        if content:
            headers['Content-Type'] = content

        if access and self.access_condition:
            headers.update(self.access_condition.get_headers())

        return headers

    def pool(self, **kwargs):
        return PoolSpec(self, manager=self._client, **kwargs)

    def add(self, pool):

        # Validate
        if not pool:
            raise ValueError("pool cannot be None")
        
        content = Serialized(pool)

        try:
            url = self._url()
            query = self._parameters()
            request = self._client.request(url, query)
            request.add_content(content)
            request.add_headers(self._headers(access=False, content=ContentTypes.json))

            response = self._client.post(request)
       
            deserialize = Deserialized(BatchPoolAddResponse, response)
            deserialized = deserialize(response.content, self._classes)

            #def get_status(status_link):
            #    request = self._client.request()
            #    request.url = status_link
            #    response = self._client.get(request)

            #    deserialize = Deserialized(BatchPoolAddResponse, response)
            #    deserialized = deserialize(response.content, self._classes)

            #polling = Polled(deserialized, get_status)
            
        except ResponseStatusError:
            raise BatchStatusError(response)

        except:
            raise #TODO: exception handling

        #return polling
        return deserialized

    def delete(self, pool_name=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        try:
            url = self._url(pool_name)
            query = self._parameters()
            request = self._client.request(url, query)

            request.add_headers(self._headers())
            response = self._client.delete(request)

            deserialize = Deserialized(BatchPoolDeleteResponse, response)
            deserialized = deserialize()
            
        except ResponseStatusError as err:
            raise BatchStatusError(response)

        except:
            raise #TODO: exception handling

        return deserialized

    def disable_auto_scale(self, pool_name=None):

        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        try:
            url = self._url(pool_name, 'disableautoscale')
            query = self._parameters()
            request = self._client.request(url, query)

            request.add_headers(self._headers())
            response = self._client.post(request)

            deserialize = Deserialized(BatchPoolDisableAutoScaleResponse, response)
            dersialized = deserialize()
           
        except ResponseStatusError as err:
            raise BatchStatusError(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def enable_auto_scale(self, auto_scale_parameters, pool_name=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not auto_scale_parameters:
            raise ValueError('parameters cannot be None.')

        content = Serialized(auto_scale_parameters)

        try:
            url = self._url(pool_name, 'enableautoscale')
            query = self._parameters()

            request = self._client.request(url, query)
            request.add_content(content)
            request.add_headers(self._headers(content=ContentTypes.json))

            response = self._client.post(request)

            deserialize = Deserialized(BatchPoolEnableAutoScaleResponse, response)
            dersialized = deserialize()
           
        except ResponseStatusError as err:
            raise BatchStatusError(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def evaluate_auto_scale(self, evaluation_parameters, pool_name=None):

        # Validate
        if (pool_name is None):
            raise ValueError('pool_name cannot be None.')
        
        if (evaluation_parameters is None):
            raise ValueError('parameters cannot be None.')

        content = Serialized(evaluation_parameters)

        try:
            url = self._url(pool_name, 'evaluateautoscale')
            query = self._parameters()

            request = self._client.request(url, query)
            request.add_content(content)
            request.add_headers(self._headers(content=ContentTypes.json))

            response = self._client.post(request)

            deserialize = Deserialized(BatchPoolEvaluateAutoScaleResponse, response)
            dersialized = deserialize()
           
        except ResponseStatusError as err:
            raise BatchStatusError(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def get(self, pool_name=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        try:
            url = self._url(pool_name)
            query = self._parameters(filter=True)
            request = self._client.request(url, query)

            request.add_headers(self._headers())
            response = self._client.get(request)

            deserialize = Deserialized(BatchPoolGetResponse, response, self._client)
            dersialized = deserialize(response.content, self._classes)
            
        except ResponseStatusError as err:
            raise BatchStatusError(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def list(self):

        try:
            url = self._url()
            query = self._parameters(filter=True, max=True)
            request = self._client.request(url, query)
            request.add_headers(self._headers())
            response = self._client.get(request)

            deserialize = Deserialized(BatchPoolListResponse, response)
            deserialized = deserialize(response.content, self._classes)

            def next_page(next_link):
                request = self._client.request()
                request.url = next_link
                request.add_headers(self._headers())
                response = self._client.get(request)

                deserialize = Deserialized(BatchPoolListResponse, response)
                dersialized = deserialize(response.content, self._classes)   
                return deserialized    

            pager = Paged(deserialized.pools, deserialized.next_link, next_page)

        except ResponseStatusError as err:
            raise BatchStatusError(response)

        except:
            raise #TODO: exception handling

        return pager

    def patch(self, patch_parameters, pool_name=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not patch_parameters:
            raise ValueError('patch_parameters cannot be None.')

        content = Serialized(patch_parameters)

        try:
            url = self._url(pool_name)
            query = self._parameters()

            request = self._client.request(url, query)
            request.add_content(content)
            request.add_headers(self._headers(content=ContentTypes.json))

            response = self._client.patch(request)

            deserialize = Deserialized(BatchPoolPatchResponse, response)
            dersialized = deserialize()

        except ResponseStatusError as err:
            raise BatchStatusError(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def resize(self, resize_parameters, pool_name=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not resize_parameters:
            raise ValueError('resize_parameters cannot be None.')

        content = Serialized(resize_parameters)

        try:
            url = self._url(pool_name, 'resize')
            query = self._parameters()

            request = self._client.request(url, query)
            request.add_content(content)
            request.add_headers(self._headers(content=ContentTypes.json))
            response = self._client.post(request)

            deserialize = Deserialized(BatchPoolResizeResponse, response)
            dersialized = deserialize()

        except ResponseStatusError as err:
            raise BatchStatusError(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def stop_resize(self, pool_name=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        try:
            url = self._url(pool_name, 'stopresize')
            query = self._parameters()
            request = self._client.request(url, query)

            request.add_headers(self._headers(content=ContentTypes.json))
            response = self._client.post(request)

            deserialize = Deserialized(BatchPoolStopResizeResponse, response)
            dersialized = deserialize()

        except ResponseStatusError as err:
            raise BatchStatusError(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def update_properties(self, update_properties, pool_name=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        if not update_properties:
            raise ValueError('update_properties cannot be None.')
                    
        content = Serialized(update_properties)

        try:
            url = self._url(pool_name, 'updateproperties')
            query = self._parameters()

            request = self._client.request(url, query)
            request.add_content(content)
            request.add_headers(self._headers(content=ContentTypes.json))
            response = self._client.post(request)

            deserialize = Deserialized(BatchPoolUpdatePropertiesResponse, response)
            dersialized = deserialize()

        except ResponseStatusError as err:
            raise BatchStatusError(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def upgrade_os(self, os_parameters, pool_name=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not os_parameters:
            raise ValueError('os_parameters cannot be None.')

        content = Serialized(os_parameters)

        try:
            url = self._url(pool_name, 'upgradeos')
            query = self._parameters()

            request = self._client.request(url, query)
            request.add_content(content)
            request.add_headers(self._headers(content=ContentTypes.json))
            response = self._client.post(request)

            deserialize = Deserialized(BatchPoolUpgradeOSResponse, response)
            dersialized = deserialize()

        except ResponseStatusError as err:
            raise BatchStatusError(response)

        except:
            raise #TODO: exception handling

        return dersialized


