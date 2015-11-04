

from runtime.msrest import ServiceClient
from runtime.msrestazure import AzureConfiguration
from .operations.pool_operations import PoolManager
from .models import *


class BatchClient(ServiceClient):

    def __init__(self, credentials, config):

        super(BatchClient, self).__init__(credentials, config)

        self.pools = PoolManager(self, config)

