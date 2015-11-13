#--------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
# 
# Code generated by Microsoft (R) AutoRest Code Generator 0.13.0.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.
#--------------------------------------------------------------------------


from msrest import ServiceClient, Configuration
from msrest import Serializer, Deserializer
from msrest.exceptions import (
    SerializationError,
    DeserializationError,
    TokenExpiredError,
    ClientRequestError,
    HttpOperationError)
from .operations.implicit_operations import ImplicitOperations
from .operations.explicit_operations import ExplicitOperations
import models

class AutoRestRequiredOptionalTestServiceConfiguration(Configuration):

    def __init__(self, requiredglobalpath, requiredglobalquery, base_url=None, filepath=None):

        if not base_url:
            base_url = 'http://localhost'

        super(AutoRestRequiredOptionalTestServiceConfiguration, self).__init__(None, base_url, filepath)

        self.requiredglobalpath = requiredglobalpath;
        self.requiredglobalquery = requiredglobalquery;


class AutoRestRequiredOptionalTestService(object):

    def __init__(self, config):

        self._client = ServiceClient(config) 

        client_models = {k:v for k,v in models.__dict__.items() if isinstance(v, type)}
        self._serialize = Serializer()
        self._deserialize = Deserializer(client_models)

        self.config = config
        self.implicit = ImplicitOperations(self._client, self.config, self._serialize, self._deserialize)
        self.explicit = ExplicitOperations(self._client, self.config, self._serialize, self._deserialize)

