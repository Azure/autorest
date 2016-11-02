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


class FirstParameterGroup(Model):
    """Additional parameters for a set of operations, such as:
    ParameterGrouping_post_multi_param_groups,
    ParameterGrouping_post_shared_parameter_group_object.

    :param header_one:
    :type header_one: str
    :param query_one: Query parameter with default. Default value: 30 .
    :type query_one: int
    """ 

    def __init__(self, header_one=None, query_one=30):
        self.header_one = header_one
        self.query_one = query_one
