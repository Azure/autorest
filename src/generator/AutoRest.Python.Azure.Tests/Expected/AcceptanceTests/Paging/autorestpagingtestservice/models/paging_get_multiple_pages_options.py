# coding=utf-8
# --------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
#
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.
# --------------------------------------------------------------------------

from msrest.serialization import Model


class PagingGetMultiplePagesOptions(Model):
    """Additional parameters for the Paging_getMultiplePages operation.

    :param maxresults: Sets the maximum number of items to return in the
     response.
    :type maxresults: int
    :param timeout: Sets the maximum time that the server can spend
     processing the request, in seconds. The default is 30 seconds. Default
     value: 30 .
    :type timeout: int
    """ 

    def __init__(self, maxresults=None, timeout=30):
        self.maxresults = maxresults
        self.timeout = timeout
