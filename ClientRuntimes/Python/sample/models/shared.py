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
    