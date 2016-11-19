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

from .shark import Shark


class Sawshark(Shark):
    """Sawshark.

    :param species:
    :type species: str
    :param length:
    :type length: float
    :param siblings:
    :type siblings: list of :class:`Fish
     <fixtures.acceptancetestsbodycomplex.models.Fish>`
    :param fishtype: Polymorphic Discriminator
    :type fishtype: str
    :param age:
    :type age: int
    :param birthday:
    :type birthday: datetime
    :param picture:
    :type picture: bytearray
    """

    _validation = {
        'length': {'required': True},
        'fishtype': {'required': True},
        'birthday': {'required': True},
    }

    _attribute_map = {
        'species': {'key': 'species', 'type': 'str'},
        'length': {'key': 'length', 'type': 'float'},
        'siblings': {'key': 'siblings', 'type': '[Fish]'},
        'fishtype': {'key': 'fishtype', 'type': 'str'},
        'age': {'key': 'age', 'type': 'int'},
        'birthday': {'key': 'birthday', 'type': 'iso-8601'},
        'picture': {'key': 'picture', 'type': 'bytearray'},
    }

    def __init__(self, length, birthday, species=None, siblings=None, age=None, picture=None):
        super(Sawshark, self).__init__(species=species, length=length, siblings=siblings, age=age, birthday=birthday)
        self.picture = picture
        self.fishtype = 'sawshark'
