# Microsoft.Network/virtualNetworks template reference
API Version: 2016-09-01
## Template format

To create a Microsoft.Network/virtualNetworks resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Network/virtualNetworks",
  "apiVersion": "2016-09-01",
  "id": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "addressSpace": {
      "addressPrefixes": [
        "string"
      ]
    },
    "dhcpOptions": {
      "dnsServers": [
        "string"
      ]
    },
    "subnets": [
      {
        "id": "string",
        "properties": {
          "addressPrefix": "string",
          "networkSecurityGroup": {
            "id": "string",
            "location": "string",
            "tags": {},
            "properties": {
              "securityRules": [
                {
                  "id": "string",
                  "properties": {
                    "description": "string",
                    "protocol": "string",
                    "sourcePortRange": "string",
                    "destinationPortRange": "string",
                    "sourceAddressPrefix": "string",
                    "destinationAddressPrefix": "string",
                    "access": "string",
                    "priority": "integer",
                    "direction": "string",
                    "provisioningState": "string"
                  },
                  "name": "string",
                  "etag": "string"
                }
              ],
              "defaultSecurityRules": [
                {
                  "id": "string",
                  "properties": {
                    "description": "string",
                    "protocol": "string",
                    "sourcePortRange": "string",
                    "destinationPortRange": "string",
                    "sourceAddressPrefix": "string",
                    "destinationAddressPrefix": "string",
                    "access": "string",
                    "priority": "integer",
                    "direction": "string",
                    "provisioningState": "string"
                  },
                  "name": "string",
                  "etag": "string"
                }
              ],
              "resourceGuid": "string",
              "provisioningState": "string"
            },
            "etag": "string"
          },
          "routeTable": {
            "id": "string",
            "location": "string",
            "tags": {},
            "properties": {
              "routes": [
                {
                  "id": "string",
                  "properties": {
                    "addressPrefix": "string",
                    "nextHopType": "string",
                    "nextHopIpAddress": "string",
                    "provisioningState": "string"
                  },
                  "name": "string",
                  "etag": "string"
                }
              ],
              "provisioningState": "string"
            },
            "etag": "string"
          },
          "resourceNavigationLinks": [
            {
              "id": "string",
              "properties": {
                "linkedResourceType": "string",
                "link": "string"
              },
              "name": "string"
            }
          ],
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "VirtualNetworkPeerings": [
      {
        "id": "string",
        "properties": {
          "allowVirtualNetworkAccess": boolean,
          "allowForwardedTraffic": boolean,
          "allowGatewayTransit": boolean,
          "useRemoteGateways": boolean,
          "remoteVirtualNetwork": {
            "id": "string"
          },
          "peeringState": "string",
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "resourceGuid": "string",
    "provisioningState": "string"
  },
  "etag": "string",
  "resources": [
    null
  ]
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/virtualNetworks" />
### Microsoft.Network/virtualNetworks object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Network/virtualNetworks |
|  apiVersion | enum | Yes | 2016-09-01 |
|  id | string | No | Resource Id |
|  location | string | No | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [VirtualNetworkPropertiesFormat object](#VirtualNetworkPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |
|  resources | array | No | [virtualNetworks_virtualNetworkPeerings_childResource object](#virtualNetworks_virtualNetworkPeerings_childResource) [virtualNetworks_subnets_childResource object](#virtualNetworks_subnets_childResource) |


<a id="VirtualNetworkPropertiesFormat" />
### VirtualNetworkPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  addressSpace | object | No | Gets or sets AddressSpace that contains an array of IP address ranges that can be used by subnets - [AddressSpace object](#AddressSpace) |
|  dhcpOptions | object | No | Gets or sets DHCPOptions that contains an array of DNS servers available to VMs deployed in the virtual network - [DhcpOptions object](#DhcpOptions) |
|  subnets | array | No | Gets or sets list of subnets in a VirtualNetwork - [Subnet object](#Subnet) |
|  VirtualNetworkPeerings | array | No | Gets or sets list of peerings in a VirtualNetwork - [VirtualNetworkPeering object](#VirtualNetworkPeering) |
|  resourceGuid | string | No | Gets or sets resource guid property of the VirtualNetwork resource |
|  provisioningState | string | No | Gets provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="virtualNetworks_virtualNetworkPeerings_childResource" />
### virtualNetworks_virtualNetworkPeerings_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | virtualNetworkPeerings |
|  apiVersion | enum | Yes | 2016-09-01 |
|  id | string | No | Resource Id |
|  properties | object | Yes | [VirtualNetworkPeeringPropertiesFormat object](#VirtualNetworkPeeringPropertiesFormat) |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="virtualNetworks_subnets_childResource" />
### virtualNetworks_subnets_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | subnets |
|  apiVersion | enum | Yes | 2016-09-01 |
|  id | string | No | Resource Id |
|  properties | object | Yes | [SubnetPropertiesFormat object](#SubnetPropertiesFormat) |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="AddressSpace" />
### AddressSpace object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  addressPrefixes | array | No | Gets or sets list of address blocks reserved for this virtual network in CIDR notation - string |


<a id="DhcpOptions" />
### DhcpOptions object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  dnsServers | array | No | Gets or sets list of DNS servers IP addresses - string |


<a id="Subnet" />
### Subnet object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [SubnetPropertiesFormat object](#SubnetPropertiesFormat) |
|  name | string | No | Gets or sets the name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="VirtualNetworkPeering" />
### VirtualNetworkPeering object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [VirtualNetworkPeeringPropertiesFormat object](#VirtualNetworkPeeringPropertiesFormat) |
|  name | string | No | Gets or sets the name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="VirtualNetworkPeeringPropertiesFormat" />
### VirtualNetworkPeeringPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  allowVirtualNetworkAccess | boolean | No | Gets or sets whether the VMs in the linked virtual network space would be able to access all the VMs in local Virtual network space |
|  allowForwardedTraffic | boolean | No | Gets or sets whether the forwarded traffic from the VMs in the remote virtual network will be allowed/disallowed |
|  allowGatewayTransit | boolean | No | Gets or sets if gatewayLinks can be used in remote virtual network’s link to this virtual network |
|  useRemoteGateways | boolean | No | Gets or sets if remote gateways can be used on this virtual network. If the flag is set to true, and allowGatewayTransit on remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only 1 peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. |
|  remoteVirtualNetwork | object | No | Gets or sets the reference of the remote virtual network - [SubResource object](#SubResource) |
|  peeringState | enum | No | Gets the status of the virtual network peering. - Initiated, Connected, Disconnected |
|  provisioningState | string | No | Gets provisioning state of the resource |


<a id="SubnetPropertiesFormat" />
### SubnetPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  addressPrefix | string | No | Gets or sets Address prefix for the subnet. |
|  networkSecurityGroup | object | No | Gets or sets the reference of the NetworkSecurityGroup resource - [NetworkSecurityGroup object](#NetworkSecurityGroup) |
|  routeTable | object | No | Gets or sets the reference of the RouteTable resource - [RouteTable object](#RouteTable) |
|  resourceNavigationLinks | array | No | Gets array of references to the external resources using subnet - [ResourceNavigationLink object](#ResourceNavigationLink) |
|  provisioningState | string | No | Gets provisioning state of the resource |


<a id="SubResource" />
### SubResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |


<a id="NetworkSecurityGroup" />
### NetworkSecurityGroup object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  location | string | No | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | No | [NetworkSecurityGroupPropertiesFormat object](#NetworkSecurityGroupPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="RouteTable" />
### RouteTable object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  location | string | No | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | No | [RouteTablePropertiesFormat object](#RouteTablePropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="ResourceNavigationLink" />
### ResourceNavigationLink object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ResourceNavigationLinkFormat object](#ResourceNavigationLinkFormat) |
|  name | string | No | Name of the resource that is unique within a resource group. This name can be used to access the resource |


<a id="NetworkSecurityGroupPropertiesFormat" />
### NetworkSecurityGroupPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  securityRules | array | No | Gets or sets security rules of network security group - [SecurityRule object](#SecurityRule) |
|  defaultSecurityRules | array | No | Gets or default security rules of network security group - [SecurityRule object](#SecurityRule) |
|  resourceGuid | string | No | Gets or sets resource guid property of the network security group resource |
|  provisioningState | string | No | Gets provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="RouteTablePropertiesFormat" />
### RouteTablePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  routes | array | No | Gets or sets Routes in a Route Table - [Route object](#Route) |
|  provisioningState | string | No | Gets provisioning state of the resource Updating/Deleting/Failed |


<a id="ResourceNavigationLinkFormat" />
### ResourceNavigationLinkFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  linkedResourceType | string | No | Resource type of the linked resource |
|  link | string | No | Link to the external resource |


<a id="SecurityRule" />
### SecurityRule object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [SecurityRulePropertiesFormat object](#SecurityRulePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="Route" />
### Route object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [RoutePropertiesFormat object](#RoutePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="SecurityRulePropertiesFormat" />
### SecurityRulePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  description | string | No | Gets or sets a description for this rule. Restricted to 140 chars. |
|  protocol | enum | Yes | Gets or sets Network protocol this rule applies to. Can be Tcp, Udp or All(*). - Tcp, Udp, * |
|  sourcePortRange | string | No | Gets or sets Source Port or Range. Integer or range between 0 and 65535. Asterix '*' can also be used to match all ports. |
|  destinationPortRange | string | No | Gets or sets Destination Port or Range. Integer or range between 0 and 65535. Asterix '*' can also be used to match all ports. |
|  sourceAddressPrefix | string | Yes | Gets or sets source address prefix. CIDR or source IP range. Asterix '*' can also be used to match all source IPs. Default tags such as 'VirtualNetwork', 'AzureLoadBalancer' and 'Internet' can also be used. If this is an ingress rule, specifies where network traffic originates from.  |
|  destinationAddressPrefix | string | Yes | Gets or sets destination address prefix. CIDR or source IP range. Asterix '*' can also be used to match all source IPs. Default tags such as 'VirtualNetwork', 'AzureLoadBalancer' and 'Internet' can also be used.  |
|  access | enum | Yes | Gets or sets network traffic is allowed or denied. Possible values are 'Allow' and 'Deny'. - Allow or Deny |
|  priority | integer | No | Gets or sets the priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
|  direction | enum | Yes | Gets or sets the direction of the rule.InBound or Outbound. The direction specifies if rule will be evaluated on incoming or outcoming traffic. - Inbound or Outbound |
|  provisioningState | string | No | Gets provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="RoutePropertiesFormat" />
### RoutePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  addressPrefix | string | No | Gets or sets the destination CIDR to which the route applies. |
|  nextHopType | enum | Yes | Gets or sets the type of Azure hop the packet should be sent to. - VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance, None |
|  nextHopIpAddress | string | No | Gets or sets the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance. |
|  provisioningState | string | No | Gets provisioning state of the resource Updating/Deleting/Failed |

