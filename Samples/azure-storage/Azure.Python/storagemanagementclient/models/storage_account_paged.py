# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.paging import Paged


class StorageAccountPaged(Paged):
    """
    A paging container for iterating over a list of StorageAccount object
    """

    _attribute_map = {
        'next_link': {'key': 'nextLink', 'type': 'str'},
        'current_page': {'key': 'value', 'type': '[StorageAccount]'}
    }

    def __init__(self, *args, **kwargs):

        super(StorageAccountPaged, self).__init__(*args, **kwargs)
