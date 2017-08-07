# Microsoft.Network/expressRouteCircuits template reference
API Version: 2016-09-01
## Template format

To create a Microsoft.Network/expressRouteCircuits resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Network/expressRouteCircuits",
  "apiVersion": "2016-09-01",
  "id": "string",
  "location": "string",
  "tags": {},
  "sku": {
    "name": "string",
    "tier": "string",
    "family": "string"
  },
  "properties": {
    "allowClassicOperations": boolean,
    "circuitProvisioningState": "string",
    "serviceProviderProvisioningState": "string",
    "authorizations": [
      {
        "id": "string",
        "properties": {
          "authorizationKey": "string",
          "authorizationUseStatus": "string",
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "peerings": [
      {
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
            "primarybytesIn": "integer",
            "primarybytesOut": "integer",
            "secondarybytesIn": "integer",
            "secondarybytesOut": "integer"
          },
          "provisioningState": "string",
          "gatewayManagerEtag": "string",
          "lastModifiedBy": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "serviceKey": "string",
    "serviceProviderNotes": "string",
    "serviceProviderProperties": {
      "serviceProviderName": "string",
      "peeringLocation": "string",
      "bandwidthInMbps": "integer"
    },
    "provisioningState": "string",
    "gatewayManagerEtag": "string"
  },
  "etag": "string",
  "resources": []
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/expressRouteCircuits" />
### Microsoft.Network/expressRouteCircuits object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Network/expressRouteCircuits |
|  apiVersion | enum | Yes | 2016-09-01 |
|  id | string | No | Resource Id |
|  location | string | No | Resource location |
|  tags | object | No | Resource tags |
|  sku | object | No | Gets or sets sku - [ExpressRouteCircuitSku object](#ExpressRouteCircuitSku) |
|  properties | object | Yes | [ExpressRouteCircuitPropertiesFormat object](#ExpressRouteCircuitPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |
|  resources | array | No | [peerings](./expressRouteCircuits/peerings.md) [authorizations](./expressRouteCircuits/authorizations.md) |


<a id="ExpressRouteCircuitSku" />
### ExpressRouteCircuitSku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Gets or sets name of the sku. |
|  tier | enum | No | Gets or sets tier of the sku. - Standard or Premium |
|  family | enum | No | Gets or sets family of the sku. - UnlimitedData or MeteredData |


<a id="ExpressRouteCircuitPropertiesFormat" />
### ExpressRouteCircuitPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  allowClassicOperations | boolean | No | allow classic operations |
|  circuitProvisioningState | string | No | Gets or sets CircuitProvisioningState state of the resource  |
|  serviceProviderProvisioningState | enum | No | Gets or sets ServiceProviderProvisioningState state of the resource. - NotProvisioned, Provisioning, Provisioned, Deprovisioning |
|  authorizations | array | No | Gets or sets list of authorizations - [ExpressRouteCircuitAuthorization object](#ExpressRouteCircuitAuthorization) |
|  peerings | array | No | Gets or sets list of peerings - [ExpressRouteCircuitPeering object](#ExpressRouteCircuitPeering) |
|  serviceKey | string | No | Gets or sets ServiceKey |
|  serviceProviderNotes | string | No | Gets or sets ServiceProviderNotes |
|  serviceProviderProperties | object | No | Gets or sets ServiceProviderProperties - [ExpressRouteCircuitServiceProviderProperties object](#ExpressRouteCircuitServiceProviderProperties) |
|  provisioningState | string | No | Gets provisioning state of the PublicIP resource Updating/Deleting/Failed |
|  gatewayManagerEtag | string | No | Gets or sets the GatewayManager Etag |


<a id="ExpressRouteCircuitAuthorization" />
### ExpressRouteCircuitAuthorization object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [AuthorizationPropertiesFormat object](#AuthorizationPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ExpressRouteCircuitPeering" />
### ExpressRouteCircuitPeering object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ExpressRouteCircuitPeeringPropertiesFormat object](#ExpressRouteCircuitPeeringPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ExpressRouteCircuitServiceProviderProperties" />
### ExpressRouteCircuitServiceProviderProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  serviceProviderName | string | No | Gets or sets serviceProviderName. |
|  peeringLocation | string | No | Gets or sets peering location. |
|  bandwidthInMbps | integer | No | Gets or sets BandwidthInMbps. |


<a id="AuthorizationPropertiesFormat" />
### AuthorizationPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  authorizationKey | string | No | Gets or sets the authorization key |
|  authorizationUseStatus | enum | No | Gets or sets AuthorizationUseStatus. - Available or InUse |
|  provisioningState | string | No | Gets provisioning state of the PublicIP resource Updating/Deleting/Failed |


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
|  provisioningState | string | No | Gets provisioning state of the PublicIP resource Updating/Deleting/Failed |
|  gatewayManagerEtag | string | No | Gets or sets the GatewayManager Etag |
|  lastModifiedBy | string | No | Gets whether the provider or the customer last modified the peering |


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
|  primarybytesIn | integer | No | Gets BytesIn of the peering. |
|  primarybytesOut | integer | No | Gets BytesOut of the peering. |
|  secondarybytesIn | integer | No | Gets BytesIn of the peering. |
|  secondarybytesOut | integer | No | Gets BytesOut of the peering. |

