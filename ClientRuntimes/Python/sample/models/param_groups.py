from runtime.msrest.utils import *

class DetailLevel(object):
    
    def __init__(self):
        self.filter_clause = None
        self.select_clause = None
        self.expand_clause = None

    def get_parameters(self):
        params = {}

        if self.select_clause:
            params['$select'] = self.select_clause

        if self.expand_clause:
            params['$expand'] = self.expand_clause

        if self.filter_clause:
            params['$filter'] = self.filter_clause

        return params


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
   

    