
from runtime.msrestazure import AzureConfiguration

class BatchConfiguration(AzureConfiguration):

    def __init__(self, base_url=None, filepath=None):

        super(BatchConfiguration, self).__init__(base_url, filepath)

        self.api_version = '2015-06-01.2.0'
        self.request_timeout = '30'