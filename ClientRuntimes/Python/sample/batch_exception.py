

class BatchException(Exception):
    
    def __init__(self, response, *args, **kwargs):

        self.inner_excetion = response
        super(BatchException, self).__init__(*args, **kwargs)