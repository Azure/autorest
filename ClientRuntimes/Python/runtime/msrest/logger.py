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

import os
import shutil
import logging

LOGGER = None

def invalid_directory(dirname):
    """
    Check directory for file log.
    """
    try:
        if not os.path.isdir(dirname):
            os.mkdir(dirname)

        with open(os.path.join(dirname, "ms_test"), 'w') as test_file:
            test_file.write("All good to go!")

        os.remove(os.path.join(dirname, "ms_test"))
        return False

    except (IOError, OSError, EnvironmentError) as exp:
        return str(exp)

def set_stream_handler(logger, format_str):
    """
    Set log console handler.
    """

    current_handlers = [h for h in logger.handlers if isinstance(h, logging.StreamHandler)]
    for handler in current_handlers:
        logger.removeHandler(handler)

    if format_str:
        handler = logging.StreamHandler()
        formatter = logging.Formatter(str(format_str))

        handler.setFormatter(formatter)
        logger.addHandler(handler)

    return format_str

def set_file_handler(logger, file_dir, format_str):
    """
    Set log file handler.
    """

    current_handlers = [h for h in logger.handlers if isinstance(h, logging.FileHandler)]
    for handler in current_handlers:
        logger.removeHandler(handler)

    if not format_str or not file_dir:
        return format_str

    check = invalid_directory(file_dir)
    if check:
        raise ValueError("Log directory '{0}' cannot be accessed: {1}".format(file_dir, check))

    
    logfile = os.path.join(file_dir, logger.name + '.log')

    if os.path.isfile(logfile) and os.path.getsize(logfile) > 10485760:
        split_log = os.path.splitext(logfile)
        timestamp = time.strftime("%Y-%m-%d-%H-%M-%S")

        shutil.move(logfile, "{root}-{date}{ext}".format(
            root=split_log[0],
            date=timestamp,
            ext=split_log[1]))

    handler = logging.FileHandler(logfile)
    formatter = logging.Formatter(str(format_str))
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    return format_str

def set_log_level(logger, level):
    """
    Set logging verbosity.
    """
    levels = {'debug': 10,
              'info': 20,
              'warning': 30,
              'error': 40,
              'critical': 50}

    if isinstance(level, str) and level.lower() in levels:
            level = levels[level.lower()]

    try:
        logger.setLevel(level)

    except ValueError:
        raise

    return logger.level

def setup_logger(config):
    """
    Create and configure new logger for client session.
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

    try:
        LOGGER.debug("Request URL: {}".format(request.url))
        LOGGER.debug("Request method: {}".format(request.method))
        LOGGER.debug("Request headers:")
        for header, value in request.headers.items():
            LOGGER.debug("    {0}: {1}".format(header, value))
        LOGGER.debug("Request body:")
        LOGGER.debug(str(request.body))

    except Exception as err:
        LOGGER.debug("Failed to log request: '{}'".format(err))

def log_response(adapter, request, response, *args, **kwargs):

    try:
        result = kwargs['result']
        LOGGER.debug("Response status: {}".format(result.status_code))
        LOGGER.debug("Response headers:")
        for header, value in result.headers.items():
            LOGGER.debug("    {0}: {1}".format(header, value))
        LOGGER.debug("Response content:")
        LOGGER.debug(str(result.content))
        return result

    except Exception as err:
        LOGGER.debug("Failed to log response: '{0}'".format(err))
        return kwargs['result']