


from clientruntime.msrest.serialization import Serialized, Deserialized
from clientruntime.msrest.exceptions import ResponseStatusError

from pool_operations import PoolOperations
from pool_models import *

import sys
import inspect

class PoolManager(object):

    def __init__(self, client):

        self._ops = PoolOperations(client)
        self._classes = inspect.getmembers(sys.modules[__name__])

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

    def pool(self):
        return PoolRequest(self)

    def add(self, pool):
        rest_params = locals()

        # Validate
        if pool:
            if pool.auto_scale_run:
                if pool.auto_scale_run.error:
                    if pool.auto_scale_run.error.values:

                        for i in pool.auto_scale_run.error.values:
                            if not i.name:
                                raise ValueError('pool.auto_scale_run.error.values.name cannot be None.')
                            
                            if not i.value:
                                raise ValueError('pool.auto_scale_run.error.values.value cannot be None.')
                        
                if not pool.auto_scale_run.results:
                    raise ValueError('pool.auto_scale_run.results cannot be None.')
                
                if not pool.auto_scale_run.timestamp:
                    raise ValueError('pool.auto_scale_run.timestamp cannot be None.')
                
            if pool.certificate_references:
                for i in pool.certificate_references:
                    if not i.store_location:
                        raise ValueError('pool.certificate_references.store_location cannot be None.')
                    
                    if not i.store_name:
                        raise ValueError('pool.certificate_references.store_name cannot be None.')
                    
                    if not i.thumbprint:
                        raise ValueError('pool.certificate_references.thumbprint cannot be None.')
                    
                    if not i.thumbprint_algorithm:
                        raise ValueError('pool.certificate_references.thumbprint_algorithm cannot be None.')
                    
                    if not i.visibility:
                        raise ValueError('pool.certificate_references.visibility cannot be None.')
                
            if pool.metadata:
                for i in pool.metadata:
                    if not i.name:
                        raise ValueError('pool.metadata.name cannot be None.')
                
            if not pool.name:
                raise ValueError('pool.name cannot be None.')
            
            if pool.resize_error:
                if pool.resize_error.values:
                    for i in pool.resize_error.values:
                        if not i.name:
                            raise ValueError('pool.resize_error.values.name cannot be None.')
                        
                        if not i.value:
                            raise ValueError('pool.resize_error.values.value cannot be None.')
                    
            if pool.scheduling_policy:
                if not pool.scheduling_policy.tvm_fill_type:
                    raise ValueError('pool.scheduling_policy.tvm_fill_type cannot be None.')
                
            if pool.start_task:
                if not pool.start_task.command_line:
                    raise ValueError('pool.start_task.command_line cannot be None.')
                
                if not pool.start_task.environment_settings:
                    raise ValueError('pool.start_task.environment_settings cannot be None.')
                
                if pool.start_task.environment_settings:
                    for i in pool.start_task.environment_settings:
                        if not i.name:
                            raise ValueError('pool.start_task.environment_settings.name cannot be None.')
                    
                if (parameters.pool.start_task.resource_files is None):
                    raise ValueError('pool.start_task.resource_files cannot be None.')
                
                if pool.start_task.resource_files:
                    for i in pool.start_task.resource_files:
                        if not i.blob_source:
                            raise ValueError('pool.start_task.resource_files.blob_source cannot be None.')
                        
                        if not i.file_path:
                            raise ValueError('pool.start_task.resource_files.file_path cannot be None.')
        
        content = Serialized(rest_params.pop('pool'))

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
        rest_params = locals()

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        try:
            response = self._ops.delete(access_condition=self.access_condition, **rest_params)

            deserialize = Deserialized(BatchPoolDeleteResponse, response)
            deserialized = deserialize()
            
        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return deserialized

    def disable_auto_scale(self, pool_name=None):
        rest_params = locals()

        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        try:
            response = self._ops.disable_auto_scale(access_condition=self.access_condition, **rest_params)

            deserialize = Deserialized(BatchPoolDisableAutoScaleResponse, response)
            dersialized = deserialize()
           
        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def enable_auto_scale(self, parameters, pool_name=None):
        rest_params = locals()

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not parameters:
            raise ValueError('parameters cannot be None.')
        
        if not parameters.auto_scale_formula:
            raise ValueError('parameters.auto_scale_formula cannot be None.')

        content = Serialized(rest_params.pop('parameters'))

        try:
            response = self._ops.enable_auto_scale(content, access_condition=self.access_condition, **rest_params)

            deserialize = Deserialized(BatchPoolEnableAutoScaleResponse, response)
            dersialized = deserialize()
           
        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def evaluate_auto_scale(self, parameters, pool_name=None):
        rest_params = locals()

        # Validate
        if (pool_name is None):
            raise ValueError('pool_name cannot be None.')
        
        if (parameters is None):
            raise ValueError('parameters cannot be None.')
        
        if (parameters.auto_scale_formula is None):
            raise ValueError('parameters.auto_scale_formula cannot be None.')

        content = Serialized(rest_params.pop('parameters'))

        try:
            response = self._ops.evaluate_auto_scale(content, **rest_params)

            deserialize = Deserialized(BatchPoolEvaluateAutoScaleResponse, response)
            dersialized = deserialize()
           
        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def get(self, pool_name=None):
        rest_params = locals()

        # Validate
        if (pool_name is None):
            raise ValueError('pool_name cannot be None.')

        try:
            response = self._ops.get(detail_level=self.filter, access_condition=self.access_condition, **rest_params)

            deserialize = Deserialized(BatchPoolGetResponse, response)
            dersialized = deserialize(response.content, self._classes)
            
        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def list(self):
        rest_params = locals()

        try:
            response = self._ops.list(max_results=self.max_results, detail_level=self.filter, **rest_params)

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
        rest_params = locals()

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not parameters:
            raise ValueError('parameters cannot be None.')
        
        if parameters.certificate_references:
            for i in parameters.certificate_references:
                if not i.store_location:
                    raise ValueError('parameters.certificate_references.store_location cannot be None.')
                
                if not i.store_name:
                    raise ValueError('parameters.certificate_references.store_name cannot be None.')
                
                if not i.thumbprint:
                    raise ValueError('parameters.certificate_references.thumbprint cannot be None.')
                
                if not i.thumbprint_algorithm:
                    raise ValueError('parameters.certificate_references.thumbprint_algorithm cannot be None.')
                
                if not i.visibility:
                    raise ValueError('parameters.certificate_references.visibility cannot be None.')
            
        if parameters.metadata:
            for i in parameters.metadata:
                if not i.name:
                    raise ValueError('parameters.metadata.name cannot be None.')
            
        if parameters.start_task:
            if not parameters.start_task.command_line:
                raise ValueError('parameters.start_task.command_line cannot be None.')
            
            if parameters.start_task.environment_settings is None:
                raise ValueError('parameters.start_task.environment_settings cannot be None.')
            
            else:
                for i in parameters.start_task.environment_settings:
                    if not i.name:
                        raise ValueError('parameters.start_task.environment_settings.name cannot be None.')
                    

            if parameters.start_task.resource_files is None:
                raise ValueError('parameters.start_task.resource_files cannot be None.')
            
            else:
                for i in parameters.start_task.resource_files:
                    if not i.blob_source:
                        raise ValueError('parameters.start_task.resource_files.blob_source cannot be None.')
                    
                    if not i.file_path:
                        raise ValueError('parameters.start_task.resource_files.file_path cannot be None.')

        content = Serialized(rest_params.pop('parameters'))

        try:
            response = self._ops.patch(content, access_condition=self.access_condition, **rest_params)

            deserialize = Deserialized(BatchPoolPatchResponse, response)
            dersialized = deserialize()

        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def resize(self, parameters, pool_name=None):
        rest_params = locals()

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not parameters:
            raise ValueError('parameters cannot be None.')

        content = Serialized(rest_params.pop('parameters'))

        try:
            response = self._ops.resize(content, access_condition=self.access_condition, **rest_params)

            deserialize = Deserialized(BatchPoolResizeResponse, response)
            dersialized = deserialize()

        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def stop_resize(self, pool_name=None):
        rest_params = locals()

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        try:
            response = self._ops.stop_resize(access_condition=self.access_condition, **rest_params)

            deserialize = Deserialized(BatchPoolStopResizeResponse, response)
            dersialized = deserialize()

        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def update_properties(self, properties, pool_name=None):
        rest_params = locals()

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')

        if not properties:
            raise ValueError('properties cannot be None.')
        
        if parameters.certificate_references:
            for i in parameters.certificate_references:
                if not i.store_location:
                    raise ValueError('parameters.certificate_references.store_location cannot be None.')
                
                if not i.store_name:
                    raise ValueError('parameters.certificate_references.store_name cannot be None.')
                
                if not i.thumbprint:
                    raise ValueError('parameters.certificate_references.thumbprint cannot be None.')
                
                if not i.thumbprint_algorithm:
                    raise ValueError('parameters.certificate_references.thumbprint_algorithm cannot be None.')
                
                if not i.visibility:
                    raise ValueError('parameters.certificate_references.visibility cannot be None.')
            
        if parameters.metadata:
            for i in parameters.metadata:
                if not i.name:
                    raise ValueError('parameters.metadata.name cannot be None.')
            
        if parameters.start_task:
            if not parameters.start_task.command_line:
                raise ValueError('parameters.start_task.command_line cannot be None.')
            
            if parameters.start_task.environment_settings is None:
                raise ValueError('parameters.start_task.environment_settings cannot be None.')
            
            else:
                for i in parameters.start_task.environment_settings:
                    if not i.name:
                        raise ValueError('parameters.start_task.environment_settings.name cannot be None.')
                
            if parameters.start_task.resource_files is None:
                raise ValueError('parameters.start_task.resource_files cannot be None.')
            
            else:
                for i in parameters.start_task.resource_files:
                    if not i.blob_source:
                        raise ValueError('parameters.start_task.resource_files.blob_source cannot be None.')
                    
                    if not i.file_path:
                        raise ValueError('parameters.start_task.resource_files.file_path cannot be None.')
                    
        content = Serialized(rest_params.pop('properties'))

        try:
            response = self._ops.update_properties(content, access_condition=self.access_condition, **rest_params)

            deserialize = Deserialized(BatchPoolUpdatePropertiesResponse, response)
            dersialized = deserialize()

        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized

    def upgrade_os(self, parameters, pool_name=None):
        rest_params = locals()

        # Validate
        if not pool_name:
            raise ValueError('pool_name cannot be None.')
        
        if not parameters:
            raise ValueError('parameters cannot be None.')
        
        if not parameters.target_os_version:
            raise ValueError('parameters.target_os_version cannot be None.')

        content = Serialized(rest_params.pop('parameters'))

        try:
            response = self._ops.upgrade_os(content, access_condition=self.access_condition, **rest_params)

            deserialize = Deserialized(BatchPoolUpgradeOSResponse, response)
            dersialized = deserialize()

        except ResponseStatusError:
            raise AzureException(response)

        except:
            raise #TODO: exception handling

        return dersialized


