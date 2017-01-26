# Microsoft.Web/hostingEnvironments template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.Web/hostingEnvironments resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Web/hostingEnvironments",
  "apiVersion": "2015-08-01",
  "id": "string",
  "name": "string",
  "kind": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "name": "string",
    "location": "string",
    "provisioningState": "string",
    "status": "string",
    "vnetName": "string",
    "vnetResourceGroupName": "string",
    "vnetSubnetName": "string",
    "virtualNetwork": {
      "id": "string",
      "name": "string",
      "type": "string",
      "subnet": "string"
    },
    "internalLoadBalancingMode": "string",
    "multiSize": "string",
    "multiRoleCount": "integer",
    "workerPools": [
      {
        "id": "string",
        "name": "string",
        "kind": "string",
        "location": "string",
        "type": "string",
        "tags": {},
        "properties": {
          "workerSizeId": "integer",
          "computeMode": "string",
          "workerSize": "string",
          "workerCount": "integer",
          "instanceNames": [
            "string"
          ]
        },
        "sku": {
          "name": "string",
          "tier": "string",
          "size": "string",
          "family": "string",
          "capacity": "integer"
        }
      }
    ],
    "ipsslAddressCount": "integer",
    "databaseEdition": "string",
    "databaseServiceObjective": "string",
    "upgradeDomains": "integer",
    "subscriptionId": "string",
    "dnsSuffix": "string",
    "lastAction": "string",
    "lastActionResult": "string",
    "allowedMultiSizes": "string",
    "allowedWorkerSizes": "string",
    "maximumNumberOfMachines": "integer",
    "vipMappings": [
      {
        "virtualIP": "string",
        "internalHttpPort": "integer",
        "internalHttpsPort": "integer",
        "inUse": boolean
      }
    ],
    "environmentCapacities": [
      {
        "name": "string",
        "availableCapacity": "integer",
        "totalCapacity": "integer",
        "unit": "string",
        "computeMode": "string",
        "workerSize": "string",
        "workerSizeId": "integer",
        "excludeFromCapacityAllocation": boolean,
        "isApplicableForAllComputeModes": boolean,
        "siteMode": "string"
      }
    ],
    "networkAccessControlList": [
      {
        "action": "string",
        "description": "string",
        "order": "integer",
        "remoteSubnet": "string"
      }
    ],
    "environmentIsHealthy": boolean,
    "environmentStatus": "string",
    "resourceGroup": "string",
    "apiManagementAccountId": "string",
    "suspended": boolean,
    "clusterSettings": [
      {
        "name": "string",
        "value": "string"
      }
    ]
  },
  "resources": [
    null
  ]
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Web/hostingEnvironments" />
### Microsoft.Web/hostingEnvironments object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Web/hostingEnvironments |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  name | string | No | Resource Name |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [HostingEnvironment_properties object](#HostingEnvironment_properties) |
|  resources | array | No | [hostingEnvironments_workerPools_childResource object](#hostingEnvironments_workerPools_childResource) |


<a id="HostingEnvironment_properties" />
### HostingEnvironment_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Name of the hostingEnvironment (App Service Environment) |
|  location | string | No | Location of the hostingEnvironment (App Service Environment), e.g. "West US" |
|  provisioningState | enum | No | Provisioning state of the hostingEnvironment (App Service Environment). - Succeeded, Failed, Canceled, InProgress, Deleting |
|  status | enum | No | Current status of the hostingEnvironment (App Service Environment). - Preparing, Ready, Scaling, Deleting |
|  vnetName | string | No | Name of the hostingEnvironment's (App Service Environment) virtual network |
|  vnetResourceGroupName | string | No | Resource group of the hostingEnvironment's (App Service Environment) virtual network |
|  vnetSubnetName | string | No | Subnet of the hostingEnvironment's (App Service Environment) virtual network |
|  virtualNetwork | object | No | Description of the hostingEnvironment's (App Service Environment) virtual network - [VirtualNetworkProfile object](#VirtualNetworkProfile) |
|  internalLoadBalancingMode | enum | No | Specifies which endpoints to serve internally in the hostingEnvironment's (App Service Environment) VNET. - None, Web, Publishing |
|  multiSize | string | No | Front-end VM size, e.g. "Medium", "Large" |
|  multiRoleCount | integer | No | Number of front-end instances |
|  workerPools | array | No | Description of worker pools with worker size ids, VM sizes, and number of workers in each pool - [WorkerPool object](#WorkerPool) |
|  ipsslAddressCount | integer | No | Number of IP SSL addresses reserved for this hostingEnvironment (App Service Environment) |
|  databaseEdition | string | No | Edition of the metadata database for the hostingEnvironment (App Service Environment) e.g. "Standard" |
|  databaseServiceObjective | string | No | Service objective of the metadata database for the hostingEnvironment (App Service Environment) e.g. "S0" |
|  upgradeDomains | integer | No | Number of upgrade domains of this hostingEnvironment (App Service Environment) |
|  subscriptionId | string | No | Subscription of the hostingEnvironment (App Service Environment) |
|  dnsSuffix | string | No | DNS suffix of the hostingEnvironment (App Service Environment) |
|  lastAction | string | No | Last deployment action on this hostingEnvironment (App Service Environment) |
|  lastActionResult | string | No | Result of the last deployment action on this hostingEnvironment (App Service Environment) |
|  allowedMultiSizes | string | No | List of comma separated strings describing which VM sizes are allowed for front-ends |
|  allowedWorkerSizes | string | No | List of comma separated strings describing which VM sizes are allowed for workers |
|  maximumNumberOfMachines | integer | No | Maximum number of VMs in this hostingEnvironment (App Service Environment) |
|  vipMappings | array | No | Description of IP SSL mapping for this hostingEnvironment (App Service Environment) - [VirtualIPMapping object](#VirtualIPMapping) |
|  environmentCapacities | array | No | Current total, used, and available worker capacities - [StampCapacity object](#StampCapacity) |
|  networkAccessControlList | array | No | Access control list for controlling traffic to the hostingEnvironment (App Service Environment) - [NetworkAccessControlEntry object](#NetworkAccessControlEntry) |
|  environmentIsHealthy | boolean | No | True/false indicating whether the hostingEnvironment (App Service Environment) is healthy |
|  environmentStatus | string | No | Detailed message about with results of the last check of the hostingEnvironment (App Service Environment) |
|  resourceGroup | string | No | Resource group of the hostingEnvironment (App Service Environment) |
|  apiManagementAccountId | string | No | Api Management Account associated with this Hosting Environment |
|  suspended | boolean | No | True/false indicating whether the hostingEnvironment is suspended. The environment can be suspended e.g. when the management endpoint is no longer available
            (most likely because NSG blocked the incoming traffic) |
|  clusterSettings | array | No | Custom settings for changing the behavior of the hosting environment - [NameValuePair object](#NameValuePair) |


<a id="hostingEnvironments_workerPools_childResource" />
### hostingEnvironments_workerPools_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | workerPools |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  name | string | No | Resource Name |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [WorkerPool_properties object](#WorkerPool_properties) |
|  sku | object | No | [SkuDescription object](#SkuDescription) |


<a id="VirtualNetworkProfile" />
### VirtualNetworkProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource id of the virtual network |
|  name | string | No | Name of the virtual network (read-only) |
|  type | string | No | Resource type of the virtual network (read-only) |
|  subnet | string | No | Subnet within the virtual network |


<a id="WorkerPool" />
### WorkerPool object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  name | string | No | Resource Name |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  type | string | No | Resource type |
|  tags | object | No | Resource tags |
|  properties | object | No | [WorkerPool_properties object](#WorkerPool_properties) |
|  sku | object | No | [SkuDescription object](#SkuDescription) |


<a id="VirtualIPMapping" />
### VirtualIPMapping object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  virtualIP | string | No | Virtual IP address |
|  internalHttpPort | integer | No | Internal HTTP port |
|  internalHttpsPort | integer | No | Internal HTTPS port |
|  inUse | boolean | No | Is VIP mapping in use |


<a id="StampCapacity" />
### StampCapacity object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Name of the stamp |
|  availableCapacity | integer | No | Available capacity (# of machines, bytes of storage etc...) |
|  totalCapacity | integer | No | Total capacity (# of machines, bytes of storage etc...) |
|  unit | string | No | Name of the unit |
|  computeMode | enum | No | Shared/Dedicated workers. - Shared, Dedicated, Dynamic |
|  workerSize | enum | No | Size of the machines. - Default, Small, Medium, Large |
|  workerSizeId | integer | No | Size Id of machines:
            0 - Small
            1 - Medium
            2 - Large |
|  excludeFromCapacityAllocation | boolean | No | If true it includes basic sites
            Basic sites are not used for capacity allocation. |
|  isApplicableForAllComputeModes | boolean | No | Is capacity applicable for all sites? |
|  siteMode | string | No | Shared or Dedicated |


<a id="NetworkAccessControlEntry" />
### NetworkAccessControlEntry object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  action | enum | No | Permit or Deny |
|  description | string | No |  |
|  order | integer | No |  |
|  remoteSubnet | string | No |  |


<a id="NameValuePair" />
### NameValuePair object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Pair name |
|  value | string | No | Pair value |


<a id="WorkerPool_properties" />
### WorkerPool_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  workerSizeId | integer | No | Worker size id for referencing this worker pool |
|  computeMode | enum | No | Shared or dedicated web app hosting. - Shared, Dedicated, Dynamic |
|  workerSize | string | No | VM size of the worker pool instances |
|  workerCount | integer | No | Number of instances in the worker pool |
|  instanceNames | array | No | Names of all instances in the worker pool (read only) - string |


<a id="SkuDescription" />
### SkuDescription object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Name of the resource sku |
|  tier | string | No | Service Tier of the resource sku |
|  size | string | No | Size specifier of the resource sku |
|  family | string | No | Family code of the resource sku |
|  capacity | integer | No | Current number of instances assigned to the resource |

