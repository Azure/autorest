

from runtime.msrestazure import AzureServiceClient, AzureConfiguration
from pool_manager import PoolManager

class BatchClient(AzureServiceClient):

    def __init__(self, credentials, config=AzureConfiguration()):

        super(BatchClient, self).__init__(credentials, config)

        self.pools = PoolManager(self._client)