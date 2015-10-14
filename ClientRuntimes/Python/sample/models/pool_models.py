from exceptions import InvalidOperationError
from constants import *
from shared import *


class BatchPoolAddResponse(BatchOperationResponse):
    accept_status = [201]


class BatchPoolDeleteResponse(BatchOperationResponse):
    accept_status = [202]


class BatchPoolDisableAutoScaleResponse(BatchOperationResponse):
    accept_status = [202]


class BatchPoolEnableAutoScaleResponse(BatchOperationResponse):
    accept_status = [202]


class BatchPoolEvaluateAutoScaleResponse(BatchOperationResponse):
    accept_status = [202]


class BatchPoolGetResponse(BatchOperationResponse):
    accept_status = [200]

    def __init__(self):

        super(BatchPoolGetResponse, self).__init__()

        self.body_map.update({
            'pool': {'key':'value', 'type':'Pool'},
        })

        self.pool = None


class BatchPoolListResponse(BatchOperationResponse):
    accept_status = [200]

    def __init__(self):

        super(BatchPoolListResponse, self).__init__()

        self.body_map.update({
            'pools': {'key':'value', 'type':'[Pool]'},
            'next_link': {'key':'', 'type':'str'},
        })

        self.pools = []
        self.next_link = None


class BatchPoolPatchResponse(BatchOperationResponse):
    accept_status = [200]


class BatchPoolResizeResponse(BatchOperationResponse):
    accept_status = [202]


class BatchPoolStopResizeResponse(BatchOperationResponse):
    accept_status = [202]


class BatchPoolUpdatePropertiesResponse(BatchOperationResponse):
    accept_status = [204]


class BatchPoolUpgradeOSResponse(BatchOperationResponse):
    accept_status = [202]


class DetailLevel(object):
    
    def __init__(self):
        self.filter_clause = None
        self.select_clause = None
        self.expand_clause = None


class PoolSpec(object):
    
    def __init__(self, manager):

        self._manager = manager
        self.attribute_map = {
            'id':{'key':'id', 'type':'str'},
            'certificate_references': {'key':'certificateReferences', 'type':'[Certificate]'},
            'metadata': {'key':'metadata', 'type':'{str}'},
            'name': {'key':'displayName', 'type':'str'},
            'vm_size': {'key':'vmSize', 'type':'str'},
            'resize_timeout': {'key':'resizeTimeout', 'type':'time'},
            'target_dedicated': {'key':'targetDedicated', 'type':'int'},
            'enable_auto_scale': {'key':'enableAutoScale', 'type':'bool'},
            'auto_scale_formula': {'key':'autoScaleFormula', 'type':'str'},
            'communication': {'key':'enableInterNodeCommunication', 'type':'str'},
            'start_task': {'key':'startTask', 'type':'StartTask'},
            'max_tasks_per_node': {'key':'maxTasksPerNode', 'type':'int'},
            'scheduling_policy': {'key':'taskSchedulingPolicy', 'type':'TaskSchedulePolicy'},
            'os_family': {'key':'osFamily', 'type':'str'},
            'target_os_version': {'key':'targetOSVersion', 'type':'str'},
        }

        self.id = None
        self.certificate_references = []
        self.metadata = {}
        self.name = None
        self.tvm_size = None
        self.resize_timeout = None
        self.target_dedicated = None
        self.enable_auto_scale = None
        self.auto_scale_formula = None
        self.communication = None
        self.start_task = None
        self.max_tasks_per_tvm = None
        self.scheduling_policy = None
        self.os_family = None
        self.target_os_version = None

    def add(self):
        response = self._manager.add(self)
        return None


class Pool(PoolSpec):
    
    def __init__(self, manager):

        super(BatchPoolGetResponse, self).__init__(manager)

        self.attribute_map.update({
            'url': {'key':'url', 'type':'str'},
            'e_tag': {'key':'eTag', 'type':'str'},
            'last_modified': {'key':'lastModifed', 'type':'datetime'},
            'creation_time': {'key':'creationTime', 'type':'datetime'},
            'state': {'key':'state', 'type':'str'},
            'state_transition_time': {'key':'stateTransitionTime', 'type':'datetime'},
            'allocation_state': {'key':'allocationState', 'type':'str'},
            'allocation_state_transition_time': {'key':'allocationStateTransitionTime', 'type':'datetime'},
            'resize_error': {'key':'resizeError', 'type':'ResizeError'},
            'current_dedicated': {'key':'currentDedicated', 'type':'int'},
            'auto_scale_run': {'key':'autoScaleRun', 'type':'AutoScaleRun'},
            'stats': {'key':'stats', 'type':'ResourceStats'},
            'current_os_version': {'key':'currentOSVersion', 'type':'str'},
        })

        self.url = None
        self.e_tag = None
        self.last_modified = None
        self.creation_time = None
        self.state = None
        self.state_transition_time = None
        self.allocation_state = None
        self.allocation_state_transition_time = None
        self.resize_error = None
        self.current_dedicated = None
        self.auto_scale_run = None
        self.stats = None
        self.current_os_version = None

    def _update(self, new_pool):
        for attr in self.attribute_map:
            setattr(self, attr, getattr(new_pool, attr))

    def add(self):
        raise InvalidOperationError("This pool has already been added.")

    def update(self):
        response = self._manager.get(self.name)
        self._update(response.pool)

    def delete(self):
        response = self._manager.delete(self.name)

    def disable_auto_scale(self):
        response = self._manager.disable_auto_scale(self.name)

    def enable_auto_scale(self, auto_scale_formula):
        parameters = PoolAutoScale()
        parameters.auto_scale_formula = auto_scale_formula
        response = self._manager.enable_auto_scale(parameters, self.namen)

    def evaluate_auto_scale(self, auto_scale_formula):
        parameters = PoolAutoScale()
        parameters.auto_scale_formula = auto_scale_formula
        response = self._manager.evaluate_auto_scale(parameters, self.name)

    def patch(self, certificate_references=[], metadata={}, start_task=None):
        parameters = PoolProperties()
        parameters.certificate_references = certificate_references
        parameters.metadata = metadata
        parameters.start_task = start_task
        response = self._manager.patch(parameters, self.name)

    def resize(self, resize_timeout=None, target_dedicated=None, tvm_deallocation=None):
        parameters = PoolResize()
        paramters.resize_timeout = resize_timeout
        parameters.target_dedicated = target_dedicated
        parameters.tvm_deallocation_option = tvm_deallocation
        response = self._manager.resize(parameters, self.name)

    def stop_resize(self):
        response = self._manager.stop_resize(self.name)

    def update_properties(self, certificate_references=[], metadata={}, start_task=None):
        parameters = PoolProperties()
        parameters.certificate_references = certificate_references
        parameters.metadata = metadata
        parameters.start_task = start_task
        response = self._manager.update_properties(parameters, self.name)

    def upgrade_os(self, target_os_version):
        parameters = PoolOS()
        parameters.target_os_version = target_os_version
        response = self._manager.upgrade_os(parameters, self.namen)


class PoolAutoScale(object):

    def __init__(self):
        self.attribute_map = {
                'auto_scale_formula': {'key':'autoScaleFormula', 'type':'str'}
                }

        self.auto_scale_formula = None


class PoolProperties(object):
    
    def __init__(self):

        self.attribute_map = {
            'certificate_references': {'key':'certificate_references', 'type':'[Certificate]'},
            'metadata': {'key':'metadata', 'type':'{str}'},
            'start_task': {'key':'StartTask', 'type':'StartTask'}
        }

        self.certificate_references = []
        self.metadata = []
        self.start_task = None


class PoolResize(object):
    
    def __init__(self):

        self.attribute_map = {
            'resize_timeout': {'key':'resizeTimeout', 'type':'time'},
            'target_dedicated': {'key':'targetDedicated', 'type':'int'},
            'tvm_deallocation_option': {'key':'tvmDeallocationOption', 'type':'str'}
        }

        self.target_dedicated = None
        self.resize_timeout = None
        self.tvm_deallocation_option = None


class PoolOS(object):
    
    def __init__(self):

        self.attribute_map = {
            'target_os_version': {'key':'targetOSVersion', 'type':'str'}
        }
        self.target_os_version = None
 