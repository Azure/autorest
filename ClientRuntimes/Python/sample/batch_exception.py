import json


class BatchException(Exception):

    def __init__(self, response, *args, **kwargs):

        self.data = {}
        self.message = ""
        self.request_id = ""
        self.error_time = None

        self.status_code = response.status_code
        data = kwargs.get('content', json.loads(response.content))

        self.error = data.get('code')
        message = data.get('message')

        if message.get('value'):
            msg_data = message['value'].split('\n')
            try:
                self.message = msg_data[0]
                self.request_id = msg_data[1]
                self.error_time = msg_data[2]

            except IndexError:
                pass

        for detail in data.get("values",[]):
            self.data[detail["key"]] = detail["value"]

        super(BatchException, self).__init__(*args)


class BatchStatusError(BatchException):
    
    def __new__(cls, response, *args, **kwargs):

        server_errors = {'AuthenticationFailed': BatchAuthenticationFailed,
                         'PoolNotFound': BatchPoolNotFound,
                         'InvalidRequestBody': BatchInvalidRequest,
                         'MissingRequiredHeader': BatchMissingRequiredHeader}

        data = json.loads(response.content)
        kwargs['content'] = data

        if data.get('code') in server_errors:
            return server_errors[data['code']](response, *args, **kwargs)

        
        return BatchException(response, *args, **kwargs)


class BatchAuthenticationFailed(BatchException):
    

   def __init__(self, response, *args, **kwargs):

        self.detail = None
        data = kwargs.get('content', json.loads(response.content))

        error_details = [v['value'] for v in data["values"] if v['key']=='AuthenticationErrorDetail']
        if error_details:
            self.detail = error_details[0]

        kwargs['content'] = data
        super(BatchAuthenticationFailed, self).__init__(response, *args, **kwargs)

class BatchPoolNotFound(BatchException):
    pass

class BatchInvalidRequest(BatchException):

    def __init__(self, response, *args, **kwargs):

        self.reason = None
        data = kwargs.get('content', json.loads(response.content))

        error_details = [v['value'] for v in data["values"] if v['key']=='Reason']
        if error_details:
            self.reason = error_details[0]

        kwargs['content'] = data
        super(BatchInvalidRequest, self).__init__(response, *args, **kwargs)

class BatchMissingRequiredHeader(BatchException):
    
    def __init__(self, response, *args, **kwargs):

        self.missing_header = None
        data = kwargs.get('content', json.loads(response.content))

        error_details = [v['value'] for v in data["values"] if v['key']=='HeaderName']
        if error_details:
            self.missing_header = error_details[0]

        kwargs['content'] = data
        super(BatchMissingRequiredHeader, self).__init__(response, *args, **kwargs)
