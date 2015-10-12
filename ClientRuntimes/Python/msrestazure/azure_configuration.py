from msrest import Configration

class AzureConfiguration(Configration):

    def __init__(self, filepath=None):

        super(AzureConfiguration, self).__init__(filepath)

        # Authentication
        self.auth_endpoint = "login.windows.net/"
        self.token_uri = "/oauth2/token"
        self.auth_uri = "/oauth2/authorize"
        self.tenant = "common"
        self.keyring = "AzureAAD"
