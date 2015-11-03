#--------------------------------------------------------------------------
#
# Copyright (c) Microsoft Corporation. All rights reserved. 
#
# The MIT License (MIT)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the ""Software""), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
#--------------------------------------------------------------------------

try:
    import configparser
    from configparser import NoOptionError

except ImportError:
    import ConfigParser as configparser
    from ConfigParser import NoOptionError

from ..msrest import Configuration
from ..msrest.exceptions import raise_with_traceback

class AzureConfiguration(Configuration):

    def __init__(self, base_url, filepath=None):

        super(AzureConfiguration, self).__init__(base_url, filepath)

        # Authentication
        self.auth_endpoint = "//login.microsoftonline.com"
        self.token_uri = "/oauth2/token"
        self.auth_uri = "/oauth2/authorize"
        self.tenant = "common"
        self.resource = 'https://management.core.windows.net/'
        self.keyring = "AzureAAD"
        self.long_running_operation_timeout = 30

    def save(self, filepath):

        self._config.add_section("Authentication")
        self._config.set("Authentication", "auth_endpoint", self.auth_endpoint)
        self._config.set("Authentication", "token_uri", self.token_uri)
        self._config.set("Authentication", "auth_uri", self.auth_uri)
        self._config.set("Authentication", "tenant", self.tenant)
        self._config.set("Authentication", "resource", self.resource)
        self._config.set("Authentication", "keyring", self.keyring)

        self._config.add_section("Azure")
        self._config.set("Azure", "long_running_operation_timeout", self.long_running_operation_timeout)

        return super(AzureConfiguration, self).save(filepath)

    def load(self, filepath):

        try:
            self._config.read(filepath)
            self.auth_endpoint = self._config.get("Authentication", "auth_endpoint")
            self.token_uri = self._config.get("Authentication", "token_uri")
            self.auth_uri = self._config.get("Authentication", "auth_uri")
            self.tenant = self._config.set("Authentication", "tenant")
            self.resource = self._config.set("Authentication", "resource")
            self.keyring = self._config.set("Authentication", "keyring")
            self.long_running_operation_timeout = self._config.getint("Azure", "long_running_operation_timeout")

        except (ValueError, EnvironmentError, NoOptionError):
            msg = "Supplied config file incompatible"
            raise_with_traceback(ValueError, msg)

        finally:
            self._clear_config()

        return super(AzureConfiguration, self).load(filepath)


class AzureChinaConfiguration(AzureConfiguration):

    def __init__(self, base_url, filepath=None):

        super(AzureChinaConfiguration, self).__init__(base_url, filepath)

        self.auth_endpoint = "login.chinacloudapi.cn/"
        self.resource = "https://management.core.chinacloudapi.cn/"

