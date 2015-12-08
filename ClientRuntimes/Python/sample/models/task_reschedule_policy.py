
from runtime.msrest.serialization import Model

class TaskSchedulePolicy(Model):

    _required = ['node_fill_type']

    _attribute_map = {
        'node_fill_type': {'key':'nodeFillType', 'type':'str'}
        }

    def __init__(self, **kwargs):

        self.node_fill_type = None

        for k in kwargs:
            if hasattr(self, k):
                setattr(self, k, kwargs[k])