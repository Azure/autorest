import json
from msrestazure.azure_exceptions import CloudError


class BatchException(CloudError):
    pass

class BatchBadRequestError(BatchException):
    pass

class BatchEndpointNotFoundError(BatchException):
    pass

class BatchOperationConflict(BatchException):
    pass

class BatchStatusError(BatchException):

    status_errors = { 400: BatchBadRequestError,
                      404: BatchEndpointNotFoundError,
                      409: BatchOperationConflict
                     }

    def __new__(cls, *args, **kwargs):

        response = kwargs.get('response')
   
        if response is not None and response.status_code in cls.status_errors:
            return cls.status_errors[response.status_code](*args, **kwargs)

        else:
            return BatchException(*args, **kargs)
