# --------------------------------------------------------------------------
#
# Copyright (c) Microsoft Corporation. All rights reserved.
#
# The MIT License (MIT)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the ""Software""), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#
# --------------------------------------------------------------------------


try:
    import configparser
    from configparser import NoOptionError
except ImportError:
    import ConfigParser as configparser
    from ConfigParser import NoOptionError

from . import logger
from .exceptions import raise_with_traceback
from .pipeline import (
    ClientRetryPolicy,
    ClientRedirectPolicy,
    ClientProxies,
    ClientConnection)


class Configuration(object):
    """Client configuration.

    :param str baseurl: REST API base URL.
    :param str filepath: Path to existing config file (optional).
    """

    def __init__(self, base_url, filepath=None):
        # Service
        self.base_url = base_url

        # Logging configuration
        self._log_name = logger.DEFAULT_LOG_NAME
        self._log_dir = None
        self._stream_logging = self._file_logging = \
            "%(asctime)-15s [%(levelname)s] %(module)s: %(message)s"
        self._level = 30
        self._log = logger.setup_logger(self)

        # Communication configuration
        self.connection = ClientConnection(self._log_name)

        # ProxyConfiguration
        self.proxies = ClientProxies(self._log_name)

        # Retry configuration
        self.retry_policy = ClientRetryPolicy(self._log_name)

        # Redirect configuration
        self.redirect_policy = ClientRedirectPolicy(self._log_name)

        # User-Agent Header
        self.user_agent = "msrest/0.0.1"

        self._config = configparser.ConfigParser()
        self._config.optionxform = str

        if filepath:
            self.load(filepath)

    @property
    def log_level(self):
        """Current logging level (int)."""
        return self._level

    @log_level.setter
    def log_level(self, value):
        val = logger.set_log_level(self._log, value)
        self._level = val

    @property
    def stream_log(self):
        """Format string for console logging. Set to 'None' to disable
        console logging.
        """
        return self._stream_logging

    @stream_log.setter
    def stream_log(self, value):
        val = logger.set_stream_handler(self._log, value)
        self._stream_logging = val

    @property
    def file_log(self):
        """Format string for file logging. Set to 'None' to
        disable file logging.
        """
        return self._file_logging

    @file_log.setter
    def file_log(self, value):
        val = logger.set_file_handler(self._log, self._log_dir, value)
        self._file_logging = val

    @property
    def log_dir(self):
        """Directory where log files will be stored."""
        return self._log_dir

    @log_dir.setter
    def log_dir(self, value):
        logger.set_file_handler(self._log, value, self._file_logging)
        self._log_dir = value

    @property
    def log_name(self):
        """Name of the session logger."""
        return self._log_name

    @log_name.setter
    def log_name(self, value):
        self._log_name = value
        self._log = logger.setup_logger(self)

    def _clear_config(self):
        """Clearout config object in memory."""
        for section in self._config.sections():
            self._config.remove_section(section)

    def save(self, filepath):
        """Save current configuration to file.

        :param str filepath: Path to file where settings will be saved.
        :raises: ValueError if supplied filepath cannot be written to.
        :rtype: None
        """
        sections = [
            "Logging",
            "Connection",
            "Proxies",
            "RetryPolicy",
            "RedirectPolicy"]
        for section in sections:
            self._config.add_section(section)

        self._config.set("Logging", "log_name", self._log_name)
        self._config.set("Logging", "log_dir", self._log_dir)
        self._config.set("Logging", "stream_format", self._stream_logging)
        self._config.set("Logging", "file_format", self._file_logging)
        self._config.set("Logging", "level", self._level)

        self._config.set("Connection", "base_url", self.base_url)
        self._config.set("Connection", "timeout", self.connection.timeout)
        self._config.set("Connection", "verify", self.connection.verify)
        self._config.set("Connection", "cert", self.connection.cert)

        self._config.set("Proxies", "proxies", self.proxies.proxies)
        self._config.set("Proxies", "env_settings",
                         self.proxies.use_env_settings)

        self._config.set("RetryPolicy", "retries", self.retry_policy.retries)
        self._config.set("RetryPolicy", "backoff_factor",
                         self.retry_policy.backoff_factor)
        self._config.set("RetryPolicy", "max_backoff",
                         self.retry_policy.max_backoff)

        self._config.set("RedirectPolicy", "allow", self.redirect_policy.allow)
        self._config.set("RedirectPolicy", "max_redirects",
                         self.redirect_policy.max_redirects)
        try:
            with open(filepath, 'w') as configfile:
                self._config.write(configfile)
        except (KeyError, EnvironmentError):
            error = "Supplied config filepath invalid."
            raise_with_traceback(ValueError, error)
        finally:
            self._clear_config()

    def load(self, filepath):
        """Load configuration from existing file.

        :param str filepath: Path to existing config file.
        :raises: ValueError if supplied config file is invalid.
        :rtype: None
        """
        try:
            self._config.read(filepath)

            self._log_name = \
                self._config.get("Logging", "log_name")
            self._log_dir = \
                self._config.get("Logging", "log_dir")
            self._stream_logging = \
                self._config.get("Logging", "stream_format", raw=True)
            self._file_logging = \
                self._config.get("Logging", "file_format", raw=True)
            self._level = \
                self._config.getint("Logging", "level")

            self.base_url = \
                self._config.get("Connection", "base_url")
            self.connection.timeout = \
                self._config.getint("Connection", "timeout")
            self.connection.verify = \
                self._config.getboolean("Connection", "verify")
            self.connection.cert = \
                self._config.get("Connection", "cert")

            self.proxies.proxies = \
                eval(self._config.get("Proxies", "proxies"))
            self.proxies.use_env_settings = \
                self._config.getboolean("Proxies", "env_settings")

            self.retry_policy.retries = \
                self._config.getint("RetryPolicy", "retries")
            self.retry_policy.backoff_factor = \
                self._config.getfloat("RetryPolicy", "backoff_factor")
            self.retry_policy.max_backoff = \
                self._config.getint("RetryPolicy", "max_backoff")

            self.redirect_policy.allow = \
                self._config.getboolean("RedirectPolicy", "allow")
            self.redirect_policy.max_redirects = \
                self._config.set("RedirectPolicy", "max_redirects")

            self._log = logger.setup_logger(self)
        except (ValueError, EnvironmentError, NoOptionError):
            error = "Supplied config file incompatible."
            raise_with_traceback(ValueError, error)
        finally:
            self._clear_config()
