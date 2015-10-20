from runtime.msrest.response import HTTPResponse

class BatchOperationResponse(HTTPResponse):
    
    def __init__(self, **kwargs):

        super(BatchOperationResponse, self).__init__()

        self.headers_map.update({
            'client_request_id': {'key': 'client-request-id', 'type':'str'},
            'data_service_id': {'key': 'dataserviceid', 'type':'str'},
            'e_tag': {'key': 'etag', 'type':'str'},
            'last_modified': {'key': 'last-modified', 'type':'datetime'}
        })

        self.client_request_id = None
        self.data_service_id = None
        self.e_tag = None
        self.last_modified = None
