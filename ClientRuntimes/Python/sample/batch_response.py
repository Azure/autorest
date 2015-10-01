from clientruntime.msrest import HTTPResponse

class BatchOperationResponse(HTTPResponse):
    
    def __init__(self):

        super(BatchOperationResponse, self).__init__()

        self.headers_map.update({
            'client_request_id': {'name': 'client-request-id', 'type':'str'},
            'data_service_id': {'name': 'dataserviceid', 'type':'str'},
            'e_tag': {'name': 'etag', 'type':'str'},
            'last_modified': {'name': 'last-modified', 'type':'datetime'}
        })

        self._client_request_id = None
        self._data_service_id = None
        self._e_tag = None
        self._last_modified = None
    
    @property
    def client_request_id(self):
        return self._client_request_id
    
    @client_request_id.setter 
    def client_request_id(self, value):
        self._client_request_id = value
    
    @property
    def data_service_id(self):
        return self._data_service_id
    
    @data_service_id.setter 
    def data_service_id(self, value):
        self._data_service_id = value
    
    @property
    def e_tag(self):
        return self._e_tag
    
    @e_tag.setter 
    def e_tag(self, value):
        self._e_tag = value
    
    @property
    def last_modified(self):
        return self._last_modified
    
    @last_modified.setter 
    def last_modified(self, value):
        self._last_modified = value
