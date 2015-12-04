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
    from configparser import NoOptionError

except ImportError:
    from ConfigParser import NoOptionError

from msrest import Configuration
from msrest.exceptions import raise_with_traceback


class AzureConfiguration(Configuration):

    def __init__(self, base_url, filepath=None):

        super(AzureConfiguration, self).__init__(base_url, filepath)

        self.long_running_operation_timeout = 30

    def save(self, filepath):

        self._config.add_section("Azure")
        self._config.set("Azure",
                         "long_running_operation_timeout",
                         self.long_running_operation_timeout)

        return super(AzureConfiguration, self).save(filepath)

    def load(self, filepath):

        try:
            self._config.read(filepath)
            self.long_running_operation_timeout = self._config.getint(
                "Azure", "long_running_operation_timeout")

        except (ValueError, EnvironmentError, NoOptionError):
            msg = "Supplied config file incompatible"
            raise_with_traceback(ValueError, msg)

        finally:
            self._clear_config()

        return super(AzureConfiguration, self).load(filepath)
