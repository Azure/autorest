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

from .constant_product import ConstantProduct
from msrest.serialization import Model


class Product(Model):
    """The product documentation.

    Variables are only populated by the server, and will be ignored when
    sending a request.

    :param display_names: Non required array of unique items from 0 to 6
     elements.
    :type display_names: list of str
    :param capacity: Non required int betwen 0 and 100 exclusive.
    :type capacity: int
    :param image: Image URL representing the product.
    :type image: str
    :param child:
    :type child: :class:`ChildProduct
     <Fixtures.AcceptanceTestsValidation.models.ChildProduct>`
    :ivar const_child:
    :vartype const_child: :class:`ConstantProduct
     <Fixtures.AcceptanceTestsValidation.models.ConstantProduct>`
    :ivar const_int: Constant int. Default value: 0 .
    :vartype const_int: int
    :ivar const_string: Constant string. Default value: "constant" .
    :vartype const_string: str
    :param const_string_as_enum: Constant string as Enum. Possible values
     include: 'constant_string_as_enum'
    :type const_string_as_enum: str or :class:`EnumConst
     <Fixtures.AcceptanceTestsValidation.models.EnumConst>`
    """ 

    _validation = {
        'display_names': {'max_items': 6, 'min_items': 0, 'unique': True},
        'capacity': {'maximum_ex': 100, 'minimum_ex': 0},
        'image': {'pattern': 'http://\w+'},
        'child': {'required': True},
        'const_child': {'required': True, 'constant': True},
        'const_int': {'required': True, 'constant': True},
        'const_string': {'required': True, 'constant': True},
    }

    _attribute_map = {
        'display_names': {'key': 'display_names', 'type': '[str]'},
        'capacity': {'key': 'capacity', 'type': 'int'},
        'image': {'key': 'image', 'type': 'str'},
        'child': {'key': 'child', 'type': 'ChildProduct'},
        'const_child': {'key': 'constChild', 'type': 'ConstantProduct'},
        'const_int': {'key': 'constInt', 'type': 'int'},
        'const_string': {'key': 'constString', 'type': 'str'},
        'const_string_as_enum': {'key': 'constStringAsEnum', 'type': 'EnumConst'},
    }

    const_child = ConstantProduct()

    const_int = 0

    const_string = "constant"

    def __init__(self, child, display_names=None, capacity=None, image=None, const_string_as_enum=None):
        self.display_names = display_names
        self.capacity = capacity
        self.image = image
        self.child = child
        self.const_string_as_enum = const_string_as_enum
