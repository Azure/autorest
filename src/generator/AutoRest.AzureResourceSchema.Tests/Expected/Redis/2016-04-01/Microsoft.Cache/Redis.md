# Microsoft.Cache/Redis template reference
API Version: 2016-04-01
## Template format

To create a Microsoft.Cache/Redis resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Cache/Redis",
  "apiVersion": "2016-04-01",
  "location": "string",
  "tags": {},
  "properties": {
    "redisVersion": "string",
    "sku": {
      "name": "string",
      "family": "string",
      "capacity": "integer"
    },
    "redisConfiguration": {},
    "enableNonSslPort": boolean,
    "tenantSettings": {},
    "shardCount": "integer",
    "subnetId": "string",
    "staticIP": "string"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Cache/Redis" />
### Microsoft.Cache/Redis object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Cache/Redis |
|  apiVersion | enum | Yes | 2016-04-01 |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | Redis cache properties. - [RedisProperties object](#RedisProperties) |


<a id="RedisProperties" />
### RedisProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  redisVersion | string | No | RedisVersion parameter has been deprecated. As such, it is no longer necessary to provide this parameter and any value specified is ignored. |
|  sku | object | Yes | What sku of redis cache to deploy. - [Sku object](#Sku) |
|  redisConfiguration | object | No | All Redis Settings. Few possible keys: rdb-backup-enabled,rdb-storage-connection-string,rdb-backup-frequency,maxmemory-delta,maxmemory-policy,notify-keyspace-events,maxmemory-samples,slowlog-log-slower-than,slowlog-max-len,list-max-ziplist-entries,list-max-ziplist-value,hash-max-ziplist-entries,hash-max-ziplist-value,set-max-intset-entries,zset-max-ziplist-entries,zset-max-ziplist-value etc. |
|  enableNonSslPort | boolean | No | If the value is true, then the non-ssl redis server port (6379) will be enabled. |
|  tenantSettings | object | No | tenantSettings |
|  shardCount | integer | No | The number of shards to be created on a Premium Cluster Cache. |
|  subnetId | string | No | The full resource ID of a subnet in a virtual network to deploy the redis cache in. Example format: /subscriptions/{subid}/resourceGroups/{resourceGroupName}/Microsoft.{Network|ClassicNetwork}/VirtualNetworks/vnet1/subnets/subnet1 |
|  staticIP | string | No | Required when deploying a redis cache inside an existing Azure Virtual Network. |


<a id="Sku" />
### Sku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | Yes | What type of redis cache to deploy. Valid values: (Basic, Standard, Premium). - Basic, Standard, Premium |
|  family | enum | Yes | Which family to use. Valid values: (C, P). - C or P |
|  capacity | integer | Yes | What size of redis cache to deploy. Valid values: for C family (0, 1, 2, 3, 4, 5, 6), for P family (1, 2, 3, 4) |

