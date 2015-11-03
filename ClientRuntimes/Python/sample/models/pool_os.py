
from runtime.msrest.serialization import Model

class PoolOS(Model):

    _required = ['target_os_version']

    _attribute_map = {
            'target_os_version': {'key':'targetOSVersion', 'type':'str'}
        }
    
    def __init__(self, **kwargs):

        self.target_os_version = None

        for k in kwargs:
            if hasattr(self, k):
                setattr(self, k, kwargs[k])