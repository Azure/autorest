
import sys

from runtime.msrest.serialization import Serialized, Deserialized
from runtime.msrest.exceptions import ResponseStatusError

from pool_operations import PoolOperations

import pool_models
from pool_models import *
from pool_responses import *


class PoolManager(object):

    def __init__(self, client):

        self._ops = PoolOperations(client)
        self._classes = {k:v for k,v in pool_models.__dict__.items() if isinstance(v, type)}

        self.access_condition = None
        self.max_results = None
        self.filter = None

    def __getitem__(self, name):
        response = self.get(name)
        return response.pool

    def __setitem__(self, name, value):
        raise InvalidOperationError("Pool cannot be overwritten.")

    def __iter__(self):
        pools = self.list(self.max_results)
        
        for p in pools:
            yield p

    def pool(self, **kwargs):
        return PoolSpec(self, **kwargs)

    def add(self, pool):

        # Validate
        if not pool:
            raise ValueError("pool cannot be None")
        
        content = Serialized(pool)

        try:
            response = self._ops.add(content)
       
            deserialize = Deserialized(BatchPoolAddResponse, response)
            deserialized = deserialize(response.content, self._classes)

            def get_status(status_link):
                response = self._ops.get_status(status_link=status_link)
                deserialize = Deserialized(BatchPoolAddResponse, response)
                deserialized = deserialize(response.content, self._classes)

            polling = Polled(deserialized, get_status)
            
        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return polling

    def delete(self, pool_name=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        try:
            response = self._ops.delete(pool_name=pool_name, access_condition=self.access_condition)

            deserialize = Deserialized(BatchPoolDeleteResponse, response)
            deserialized = deserialize()
            
        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return deserialized

    def disable_auto_scale(self, pool_name=None):

        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        try:
            response = self._ops.disable_auto_scale(pool_name=pool_name, access_condition=self.access_condition)

            deserialize = Deserialized(BatchPoolDisableAutoScaleResponse, response)
            dersialized = deserialize()
           
        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def enable_auto_scale(self, parameters, pool_name=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not parameters:
            raise ValueError('parameters cannot be None.')

        content = Serialized(parameters)

        try:
            response = self._ops.enable_auto_scale(content, pool_name=pool_name, access_condition=self.access_condition)

            deserialize = Deserialized(BatchPoolEnableAutoScaleResponse, response)
            dersialized = deserialize()
           
        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def evaluate_auto_scale(self, parameters, pool_name=None):

        # Validate
        if (pool_name is None):
            raise ValueError('pool_name cannot be None.')
        
        if (parameters is None):
            raise ValueError('parameters cannot be None.')

        content = Serialized(parameters)

        try:
            response = self._ops.evaluate_auto_scale(content, pool_name=pool_name)

            deserialize = Deserialized(BatchPoolEvaluateAutoScaleResponse, response)
            dersialized = deserialize()
           
        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def get(self, pool_name=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        try:
            response = self._ops.get(pool_name=pool_name, detail_level=self.filter, access_condition=self.access_condition)

            deserialize = Deserialized(BatchPoolGetResponse, response)
            dersialized = deserialize(response.content, self._classes)
            
        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def list(self):

        try:
            response = self._ops.list(max_results=self.max_results, detail_level=self.filter)

            deserialize = Deserialized(BatchPoolListResponse, response)
            dersialized = deserialize(response.content, self._classes)

            def next_page(next_link):
                response = self._ops.list_next(next_link=next_link) 
                deserialize = Deserialized(BatchPoolListResponse, response)
                dersialized = deserialize(response.content, self._classes)   
                return deserialized    

            pager = Paged(deserialized.pools, deserialized.next_link, next_page)

        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return pager

    def patch(self, parameters, pool_name=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not parameters:
            raise ValueError('parameters cannot be None.')

        content = Serialized(parameters)

        try:
            response = self._ops.patch(content, pool_name=pool_name, access_condition=self.access_condition)

            deserialize = Deserialized(BatchPoolPatchResponse, response)
            dersialized = deserialize()

        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def resize(self, parameters, pool_name=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not parameters:
            raise ValueError('parameters cannot be None.')

        content = Serialized(parameters)

        try:
            response = self._ops.resize(content, pool_name=pool_name, access_condition=self.access_condition)

            deserialize = Deserialized(BatchPoolResizeResponse, response)
            dersialized = deserialize()

        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def stop_resize(self, pool_name=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        try:
            response = self._ops.stop_resize(pool_name=pool_name, access_condition=self.access_condition)

            deserialize = Deserialized(BatchPoolStopResizeResponse, response)
            dersialized = deserialize()

        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def update_properties(self, properties, pool_name=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        if not properties:
            raise ValueError('properties cannot be None.')
                    
        content = Serialized(properties)

        try:
            response = self._ops.update_properties(content, pool_name=pool_name, access_condition=self.access_condition)

            deserialize = Deserialized(BatchPoolUpdatePropertiesResponse, response)
            dersialized = deserialize()

        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def upgrade_os(self, parameters, pool_name=None):

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not parameters:
            raise ValueError('parameters cannot be None.')

        content = Serialized(parameters)

        try:
            response = self._ops.upgrade_os(content, pool_name=pool_name, access_condition=self.access_condition)

            deserialize = Deserialized(BatchPoolUpgradeOSResponse, response)
            dersialized = deserialize()

        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized


