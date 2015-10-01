

class BatchPoolAddResponse(BatchOperationResponse):
    pass


class BatchPoolDeleteResponse(BatchOperationResponse):
    pass


class BatchPoolDisableAutoScaleResponse(BatchOperationResponse):
    pass


class BatchPoolEnableAutoScaleResponse(BatchOperationResponse):
    pass


class BatchPoolEvaluateAutoScaleResponse(BatchOperationResponse):
    pass


class BatchPoolGetResponse(BatchOperationResponse):
    
    def __init__(self):

        super(BatchPoolGetResponse, self).__init__()

        self.body_map.update({
            'pool': {'key':'value', 'type':'Pool'},
        })

        self._pool = None
    
    @property
    def pool(self):
        return self._pool
    
    @pool.setter 
    def pool(self, value):
        self._pool = value


class BatchPoolListResponse(BatchOperationResponse):
    
    def __init__(self):

        super(BatchPoolListResponse, self).__init__()

        self.body_map.update({
            'pools': {'key':'value', 'type':'[Pool]'},
            'next_link': {'key':'', 'type':'str'},
        })

        self._pools = []
        self._next_link = None
    
    @property
    def next_link(self):
        return self._next_link
    
    @next_link.setter 
    def next_link(self, value):
        self._next_link = value
    
    @property
    def pools(self):
        return self._pools
    
    @pools.setter 
    def pools(self, value):
        self._pools = value


class BatchPoolPatchResponse(BatchOperationResponse):
    pass


class BatchPoolResizeResponse(BatchOperationResponse):
    pass


class BatchPoolStopResizeResponse(BatchOperationResponse):
    pass


class BatchPoolUpdatePropertiesResponse(BatchOperationResponse):
    pass


class BatchPoolUpgradeOSResponse(BatchOperationResponse):
    pass


class BatchPoolEnableAutoScaleParameters(object):
    
    def __init__(self):

        self.attribute_map = {
            'auto_scale_formula': {'key':'autoScaleFormula', 'type':'str'}
        }
        self._auto_scale_formula = None
    
    @property
    def auto_scale_formula(self):
        return self._auto_scale_formula
    
    @auto_scale_formula.setter 
    def auto_scale_formula(self, value):
        self._auto_scale_formula = value


class DetailLevel(object):
    
    def __init__(self):
        self._filter_clause = None
        self._select_clause = None
        self._expand_clause = None
    
    @property
    def expand_clause(self):
        return self._expand_clause
    
    @expand_clause.setter 
    def expand_clause(self, value):
        self._expand_clause = value
    
    @property
    def filter_clause(self):
        return self._filter_clause
    
    @filter_clause.setter 
    def filter_clause(self, value):
        self._filter_clause = value
    
    @property
    def select_clause(self):
        return self._select_clause
    
    @select_clause.setter 
    def select_clause(self, value):
        self._select_clause = value


class Pool(object):
    
    def __init__(self):

        self.attribute_map = {
            'id':{'key':'id', 'type':'str'},
            'certificate_references': {'key':'certificateReferences', 'type':'[Certificate]'},
            'metadata': {'key':'metadata', 'type':'{str}'},
            'name': {'key':'displayName', 'type':'str'},
            'url': {'key':'url', 'type':'str'},
            'e_tag': {'key':'eTag', 'type':'str'},
            'last_modified': {'key':'lastModifed', 'type':'datetime'},
            'creation_time': {'key':'creationTime', 'type':'datetime'},
            'state': {'key':'state', 'type':'str'},
            'state_transition_time': {'key':'stateTransitionTime', 'type':'datetime'},
            'allocation_state': {'key':'allocationState', 'type':'str'},
            'allocation_state_transition_time': {'key':'allocationStateTransitionTime', 'type':'datetime'},
            'vm_size': {'key':'vmSize', 'type':'str'},
            'resize_timeout': {'key':'resizeTimeout', 'type':'time'},
            'resize_error': {'key':'resizeError', 'type':'ResizeError'},
            'current_dedicated': {'key':'currentDedicated', 'type':'int'},
            'target_dedicated': {'key':'targetDedicated', 'type':'int'},
            'enable_auto_scale': {'key':'enableAutoScale', 'type':'bool'},
            'auto_scale_formula': {'key':'autoScaleFormula', 'type':'str'},
            'auto_scale_run': {'key':'autoScaleRun', 'type':'AutoScaleRun'},
            'communication': {'key':'enableInterNodeCommunication', 'type':'str'},
            'start_task': {'key':'startTask', 'type':'StartTask'},
            'max_tasks_per_node': {'key':'maxTasksPerNode', 'type':'int'},
            'scheduling_policy': {'key':'taskSchedulingPolicy', 'type':'TaskSchedulePolicy'},
            'stats': {'key':'stats', 'type':'ResourceStats'},
            'os_family': {'key':'osFamily', 'type':'str'},
            'target_os_version': {'key':'targetOSVersion', 'type':'str'},
            'current_os_version': {'key':'currentOSVersion', 'type':'str'},
        }

        self._certificate_references = []
        self._metadata = {}
        self._name = None
        self._url = None
        self._e_tag = None
        self._last_modified = None
        self._creation_time = None
        self._state = None
        self._state_transition_time = None
        self._allocation_state = None
        self._allocation_state_transition_time = None
        self._tvm_size = None
        self._resize_timeout = None
        self._resize_error = None
        self._current_dedicated = None
        self._target_dedicated = None
        self._enable_auto_scale = None
        self._auto_scale_formula = None
        self._auto_scale_run = None
        self._communication = None
        self._start_task = None
        self._max_tasks_per_tvm = None
        self._scheduling_policy = None
        self._stats = None
        self._os_family = None
        self._target_os_version = None
        self._current_os_version = None
    
    @property
    def allocation_state(self):
        return self._allocation_state
    
    @allocation_state.setter 
    def allocation_state(self, value):
        self._allocation_state = value
    
    @property
    def allocation_state_transition_time(self):
        return self._allocation_state_transition_time
    
    @allocation_state_transition_time.setter 
    def allocation_state_transition_time(self, value):
        self._allocation_state_transition_time = value
    
    @property
    def auto_scale_formula(self):
        return self._auto_scale_formula
    
    @auto_scale_formula.setter 
    def auto_scale_formula(self, value):
        self._auto_scale_formula = value
    
    @property
    def auto_scale_run(self):
        return self._auto_scale_run
    
    @auto_scale_run.setter 
    def auto_scale_run(self, value):
        self._auto_scale_run = value
    
    @property
    def certificate_references(self):
        return self._certificate_references
    
    @certificate_references.setter 
    def certificate_references(self, value):
        self._certificate_references = value
    
    @property
    def communication(self):
        return self._communication
    
    @communication.setter 
    def communication(self, value):
        self._communication = value
    
    @property
    def creation_time(self):
        return self._creation_time
    
    @creation_time.setter 
    def creation_time(self, value):
        self._creation_time = value
    
    @property
    def current_dedicated(self):
        return self._current_dedicated
    
    @current_dedicated.setter 
    def current_dedicated(self, value):
        self._current_dedicated = value
    
    @property
    def current_os_version(self):
        return self._current_os_version
    
    @current_os_version.setter 
    def current_os_version(self, value):
        self._current_os_version = value
    
    @property
    def enable_auto_scale(self):
        return self._enable_auto_scale
    
    @enable_auto_scale.setter 
    def enable_auto_scale(self, value):
        self._enable_auto_scale = value
    
    @property
    def e_tag(self):
        return self._e_tag
    
    @e_tag.setter 
    def e_tag(self, value):
        self._e_tag = value
    
    @property
    def last_modified(self):
        return self._last_modified
    
    @last_modified.setter 
    def last_modified(self, value):
        self._last_modified = value
    
    @property
    def max_tasks_per_tvm(self):
        return self._max_tasks_per_tvm
    
    @max_tasks_per_tvm.setter 
    def max_tasks_per_tvm(self, value):
        self._max_tasks_per_tvm = value
    
    @property
    def metadata(self):
        return self._metadata
    
    @metadata.setter 
    def metadata(self, value):
        self._metadata = value
    
    @property
    def name(self):
        return self._name
    
    @name.setter 
    def name(self, value):
        self._name = value
    
    @property
    def os_family(self):
        return self._os_family
    
    @os_family.setter 
    def os_family(self, value):
        self._os_family = value
    
    @property
    def resize_error(self):
        return self._resize_error
    
    @resize_error.setter 
    def resize_error(self, value):
        self._resize_error = value
    
    @property
    def resize_timeout(self):
        return self._resize_timeout
    
    @resize_timeout.setter 
    def resize_timeout(self, value):
        self._resize_timeout = value
    
    @property
    def scheduling_policy(self):
        return self._scheduling_policy
    
    @scheduling_policy.setter 
    def scheduling_policy(self, value):
        self._scheduling_policy = value
    
    @property
    def start_task(self):
        return self._start_task
    
    @start_task.setter 
    def start_task(self, value):
        self._start_task = value
    
    @property
    def state(self):
        return self._state
    
    @state.setter 
    def state(self, value):
        self._state = value
    
    @property
    def state_transition_time(self):
        return self._state_transition_time
    
    @state_transition_time.setter 
    def state_transition_time(self, value):
        self._state_transition_time = value
    
    @property
    def stats(self):
        return self._stats
    
    @stats.setter 
    def stats(self, value):
        self._stats = value
    
    @property
    def target_dedicated(self):
        return self._target_dedicated
    
    @target_dedicated.setter 
    def target_dedicated(self, value):
        self._target_dedicated = value
    
    @property
    def target_os_version(self):
        return self._target_os_version
    
    @target_os_version.setter 
    def target_os_version(self, value):
        self._target_os_version = value
    
    @property
    def tvm_size(self):
        return self._tvm_size
    
    @tvm_size.setter 
    def tvm_size(self, value):
        self._tvm_size = value
    
    @property
    def url(self):
        return self._url
    
    @url.setter 
    def url(self, value):
        self._url = value


class BatchPoolPatchParameters(object):
    
    def __init__(self):

        self.attribute_map = {
            'certificate_references': {'key':'autoScaleFormula', 'type':'[Certificate]'},
            'metadata': {'key':'autoScaleFormula', 'type':'{str}'},
            'start_task': {'key':'autoScaleFormula', 'type':'StartTask'}
        }

        self._certificate_references = []
        self._metadata = []
        self._start_task = None
    
    @property
    def certificate_references(self):
        return self._certificate_references
    
    @certificate_references.setter 
    def certificate_references(self, value):
        self._certificate_references = value
    
    @property
    def metadata(self):
        return self._metadata
    
    @metadata.setter 
    def metadata(self, value):
        self._metadata = value
    
    @property
    def start_task(self):
        return self._start_task
    
    @start_task.setter 
    def start_task(self, value):
        self._start_task = value


class BatchPoolResizeParameters(object):
    
    def __init__(self):

        self.attribute_map = {
            'resize_timeout': {'key':'resizeTimeout', 'type':'time'},
            'target_dedicated': {'key':'targetDedicated', 'type':'int'},
            'tvm_deallocation_option': {'key':'tvmDeallocationOption', 'type':'str'}
        }

        self._target_dedicated = None
        self._resize_timeout = None
        self._tvm_deallocation_option = None
    
    @property
    def resize_timeout(self):
        return self._resize_timeout
    
    @resize_timeout.setter 
    def resize_timeout(self, value):
        self._resize_timeout = value
    
    @property
    def target_dedicated(self):
        return self._target_dedicated
    
    @target_dedicated.setter 
    def target_dedicated(self, value):
        self._target_dedicated = value
    
    @property
    def tvm_deallocation_option(self):
        return self._tvm_deallocation_option
    
    @tvm_deallocation_option.setter 
    def tvm_deallocation_option(self, value):
        self._tvm_deallocation_option = value


class BatchPoolUpdatePropertiesParameters(object):
    
    def __init__(self):

        self.attribute_map = {
            'certificate_references': {'key':'autoScaleFormula', 'type':'[Certificate]'},
            'metadata': {'key':'autoScaleFormula', 'type':'{str}'},
            'start_task': {'key':'autoScaleFormula', 'type':'StartTask'}
        }
        self._certificate_references = []
        self._metadata = []
        self._start_task = None
    
    @property
    def certificate_references(self):
        return self._certificate_references
    
    @certificate_references.setter 
    def certificate_references(self, value):
        self._certificate_references = value
    
    @property
    def metadata(self):
        return self._metadata
    
    @metadata.setter 
    def metadata(self, value):
        self._metadata = value
    
    @property
    def start_task(self):
        return self._start_task
    
    @start_task.setter 
    def start_task(self, value):
        self._start_task = value


class BatchPoolUpgradeOSParameters(object):
    
    def __init__(self):

        self.attribute_map = {
            'target_os_version': {'key':'targetOSVersion', 'type':'str'}
        }
        self._target_os_version = None
    
    @property
    def target_os_version(self):
        return self._target_os_version
    
    @target_os_version.setter 
    def target_os_version(self, value):
        self._target_os_version = value