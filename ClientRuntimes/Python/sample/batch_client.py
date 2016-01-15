

from msrest import ServiceClient
from msrestazure import AzureConfiguration
from operations.pool_operations import PoolManager
from msrest.serialization import Serializer, Deserializer

import models   


class BatchClient(object):

    def __init__(self, credentials, config):

        self._client = ServiceClient(credentials, config)
        
        client_models = {k:v for k,v in models.__dict__.items() if isinstance(v, type)}
        self._serialize = Serializer()
        self._deserialize = Deserializer(client_models)

        self.config = config
        self.pools = PoolManager(self._client, self.config, self._serialize, self._deserialize)