
from runtime.msrest.serialization import Model

class Pool(Model):

    _attribute_map = {
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
            'url': {'key':'url', 'type':'str'},
            'e_tag': {'key':'eTag', 'type':'str'},
            'last_modified': {'key':'lastModifed', 'type':'iso-8601'},
            'creation_time': {'key':'creationTime', 'type':'iso-8601'},
            'state': {'key':'state', 'type':'PoolState'},
            'state_transition_time': {'key':'stateTransitionTime', 'type':'rfc-18743958437'},
            'allocation_state': {'key':'allocationState', 'type':'AllocationState'},
            'allocation_state_transition_time': {'key':'allocationStateTransitionTime', 'type':'iso-8601'},
            'resize_error': {'key':'resizeError', 'type':'ResizeError'},
            'current_dedicated': {'key':'currentDedicated', 'type':'int'},
            'auto_scale_run': {'key':'autoScaleRun', 'type':'AutoScaleRun'},
            'stats': {'key':'stats', 'type':'ResourceStats'},
            'current_os_version': {'key':'currentOSVersion', 'type':'str'},
        }

    def __init__(self, **kwargs):

        for k in kwargs:
            if hasattr(self, k):
                setattr(self, k, kwargs[k])