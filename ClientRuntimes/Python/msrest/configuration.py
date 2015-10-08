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

"""
Configuration of ServiceClient and session.
"""

import os
import tempfile

from .logger import *

class Configuration(object):
    
    def __init__(self):

        # Logging configuration
        self._log_name = "ms-client-runtime"
        self._log_dir = tempfile.tempdir
        self._stream_logging =  "%(asctime)-15s [%(levelname)s] %(module)s: %(message)s"
        self._file_logging =  "%(asctime)-15s [%(levelname)s] %(module)s: %(message)s"
        self._level = 30

        self._log = logger.setup_logger(self)

        # Communication configuration
        self.protocols = ['https://']

    @property
    def log_level(self):
        return self.level

    @log_level.setter
    def log_level(self, value):
        val = logger.set_log_level(self._log, value)
        self.level = val

    @property
    def stream_log(self):
        return self._stream_logging

    @stream_log.setter
    def stream_log(self, value):
        val = logger.set_stream_handler(self._log, value)
        self._stream_logging = val

    @property
    def file_log(self):
        return self._file_logging

    @file_log.setter
    def file_log(self, value):
        val = logger.set_file_handler(self._log, self._log_dir, value)
        self._file_logging = val

    @property
    def log_dir(self):
        return self._log_dir

    @log_dir.setter
    def log_dir(self, value):
        logger.set_file_handler(self._log, value, self._file_logging)
        self._log_dir = value

    @property
    def log_name(self):
        return self._log_name

    @log_name.setter
    def log_name(self, value):
        self._log = setup_logger(self)
        self._log_name = value
