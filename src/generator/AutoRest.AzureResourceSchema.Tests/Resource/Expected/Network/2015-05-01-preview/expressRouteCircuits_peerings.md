# Microsoft.Network/expressRouteCircuits/peerings template reference
API Version: 2015-05-01-preview
## Template format

To create a Microsoft.Network/expressRouteCircuits/peerings resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Network/expressRouteCircuits/peerings",
  "apiVersion": "2015-05-01-preview",
  "id": "string",
  "properties": {
    "peeringType": "string",
    "state": "string",
    "azureASN": "integer",
    "peerASN": "integer",
    "primaryPeerAddressPrefix": "string",
    "secondaryPeerAddressPrefix": "string",
    "primaryAzurePort": "string",
    "secondaryAzurePort": "string",
    "sharedKey": "string",
    "vlanId": "integer",
    "microsoftPeeringConfig": {
      "advertisedPublicPrefixes": [
        "string"
      ],
      "advertisedPublicPrefixesState": "string",
      "customerASN": "integer",
      "routingRegistryName": "string"
    },
    "stats": {
      "bytesIn": "integer",
      "bytesOut": "integer"
    },
    "provisioningState": "string"
  },
  "etag": "string"
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/expressRouteCircuits/peerings" />
### Microsoft.Network/expressRouteCircuits/peerings object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Network/expressRouteCircuits/peerings |
|  apiVersion | enum | Yes | 2015-05-01-preview |
|  id | string | No | Resource Id |
|  properties | object | Yes | [ExpressRouteCircuitPeeringPropertiesFormat object](#ExpressRouteCircuitPeeringPropertiesFormat) |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ExpressRouteCircuitPeeringPropertiesFormat" />
### ExpressRouteCircuitPeeringPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  peeringType | enum | No | Gets or sets PeeringType. - AzurePublicPeering, AzurePrivatePeering, MicrosoftPeering |
|  state | enum | No | Gets or sets state of Peering. - Disabled or Enabled |
|  azureASN | integer | No | Gets or sets the azure ASN |
|  peerASN | integer | No | Gets or sets the peer ASN |
|  primaryPeerAddressPrefix | string | No | Gets or sets the primary address prefix |
|  secondaryPeerAddressPrefix | string | No | Gets or sets the secondary address prefix |
|  primaryAzurePort | string | No | Gets or sets the primary port |
|  secondaryAzurePort | string | No | Gets or sets the secondary port |
|  sharedKey | string | No | Gets or sets the shared key |
|  vlanId | integer | No | Gets or sets the vlan id |
|  microsoftPeeringConfig | object | No | Gets or sets the mircosoft peering config - [ExpressRouteCircuitPeeringConfig object](#ExpressRouteCircuitPeeringConfig) |
|  stats | object | No | Gets or peering stats - [ExpressRouteCircuitStats object](#ExpressRouteCircuitStats) |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="ExpressRouteCircuitPeeringConfig" />
### ExpressRouteCircuitPeeringConfig object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  advertisedPublicPrefixes | array | No | Gets or sets the reference of AdvertisedPublicPrefixes - string |
|  advertisedPublicPrefixesState | enum | No | Gets or sets AdvertisedPublicPrefixState of the Peering resource. - NotConfigured, Configuring, Configured, ValidationNeeded |
|  customerASN | integer | No | Gets or Sets CustomerAsn of the peering. |
|  routingRegistryName | string | No | Gets or Sets RoutingRegistryName of the config. |


<a id="ExpressRouteCircuitStats" />
### ExpressRouteCircuitStats object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  bytesIn | integer | No | Gets BytesIn of the peering. |
|  bytesOut | integer | No | Gets BytesOut of the peering. |

