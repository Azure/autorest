class Certificate(object):
    
    def __init__(self):
        self._thumbprint = None
        self._thumbprint_algorithm = None
        self._url = None
        self._state = None
        self._state_transition_time = None
        self._previous_state = None
        self._previous_state_transition_time = None
        self._data = None
        self._certificate_format = None
        self._password = None
        self._public_data = None
        self._delete_certificate_error = None
    
    @property
    def certificate_format(self):
        return self._certificate_format
    
    @certificate_format.setter 
    def certificate_format(self, value):
        self._certificate_format = value
    
    @property
    def data(self):
        return self._data
    
    @data.setter 
    def data(self, value):
        self._data = value
    
    @property
    def delete_certificate_error(self):
        return self._delete_certificate_error
    
    @delete_certificate_error.setter 
    def delete_certificate_error(self, value):
        self._delete_certificate_error = value
    
    @property
    def password(self):
        return self._password
    
    @password.setter 
    def password(self, value):
        self._password = value
    
    @property
    def previous_state(self):
        return self._previous_state
    
    @previous_state.setter 
    def previous_state(self, value):
        self._previous_state = value
    
    @property
    def previous_state_transition_time(self):
        return self._previous_state_transition_time
    
    @previous_state_transition_time.setter 
    def previous_state_transition_time(self, value):
        self._previous_state_transition_time = value
    
    @property
    def public_data(self):
        return self._public_data
    
    @public_data.setter 
    def public_data(self, value):
        self._public_data = value
    
    @property
    def state(self):
        return self._state
    
    @state.setter 
    def state(self, value):
        self._state = value
    
    @property
    def state_transition_time(self):
        return self._state_transition_time
    
    @state_transition_time.setter 
    def state_transition_time(self, value):
        self._state_transition_time = value
    
    @property
    def thumbprint(self):
        return self._thumbprint
    
    @thumbprint.setter 
    def thumbprint(self, value):
        self._thumbprint = value
    
    @property
    def thumbprint_algorithm(self):
        return self._thumbprint_algorithm
    
    @thumbprint_algorithm.setter 
    def thumbprint_algorithm(self, value):
        self._thumbprint_algorithm = value
    
    @property
    def url(self):
        return self._url
    
    @url.setter 
    def url(self, value):
        self._url = value