
from runtime.msrestazure import AzureConfiguration
try:
    import configparser
    from configparser import NoOptionError

except ImportError:
    import ConfigParser as configparser
    from ConfigParser import NoOptionError

class BatchConfiguration(AzureConfiguration):

    def __init__(self, base_url, filepath=None):

        super(BatchConfiguration, self).__init__(base_url, filepath)

        self.api_version = '2015-06-01.2.0'
        self.request_timeout = '30'

    def save(self, filepath):

        self._config.add_section("Batch")
        self._config.set("Batch", "api_version", self.api_version)
        self._config.set("Batch", "request_timeout", self.request_timeout)
        return super(BatchConfiguration, self).save(filepath)

    def load(self, filepath):

        try:
            self._config.read(filepath)
            self.api_version = self._config.get("Batch", "api_version")
            self.request_timeout = self._config.get("Batch", "request_timeout")

        except (ValueError, EnvironmentError, NoOptionError) as err:
            raise ValueError(
                "Supplied config file incompatible: {0}".format(err))

        finally:
            self._clear_config()

        return super(BatchConfiguration, self).load(filepath)