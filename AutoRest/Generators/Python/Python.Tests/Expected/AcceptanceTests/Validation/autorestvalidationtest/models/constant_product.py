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


class ConstantProduct(Model):
    """
    The product documentation.

    :param const_property: Constant string. Default value: "constant" .
    :type const_property: str
    :param const_property2: Constant string2. Default value: "constant2" .
    :type const_property2: str
    """ 

    _validation = {
        'const_property': {'required': True, 'constant': True},
        'const_property2': {'required': True, 'constant': True},
    }

    _attribute_map = {
        'const_property': {'key': 'constProperty', 'type': 'str'},
        'const_property2': {'key': 'constProperty2', 'type': 'str'},
    }

    def __init__(self):
        self.const_property = "constant"
        self.const_property2 = "constant2"
