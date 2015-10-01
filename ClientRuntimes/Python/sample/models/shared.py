from runtime.msrest.utils import *

class Certificate(object):
    
    def __init__(self):
        self.thumbprint = None
        self.thumbprint_algorithm = None
        self.url = None
        self.state = None
        self.state_transition_time = None
        self.previous_state = None
        self.previous_state_transition_time = None
        self.data = None
        self.certificate_format = None
        self.password = None
        self.public_data = None
        self.delete_certificate_error = None

class AccessCondition(object):
    
    def __init__(self, **kwargs):

        self.if_modified_since_time = None
        self.if_not_modified_since_time = None
        self.if_match_e_tag = None
        self.if_none_match_e_tag = None

    def get_headers(self):

        headers = {}
        if self.if_match_e_tag:
            headers['If-Match'] = self.if_match_e_tag

        if self.if_modified_since_time:
            headers['If-Modified-Since'] = format_datetime_header(
                self.if_modified_since_time)

        if self.if_none_match_e_tag:
            headers['If-None-Match'] = self.if_none_match_e_tag

        if self.if_not_modified_since_time:
            headers['If-Unmodified-Since'] = format_datetime_header(
                self.if_not_modified_since_time)

        return headers
   

    