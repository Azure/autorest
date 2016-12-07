# Microsoft.Cache template schema

Creates a Microsoft.Cache resource.

## Schema format

To create a Microsoft.Cache, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.Cache/Redis",
  "apiVersion": "2016-04-01",
  "location": "string",
  "properties": {
    "redisVersion": "string",
    "sku": {
      "name": "string",
      "family": "string",
      "capacity": "integer"
    },
    "redisConfiguration": {},
    "enableNonSslPort": "boolean",
    "tenantSettings": {},
    "shardCount": "integer",
    "subnetId": "string",
    "staticIP": "string"
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="Redis" />
## Redis object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Cache/Redis**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  location | Yes | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[RedisProperties object](#RedisProperties)<br /><br />Redis cache properties. |


<a id="RedisProperties" />
## RedisProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  redisVersion | No | string<br /><br />RedisVersion parameter has been deprecated. As such, it is no longer necessary to provide this parameter and any value specified is ignored. |
|  sku | Yes | object<br />[Sku object](#Sku)<br /><br />What sku of redis cache to deploy. |
|  redisConfiguration | No | object<br /><br />All Redis Settings. Few possible keys: rdb-backup-enabled,rdb-storage-connection-string,rdb-backup-frequency,maxmemory-delta,maxmemory-policy,notify-keyspace-events,maxmemory-samples,slowlog-log-slower-than,slowlog-max-len,list-max-ziplist-entries,list-max-ziplist-value,hash-max-ziplist-entries,hash-max-ziplist-value,set-max-intset-entries,zset-max-ziplist-entries,zset-max-ziplist-value etc. |
|  enableNonSslPort | No | boolean<br /><br />If the value is true, then the non-ssl redis server port (6379) will be enabled. |
|  tenantSettings | No | object<br /><br />tenantSettings |
|  shardCount | No | integer<br /><br />The number of shards to be created on a Premium Cluster Cache. |
|  subnetId | No | string<br /><br />The full resource ID of a subnet in a virtual network to deploy the redis cache in. Example format: /subscriptions/{subid}/resourceGroups/{resourceGroupName}/Microsoft.{Network|ClassicNetwork}/VirtualNetworks/vnet1/subnets/subnet1 |
|  staticIP | No | string<br /><br />Required when deploying a redis cache inside an existing Azure Virtual Network. |


<a id="Sku" />
## Sku object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | Yes | enum<br />**Basic**, **Standard**, **Premium**<br /><br />What type of redis cache to deploy. Valid values: (Basic, Standard, Premium). |
|  family | Yes | enum<br />**C** or **P**<br /><br />Which family to use. Valid values: (C, P). |
|  capacity | Yes | integer<br /><br />What size of redis cache to deploy. Valid values: for C family (0, 1, 2, 3, 4, 5, 6), for P family (1, 2, 3, 4) |

