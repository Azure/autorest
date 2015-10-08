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

import requests

"""
Wrappers for Resuests unprepared request objects
"""

def get(config):
    request = requests.Request()
    #TODO: Other defaults to set here
    request.method = 'GET'
    return request

def put(config):
    request = requests.Request()
    #TODO: Other defaults to set here
    request.method = 'PUT'
    return request

def post(config):
    request = requests.Request()
    #TODO: Other defaults to set here
    request.method = 'POST'
    return request

def head(config):
    request = requests.Request()
    #TODO: Other defaults to set here
    request.method = 'HEAD'
    return request

def delete(config):
    request = requests.Request()
    #TODO: Other defaults to set here
    request.method = 'DELETE'
    return request

def patch(config):
    request = requests.Request()
    #TODO: Other defaults to set here
    request.method = 'PATCH'
    return request

def merge(config):
    request = requests.Request()
    #TODO: Other defaults to set here
    request.method = 'MERGE'
    return request


