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

from msrest.service_client import ServiceClient
from msrest import Configuration, Serializer, Deserializer
from .version import VERSION
from .operations.basic_operations_operations import BasicOperationsOperations
from .operations.primitive_operations import PrimitiveOperations
from .operations.array_operations import ArrayOperations
from .operations.dictionary_operations import DictionaryOperations
from .operations.inheritance_operations import InheritanceOperations
from .operations.polymorphism_operations import PolymorphismOperations
from .operations.polymorphicrecursive_operations import PolymorphicrecursiveOperations
from .operations.readonlyproperty_operations import ReadonlypropertyOperations
from . import models


class AutoRestComplexTestServiceConfiguration(Configuration):
    """Configuration for AutoRestComplexTestService
    Note that all parameters used to create this instance are saved as instance
    attributes.

    :param api_version: API ID.
    :type api_version: str
    :param str base_url: Service URL
    :param str filepath: Existing config
    """

    def __init__(
            self, api_version, base_url=None, filepath=None):

        if api_version is None:
            raise ValueError("Parameter 'api_version' must not be None.")
        if not isinstance(api_version, str):
            raise TypeError("Parameter 'api_version' must be str.")
        if not base_url:
            base_url = 'http://localhost'

        super(AutoRestComplexTestServiceConfiguration, self).__init__(base_url, filepath)

        self.add_user_agent('autorestcomplextestservice/{}'.format(VERSION))

        self.api_version = api_version


class AutoRestComplexTestService(object):
    """Test Infrastructure for AutoRest

    :ivar config: Configuration for client.
    :vartype config: AutoRestComplexTestServiceConfiguration

    :ivar basic_operations: BasicOperations operations
    :vartype basic_operations: .operations.BasicOperationsOperations
    :ivar primitive: Primitive operations
    :vartype primitive: .operations.PrimitiveOperations
    :ivar array: Array operations
    :vartype array: .operations.ArrayOperations
    :ivar dictionary: Dictionary operations
    :vartype dictionary: .operations.DictionaryOperations
    :ivar inheritance: Inheritance operations
    :vartype inheritance: .operations.InheritanceOperations
    :ivar polymorphism: Polymorphism operations
    :vartype polymorphism: .operations.PolymorphismOperations
    :ivar polymorphicrecursive: Polymorphicrecursive operations
    :vartype polymorphicrecursive: .operations.PolymorphicrecursiveOperations
    :ivar readonlyproperty: Readonlyproperty operations
    :vartype readonlyproperty: .operations.ReadonlypropertyOperations

    :param api_version: API ID.
    :type api_version: str
    :param str base_url: Service URL
    :param str filepath: Existing config
    """

    def __init__(
            self, api_version, base_url=None, filepath=None):

        self.config = AutoRestComplexTestServiceConfiguration(api_version, base_url, filepath)
        self._client = ServiceClient(None, self.config)

        client_models = {k: v for k, v in models.__dict__.items() if isinstance(v, type)}
        self._serialize = Serializer(client_models)
        self._deserialize = Deserializer(client_models)

        self.basic_operations = BasicOperationsOperations(
            self._client, self.config, self._serialize, self._deserialize)
        self.primitive = PrimitiveOperations(
            self._client, self.config, self._serialize, self._deserialize)
        self.array = ArrayOperations(
            self._client, self.config, self._serialize, self._deserialize)
        self.dictionary = DictionaryOperations(
            self._client, self.config, self._serialize, self._deserialize)
        self.inheritance = InheritanceOperations(
            self._client, self.config, self._serialize, self._deserialize)
        self.polymorphism = PolymorphismOperations(
            self._client, self.config, self._serialize, self._deserialize)
        self.polymorphicrecursive = PolymorphicrecursiveOperations(
            self._client, self.config, self._serialize, self._deserialize)
        self.readonlyproperty = ReadonlypropertyOperations(
            self._client, self.config, self._serialize, self._deserialize)
