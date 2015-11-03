
from runtime.msrest.serialization import Model

class PoolAutoScale(Model):

    _required = ['auto_scale_formula']

    _attribute_map = {
                'auto_scale_formula': {'key':'autoScaleFormula', 'type':'str'}
                }

    def __init__(self, **kwargs):

        self.auto_scale_formula = None
        for k in kwargs:
            if hasattr(self, k):
                setattr(self, k, kwargs[k])


