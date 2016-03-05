# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class Endpoints(Model):
    """
    The URIs that are used to perform a retrieval of a public blob, queue or
    table object.

    :param str blob: Gets the blob endpoint.
    :param str queue: Gets the queue endpoint.
    :param str table: Gets the table endpoint.
    :param str file: Gets the file endpoint.
    """ 

    _attribute_map = {
        'blob': {'key': 'blob', 'type': 'str'},
        'queue': {'key': 'queue', 'type': 'str'},
        'table': {'key': 'table', 'type': 'str'},
        'file': {'key': 'file', 'type': 'str'},
    }

    def __init__(self, blob=None, queue=None, table=None, file=None, **kwargs):
        self.blob = blob
        self.queue = queue
        self.table = table
        self.file = file
