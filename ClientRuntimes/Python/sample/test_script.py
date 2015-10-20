
from sample import BatchClient, BatchException
from sample import SharedKeyCredentials
from sample import AzureConfiguration

from uuid import uuid4

batch_url = "" # Insert Batch service URL
account = "" # Insert account name
key = "" # Insert shared key

creds = SharedKeyCredentials(account, key)
config = AzureConfiguration(batch_url)

config.log_dir = "D:\\TestData"
config.log_level = 10

client = BatchClient(creds, config)

try:
    new_pool = client.pools.pool(name="MyTestPool")
    new_pool.vm_size="small"
    new_pool.os_family ="4"
    new_pool.target_dedicated = 1
    new_pool.id = str(uuid4())
    client.pools.add(new_pool)

except BatchException as err:
    print("{0}: {1}".format(err.error, err.message))


try:
    pools = client.pools.list()
    all_pools =  [p for p in pools]

    first_pool = all_pools[0]
    print(p.os_family)
    print(p.name)
    print(p.scheduling_policy.node_fill_type)

except BatchException as err:
    print("{0}: {1}".format(err.error, err.message))

