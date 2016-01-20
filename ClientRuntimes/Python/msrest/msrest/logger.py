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

import logging
from logging import handlers
import os
import re
import types

DEFAULT_LOG_NAME = "ms-client-runtime"
LOGGER = None
STDOUT_HANDLER = None
FILE_HANDLER = None


def check_invalid_directory(dirname):
    """Check validity of directory for file log.

    :param str dirname: Directory where log will be created.
    :raises: ValueError if directory cannot be written to.
    """
    try:
        if not os.path.isdir(dirname):
            os.mkdir(dirname)

        with open(os.path.join(dirname, "ms_test"), 'w') as test_file:
            test_file.write("All good to go!")

        os.remove(os.path.join(dirname, "ms_test"))
    except (IOError, OSError, EnvironmentError) as err:
        error = "Log directory {!r} cannot be accessed: {!r}"
        raise ValueError(error.format(dirname, err))


def set_stream_handler(logger, format_str):
    """Set log console handler.
    Any existing console handlers will be removed, and if format_str
    is None, no handler will be added.

    :param Logger logger: Logger object being configured.
    :param str format_str: Log statement formatting string.
    :returns: format_str
    """
    global STDOUT_HANDLER
    if STDOUT_HANDLER:
        logger.removeHandler(STDOUT_HANDLER)

    if format_str:
        STDOUT_HANDLER = logging.StreamHandler()
        formatter = logging.Formatter(str(format_str))
        STDOUT_HANDLER.setFormatter(formatter)
        logger.addHandler(STDOUT_HANDLER)
    else:
        STDOUT_HANDLER = None
    return format_str


def set_file_handler(logger, file_dir, format_str):
    """Set log file handler.
    Any existing console handlers will be removed, and if either
    format_str or file_dir is None, no handler will be added.
    If an existing log file has reached 10mb in size, it will be 'archived'
    (renamed) and a new log file started.

    :param Logger logger: Logger object being configured.
    :param str file_dir: Directory where file log will be written.
    :param str format_str: Log statement formatting string.
    :returns: format_str
    :raises: ValueError if log directory is invalid.
    """
    global FILE_HANDLER
    if FILE_HANDLER:
        logger.removeHandler(FILE_HANDLER)

    if format_str and file_dir:
        check_invalid_directory(file_dir)
        logfile = os.path.join(file_dir, logger.name + '.log')
        FILE_HANDLER = handlers.RotatingFileHandler(
            logfile, mode='a', maxBytes=10485760, backupCount=10)
        formatter = logging.Formatter(str(format_str))
        FILE_HANDLER.setFormatter(formatter)
        logger.addHandler(FILE_HANDLER)
    else:
        FILE_HANDLER = None
    return format_str


def set_log_level(logger, level):
    """Set logging verbosity.

    :param Logger logger: Logger object being configured.
    :param str/int level: Logging level, can be integer in
     {logging.DEBUG, logging.INFO, logging.WARNING, logging.ERROR,
     logging.CRITICAL} or a string in {'debug', 'info', 'warning',
     'error', 'critical'}.
    :returns: Current logging level as an int.
    :raises: ValueError if supplied logging level is invalid.
    """
    levels = {'debug': logging.DEBUG,
              'info': logging.INFO,
              'warning': logging.WARNING,
              'error': logging.ERROR,
              'critical': logging.CRITICAL}
    try:
        level = levels[level.lower()]
    except (AttributeError, KeyError):
        pass

    logger.setLevel(level)
    return logger.level


def setup_logger(config):
    """Create and configure new logger for client session.

    :params config: Configuration object.
    :rtype: Logger
    """
    global LOGGER
    if LOGGER and LOGGER.name == config.log_name:
        return LOGGER

    logger = logging.getLogger(config.log_name)
    if config.stream_log:
        set_stream_handler(logger, config.stream_log)
    if config.file_log:
        set_file_handler(logger, config.log_dir, config.file_log)

    set_log_level(logger, config.log_level)
    LOGGER = logger
    return logger


def log_request(adapter, request, *args, **kwargs):
    """Log a client request.

    :param ClientHTTPAdapter adapter: Adapter making the request.
    :param requests.Request request: The request object.
    """
    try:
        LOGGER.debug("Request URL: %r", request.url)
        LOGGER.debug("Request method: %r", request.method)
        LOGGER.debug("Request headers:")
        for header, value in request.headers.items():
            LOGGER.debug("    %r: %r", header, value)
        LOGGER.debug("Request body:")

        # We don't want to log the binary data of a file upload.
        if isinstance(request.body, types.GeneratorType):
            LOGGER.debug("File upload")
        else:
            LOGGER.debug(str(request.body))
    except Exception as err:
        LOGGER.debug("Failed to log request: %r", err)


def log_response(adapter, request, response, *args, **kwargs):
    """Log a server response.

    :param ClientHTTPAdapter adapter: Adapter making the request.
    :param requests.Request request: The request object.
    :param requests.Response response: The response object.
    """
    try:
        result = kwargs['result']
        LOGGER.debug("Response status: %r", result.status_code)
        LOGGER.debug("Response headers:")
        for header, value in result.headers.items():
            LOGGER.debug("    %r: %r", header, value)

        # We don't want to log binary data if the response is a file.
        LOGGER.debug("Response content:")
        pattern = re.compile(r'attachment; ?filename=["\w.]+', re.IGNORECASE)
        header = result.headers.get('content-disposition')

        if header and pattern.match(header):
            filename = header.partition('=')[2]
            LOGGER.debug("File attachments: " + filename)
        elif result.headers.get("content-type", "").endswith("octet-stream"):
            LOGGER.debug("Body contains binary data.")
        elif result.headers.get("content-type", "").startswith("image"):
            LOGGER.debug("Body contains image data.")
        # elif result.headers.get("transfer-encoding") == 'chunked':
        #    LOGGER.debug("Body contains chunked data.")
        else:
            LOGGER.debug(str(result.content))
        return result
    except Exception as err:
        LOGGER.debug("Failed to log response: " + repr(err))
        return kwargs['result']
