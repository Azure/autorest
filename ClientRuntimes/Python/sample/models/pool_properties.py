
class PoolProperties(object):

    _required = []

    _attribute_map = {
            'certificate_references': {'key':'certificate_references', 'type':'[Certificate]'},
            'metadata': {'key':'metadata', 'type':'{str}'},
            'start_task': {'key':'StartTask', 'type':'StartTask'}
        }
    
    def __init__(self, **kwargs):

        self.certificate_references = []
        self.metadata = []
        self.start_task = None

        for k in kwargs:
            if hasattr(self, k):
                setattr(self, k, kwargs[k])
