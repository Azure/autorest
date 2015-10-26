
class Page(object):

    _required = []

    _attribute_map = {
        'next_link': {'key':None, 'type':'str'}
        }

    def __init__(self, **kwargs):

        self.next_link = None

        for k in kwargs:
            if hasattr(self, k):
                setattr(self, k, kwargs[k])