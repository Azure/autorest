

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

        self.pool = None


class BatchPoolListResponse(BatchOperationResponse):
    
    def __init__(self):

        super(BatchPoolListResponse, self).__init__()

        self.body_map.update({
            'pools': {'key':'value', 'type':'[Pool]'},
            'next_link': {'key':'', 'type':'str'},
        })

        self.pools = []
        self.next_link = None


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
        self.auto_scale_formula = None


class DetailLevel(object):
    
    def __init__(self):
        self.filter_clause = None
        self.select_clause = None
        self.expand_clause = None


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

        self.certificate_references = []
        self.metadata = {}
        self.name = None
        self.url = None
        self.e_tag = None
        self.last_modified = None
        self.creation_time = None
        self.state = None
        self.state_transition_time = None
        self.allocation_state = None
        self.allocation_state_transition_time = None
        self.tvm_size = None
        self.resize_timeout = None
        self.resize_error = None
        self.current_dedicated = None
        self.target_dedicated = None
        self.enable_auto_scale = None
        self.auto_scale_formula = None
        self.auto_scale_run = None
        self.communication = None
        self.start_task = None
        self.max_tasks_per_tvm = None
        self.scheduling_policy = None
        self.stats = None
        self.os_family = None
        self.target_os_version = None
        self.current_os_version = None


class BatchPoolPatchParameters(object):
    
    def __init__(self):

        self.attribute_map = {
            'certificate_references': {'key':'autoScaleFormula', 'type':'[Certificate]'},
            'metadata': {'key':'autoScaleFormula', 'type':'{str}'},
            'start_task': {'key':'autoScaleFormula', 'type':'StartTask'}
        }

        self.certificate_references = []
        self.metadata = []
        self.start_task = None


class BatchPoolResizeParameters(object):
    
    def __init__(self):

        self.attribute_map = {
            'resize_timeout': {'key':'resizeTimeout', 'type':'time'},
            'target_dedicated': {'key':'targetDedicated', 'type':'int'},
            'tvm_deallocation_option': {'key':'tvmDeallocationOption', 'type':'str'}
        }

        self.target_dedicated = None
        self.resize_timeout = None
        self.tvm_deallocation_option = None


class BatchPoolUpdatePropertiesParameters(object):
    
    def __init__(self):

        self.attribute_map = {
            'certificate_references': {'key':'autoScaleFormula', 'type':'[Certificate]'},
            'metadata': {'key':'autoScaleFormula', 'type':'{str}'},
            'start_task': {'key':'autoScaleFormula', 'type':'StartTask'}
        }
        self.certificate_references = []
        self.metadata = []
        self.start_task = None


class BatchPoolUpgradeOSParameters(object):
    
    def __init__(self):

        self.attribute_map = {
            'target_os_version': {'key':'targetOSVersion', 'type':'str'}
        }
        self.target_os_version = None
 