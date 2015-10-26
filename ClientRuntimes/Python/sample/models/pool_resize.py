
class PoolResize(object):

    _required = []

    _attribute_map = {
            'resize_timeout': {'key':'resizeTimeout', 'type':'time'},
            'target_dedicated': {'key':'targetDedicated', 'type':'int'},
            'tvm_deallocation_option': {'key':'tvmDeallocationOption', 'type':'str'}
        }
    
    def __init__(self, **kwargs):

        self.target_dedicated = None
        self.resize_timeout = None
        self.tvm_deallocation_option = None

        for k in kwargs:
            if hasattr(self, k):
                setattr(self, k, kwargs[k])