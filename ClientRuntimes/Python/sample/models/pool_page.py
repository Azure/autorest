

from runtime.msrest.paging import Paged

class PoolsPaged(Paged):

    _attribute_map = {
        'next_link': {'key':'odata.nextLink', 'type':'str'},
        'items': {'key':'value', 'type': '[Pool]'}
        }