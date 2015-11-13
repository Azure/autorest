#--------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
# 
# Code generated by Microsoft (R) AutoRest Code Generator 0.13.0.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.
#--------------------------------------------------------------------------

from datetime import *

from msrest import ServiceClient, Configuration
from msrest import Serializer, Deserializer
from msrest.exceptions import (
    SerializationError,
    DeserializationError,
    TokenExpiredError,
    ClientRequestError,
    HttpOperationError)
from .operations.header_operations import HeaderOperations
import models

class AutoRestSwaggerBATHeaderServiceConfiguration(Configuration):

    def __init__(self, base_url=None, filepath=None):

        if not base_url:
            base_url = 'http://localhost'

        super(AutoRestSwaggerBATHeaderServiceConfiguration, self).__init__(base_url, filepath)


class AutoRestSwaggerBATHeaderService(object):

    def __init__(self, credentials, config):

        self._client = ServiceClient(credentials, config) 

        client_models = {k:v for k,v in models.__dict__.items() if isinstance(v, type)}
        self._serialize = Serializer()
        self._deserialize = Deserializer(client_models)

        self.config = config
        self.header = HeaderOperations(self._client, self.config, self._serialize, self._deserialize)

