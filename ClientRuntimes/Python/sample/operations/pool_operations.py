  
import urlparse
import urllib

class PoolOperations(object):
    
    def __init__(self, client):
        self.client = client

    def add(self, content):
        
        # Construct URL
        url = '/pools'
        query_parameters = {}
        query_parameters['api-version'] = '2014-10-01.1.0'
        query_parameters['timeout'] = '30'
        
        # Create HTTP transport objects
        http_request = self.client.post(url, query_parameters)
        
        # Set Headers
        http_request.add_header('Content-Type', 'application/json;odata=minimalmetadata')
        http_request.add_header('ocp-date', datetime.utcnow().strftime('%a, %d %b %Y %H:%M:%S GMT'))
        

        http_request.data = json.dumps(content())
        http_request.add_header('Content-Length', len(http_request.data))
        
        # Send Request
        response = self.client.send(http_request)
        
        return response
    
    def delete(self, **parameters):

        # Construct URL
        url = '/pools/'
        url = url + parameters.get(pool_name)

        query_parameters = {}
        query_parameters['api-version'] = '2014-10-01.1.0'
        query_parameters['timeout'] = '30'
        
        # Create HTTP transport objects
        http_request = self.client.delete(url, query_parameters)

        access_condition = parameters.get('access_condition')
        
        # Set Headers
        if access_condition:
            if access_condition.if_match_e_tag:
                http_request.add_header('If-Match', access_condition.if_match_e_tag)
        
            if access_condition.if_modified_since_time:
                http_request.add_header('If-Modified-Since', access_condition.if_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
            if access_condition.if_none_match_e_tag:
                http_request.add_header('If-None-Match', access_condition.if_none_match_e_tag)
        
            if access_condition.if_not_modified_since_time:
                http_request.add_header('If-Unmodified-Since', access_condition.if_not_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        http_request.add_header('ocp-date', datetime.utcnow().strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        # Send Request
        response = self.client.send(http_request)
        
        return response
    
    def disable_auto_scale(self, **parameters):
        
        # Construct URL
        url = '/pools/'
        url = url + parameters.get(pool_name)

        query_parameters = {}
        query_parameters['disableautoscale'] = None
        query_parameters['api-version'] = '2014-10-01.1.0'
        query_parameters['timeout'] = '30'
        
        # Create HTTP transport objects
        http_request = self.client.post(url, query_parameters)

        access_condition = parameters.get('access_condition')
        
        # Set Headers
        if access_condition:
            if access_condition.if_match_e_tag:
                http_request.add_header('If-Match', access_condition.if_match_e_tag)
        
            if access_condition.if_modified_since_time:
                http_request.add_header('If-Modified-Since', access_condition.if_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
            if access_condition.if_none_match_e_tag:
                http_request.add_header('If-None-Match', access_condition.if_none_match_e_tag)
        
            if access_condition.if_not_modified_since_time:
                http_request.add_header('If-Unmodified-Since', access_condition.if_not_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        http_request.add_header('ocp-date', datetime.utcnow().strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        # Send Request
        response = self.client.send(http_request)
        
        return response
    
    def enable_auto_scale(self, content, **parameters):
        
        # Construct URL
        url = '/pools/'
        url = url + parameters.get(pool_name)

        query_parameters = {}
        query_parameters['enableautoscale'] = None
        query_parameters['api-version'] = '2014-10-01.1.0'
        query_parameters['timeout'] = '30'
        
        # Create HTTP transport objects
        http_request = self.client.post(url, query_parameters)
        
        # Set Headers
        http_request.add_header('Content-Type', 'application/json;odata=minimalmetadata')

        access_condition = parameters.get('access_condition')

        if access_condition:
            if access_condition.if_match_e_tag:
                http_request.add_header('If-Match', access_condition.if_match_e_tag)
        
            if access_condition.if_modified_since_time:
                http_request.add_header('If-Modified-Since', access_condition.if_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
            if access_condition.if_none_match_e_tag:
                http_request.add_header('If-None-Match', access_condition.if_none_match_e_tag)
        
            if access_condition.if_not_modified_since_time:
                http_request.add_header('If-Unmodified-Since', access_condition.if_not_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        http_request.add_header('ocp-date', datetime.utcnow().strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        # Serialize Request
        http_request.data = json.dumps(content())
        http_request.add_header('Content-Length', len(request_content))
        
        # Send Request
        response = self.client.send(http_request)
        
        return response
    
    def evaluate_auto_scale(self, content, **parameters):
        
        # Construct URL
        url = '/pools/'
        url = url + parameters.get(pool_name)

        query_parameters = {}
        query_parameters['evaluateautoscale'] = None
        query_parameters['api-version'] = '2014-10-01.1.0'
        query_parameters['timeout'] = '30'
        
        # Create HTTP transport objects
        http_request = self.client.post(url, query_parameters)
        
        # Set Headers
        # Set Headers
        http_request.add_header('Content-Type', 'application/json;odata=minimalmetadata')
        http_request.add_header('ocp-date', datetime.utcnow().strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        # Serialize Request
        http_request.data = json.dumps(content())
        http_request.add_header('Content-Length', len(request_content))
        
        # Set Credentials
        self.client.credentials.process_request(http_request)
        
        # Send Request
        response = self.client.send(http_request)
        
        return response
    
    def get(self, **parameters):
        
        # Construct URL
        url = ''
        url = url + '/pools/'
        url = url + quote(pool_name)

        query_parameters = {}

        detail_level = parameters.get('detail_level')
        if detail_level:
            if detail_level.select_clause:
                query_parameters['$select'] = detail_level.select_clause
        
            if detail_level.expand_clause:
                query_parameters['$expand'] = detail_level.expand_clause
        
        query_parameters['api-version'] = '2014-10-01.1.0'
        query_parameters['timeout'] = '30'
        
        # Create HTTP transport objects
        http_request = self.client.get(url, query_parameters)

        access_condition = parameters.get('access_condition')
        
        # Set Headers
        if access_condition:
            if access_condition.if_match_e_tag:
                http_request.add_header('If-Match', access_condition.if_match_e_tag)
        
            if access_condition.if_modified_since_time:
                http_request.add_header('If-Modified-Since', access_condition.if_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
            if access_condition.if_none_match_e_tag:
                http_request.add_header('If-None-Match', access_condition.if_none_match_e_tag)
        
            if access_condition.if_not_modified_since_time:
                http_request.add_header('If-Unmodified-Since', access_condition.if_not_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        http_request.add_header('ocp-date', datetime.utcnow().strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        # Send Request
        response = self.client.send(http_request)
        
        return response
    
    def list(self, **parameters):
        
        # Construct URL
        url = '/pools'
        query_parameters = {}
        odata_filter = []

        detail_level = parameters.get('detail_level')
        if detail_level:
        
            if detail_level.filter_clause:
                odata_filter.append(detail_level.filter_clause)

            if detail_level.select_clause:
                query_parameters['$select'] = detail_level.select_clause
        
            if detail_level.expand_clause:
                query_parameters['$expand'] = detail_level.expand_clause
        
        max_results = parameters.get('detail_level')
        if max_results:
            query_parameters['maxresults'] = str(max_results)

        if odata_filter:
            query_parameters['$filter'] = ''.join(odata_filter)
        
        query_parameters['api-version'] = '2014-10-01.1.0'
        query_parameters['timeout'] = '30'
        
        # Create HTTP transport objects
        http_request = self.client.get(url, query_parameters)
        
        # Set Headers
        http_request.add_header('ocp-date', datetime.utcnow().strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        # Send Request
        response = self.client.send(http_request)
        
        return response
    
    def list_next(self, **parameters):
        
        # Construct URL
        url = parameters.get('next_link')
        url = urllib.quote(url)
        
        # Create HTTP transport objects
        http_request = self.client.get(url)
        
        # Set Headers
        http_request.add_header('ocp-date', datetime.utcnow().strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        # Set Credentials
        self.client.credentials.process_request(http_request)
        
        # Send Request
        response = self.client.send(http_request)
        
        return response
    
    def patch(self, content, **parameters):
        
        # Construct URL
        url = '/pools/'
        url = url + parameters.get(pool_name)

        query_parameters = {}
        query_parameters['api-version'] = '2014-10-01.1.0'
        query_parameters['timeout'] = '30'
        
        # Create HTTP transport objects
        http_request = self.client.patch(url, query_parameters)
        
        # Set Headers
        http_request.add_header('Content-Type', 'application/json;odata=minimalmetadata')

        access_condition = parameters.get('access_condition')

        if access_condition:
            if access_condition.if_match_e_tag:
                http_request.add_header('If-Match', access_condition.if_match_e_tag)
        
            if access_condition.if_modified_since_time:
                http_request.add_header('If-Modified-Since', access_condition.if_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
            if access_condition.if_none_match_e_tag:
                http_request.add_header('If-None-Match', access_condition.if_none_match_e_tag)
        
            if access_condition.if_not_modified_since_time:
                http_request.add_header('If-Unmodified-Since', access_condition.if_not_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        http_request.add_header('ocp-date', datetime.utcnow().strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        # Serialize Request
        http_request.data = json.dumps(content())
        http_request.add_header('Content-Length', len(request_content))
        
        # Send Request
        response = self.client.send(http_request)
        
        return response
    
    def resize(self, content, **parameters):
        
        # Construct URL
        url = '/pools/'
        url = url + parameters.get(pool_name)

        query_parameters = {}
        query_parameters['resize'] = None
        query_parameters['api-version'] = '2014-10-01.1.0'
        query_parameters['timeout'] = '30'
        
        # Create HTTP transport objects
        http_request = self.client.post(url, query_parameters)
        
        # Set Headers
        http_request.add_header('Content-Type', 'application/json;odata=minimalmetadata')

        access_condition = parameters.get('access_condition')

        if access_condition:
            if access_condition.if_match_e_tag:
                http_request.add_header('If-Match', access_condition.if_match_e_tag)
        
            if access_condition.if_modified_since_time:
                http_request.add_header('If-Modified-Since', access_condition.if_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
            if access_condition.if_none_match_e_tag:
                http_request.add_header('If-None-Match', access_condition.if_none_match_e_tag)
        
            if access_condition.if_not_modified_since_time:
                http_request.add_header('If-Unmodified-Since', access_condition.if_not_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        http_request.add_header('ocp-date', datetime.utcnow().strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        # Serialize Request
        http_request.data = json.dumps(content())
        http_request.add_header('Content-Length', len(request_content))
        
        # Send Request
        response = self.client.send(http_request)
        
        return response
    
    def stop_resize(self, **parameters):

        # Construct URL
        url = '/pools/'
        url = url + parameters.get(pool_name)

        query_parameters = {}
        query_parameters['stopresize'] = None
        query_parameters['api-version'] = '2014-10-01.1.0'
        query_parameters['timeout'] = '30'
        
        # Create HTTP transport objects
        http_request = self.client.post(url, query_parameters)
        
        # Set Headers
        http_request.add_header('Content-Type', 'application/json;odata=minimalmetadata')

        access_condition = parameters.get('access_condition')

        if access_condition:
            if access_condition.if_match_e_tag:
                http_request.add_header('If-Match', access_condition.if_match_e_tag)
        
            if access_condition.if_modified_since_time:
                http_request.add_header('If-Modified-Since', access_condition.if_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
            if access_condition.if_none_match_e_tag:
                http_request.add_header('If-None-Match', access_condition.if_none_match_e_tag)
        
            if access_condition.if_not_modified_since_time:
                http_request.add_header('If-Unmodified-Since', access_condition.if_not_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        http_request.add_header('ocp-date', datetime.utcnow().strftime('%a, %d %b %Y %H:%M:%S GMT'))

        # Send Request
        response = self.client.send(http_request)
        
        return response
    
    def update_properties(self, content, **parameters):
        
        # Construct URL
        url = '/pools/'
        url = url + parameters.get(pool_name)

        query_parameters = {}
        query_parameters['updateproperties'] = None
        query_parameters['api-version'] = '2014-10-01.1.0'
        query_parameters['timeout'] = '30'
        
        # Create HTTP transport objects
        http_request = self.client.post(url, query_parameters)
        
        # Set Headers
        http_request.add_header('Content-Type', 'application/json;odata=minimalmetadata')

        access_condition = parameters.get('access_condition')

        if access_condition:
            if access_condition.if_match_e_tag:
                http_request.add_header('If-Match', access_condition.if_match_e_tag)
        
            if access_condition.if_modified_since_time:
                http_request.add_header('If-Modified-Since', access_condition.if_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
            if access_condition.if_none_match_e_tag:
                http_request.add_header('If-None-Match', access_condition.if_none_match_e_tag)
        
            if access_condition.if_not_modified_since_time:
                http_request.add_header('If-Unmodified-Since', access_condition.if_not_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        http_request.add_header('ocp-date', datetime.utcnow().strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        # Serialize Request
        http_request.data = json.dumps(content())
        http_request.add_header('Content-Length', len(request_content))
        
        # Send Request
        response = self.client.send(http_request)
        
        return response
    
    def upgrade_os(self, content, **parameters):
        
        # Construct URL
        url = '/pools/'
        url = url + parameters.get(pool_name)

        query_parameters = {}
        query_parameters['upgradeos'] = None
        query_parameters['api-version'] = '2014-10-01.1.0'
        query_parameters['timeout'] = '30'
        
        # Create HTTP transport objects
        http_request = self.client.post(url, query_parameters)
        
        # Set Headers
        http_request.add_header('Content-Type', 'application/json;odata=minimalmetadata')

        access_condition = parameters.get('access_condition')

        if access_condition:
            if access_condition.if_match_e_tag:
                http_request.add_header('If-Match', access_condition.if_match_e_tag)
        
            if access_condition.if_modified_since_time:
                http_request.add_header('If-Modified-Since', access_condition.if_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
            if access_condition.if_none_match_e_tag:
                http_request.add_header('If-None-Match', access_condition.if_none_match_e_tag)
        
            if access_condition.if_not_modified_since_time:
                http_request.add_header('If-Unmodified-Since', access_condition.if_not_modified_since_time.strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        http_request.add_header('ocp-date', datetime.utcnow().strftime('%a, %d %b %Y %H:%M:%S GMT'))
        
        # Serialize Request
        http_request.data = json.dumps(content())
        http_request.add_header('Content-Length', len(request_content))
        
        # Send Request
        response = self.client.send(http_request)
        
        return response
        