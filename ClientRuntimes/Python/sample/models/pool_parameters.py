
class PoolParameters(object):

    _required = ['name']

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
        }
    
    def __init__(self, **kwargs):
        
        self.id = None
        self.certificate_references = []
        self.metadata = {}
        self.name = None
        self.vm_size = None
        self.resize_timeout = None
        self.target_dedicated = None
        self.enable_auto_scale = None
        self.auto_scale_formula = None
        self.communication = None
        self.start_task = None
        self.max_tasks_per_node = None
        self.scheduling_policy = None
        self.os_family = None
        self.target_os_version = None

        for k in kwargs:
            if hasattr(self, k):
                setattr(self, k, kwargs[k])