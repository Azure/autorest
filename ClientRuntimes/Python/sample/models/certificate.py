
class Certificate(object):
    
    _attribute_map = {
            'thumbprint':{'key':'thumbprint', 'type':'str'},
            'thumbprint_algorithm': {'key':'thumbprintAlgorithm', 'type':'str'},
            'url': {'key':'url', 'type':'str'},
            'state': {'key':'state', 'type':'str'},
            'state_transition_time': {'key':'stateTransitionTime', 'type':'iso-date'},
            'previous_state': {'key':'previousState', 'type':'str'},
            'previous_state_transition_time': {'key':'previousStateTransitionTime', 'type':'iso-date'},
            'data': {'key':'data', 'type':'str'},
            'certificate_format': {'key':'certificateFormat', 'type':'str'},
            'password': {'key':'password', 'type':'str'},
            'public_data': {'key':'publicData', 'type':'str'},
            'delete_certificate_error': {'key':'deleteCertificateError', 'type':'DeleteCertificateError'},
        }

    def __init__(self, **kwargs):

        for k in kwargs:
            if hasattr(self, k):
                setattr(self, k, kwargs[k])