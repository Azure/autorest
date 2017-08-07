# Microsoft.Network/virtualnetworks/subnets template reference
API Version: 2015-06-15
## Template format

To create a Microsoft.Network/virtualnetworks/subnets resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Network/virtualnetworks/subnets",
  "apiVersion": "2015-06-15",
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
        "networkInterfaces": [
          {
            "id": "string",
            "location": "string",
            "tags": {},
            "properties": {
              "virtualMachine": {
                "id": "string"
              },
              "networkSecurityGroup": "NetworkSecurityGroup",
              "ipConfigurations": [
                {
                  "id": "string",
                  "properties": {
                    "loadBalancerBackendAddressPools": [
                      {
                        "id": "string",
                        "properties": {
                          "backendIPConfigurations": [
                            "NetworkInterfaceIPConfiguration"
                          ],
                          "loadBalancingRules": [
                            {
                              "id": "string"
                            }
                          ],
                          "outboundNatRule": {
                            "id": "string"
                          },
                          "provisioningState": "string"
                        },
                        "name": "string",
                        "etag": "string"
                      }
                    ],
                    "loadBalancerInboundNatRules": [
                      {
                        "id": "string",
                        "properties": {
                          "frontendIPConfiguration": {
                            "id": "string"
                          },
                          "backendIPConfiguration": "NetworkInterfaceIPConfiguration",
                          "protocol": "string",
                          "frontendPort": "integer",
                          "backendPort": "integer",
                          "idleTimeoutInMinutes": "integer",
                          "enableFloatingIP": boolean,
                          "provisioningState": "string"
                        },
                        "name": "string",
                        "etag": "string"
                      }
                    ],
                    "privateIPAddress": "string",
                    "privateIPAllocationMethod": "string",
                    "subnet": {
                      "id": "string",
                      "properties": "SubnetPropertiesFormat",
                      "name": "string",
                      "etag": "string"
                    },
                    "publicIPAddress": {
                      "id": "string",
                      "location": "string",
                      "tags": {},
                      "properties": {
                        "publicIPAllocationMethod": "string",
                        "ipConfiguration": {
                          "id": "string",
                          "properties": {
                            "privateIPAddress": "string",
                            "privateIPAllocationMethod": "string",
                            "subnet": {
                              "id": "string",
                              "properties": "SubnetPropertiesFormat",
                              "name": "string",
                              "etag": "string"
                            },
                            "publicIPAddress": "PublicIPAddress",
                            "provisioningState": "string"
                          },
                          "name": "string",
                          "etag": "string"
                        },
                        "dnsSettings": {
                          "domainNameLabel": "string",
                          "fqdn": "string",
                          "reverseFqdn": "string"
                        },
                        "ipAddress": "string",
                        "idleTimeoutInMinutes": "integer",
                        "resourceGuid": "string",
                        "provisioningState": "string"
                      },
                      "etag": "string"
                    },
                    "provisioningState": "string"
                  },
                  "name": "string",
                  "etag": "string"
                }
              ],
              "dnsSettings": {
                "dnsServers": [
                  "string"
                ],
                "appliedDnsServers": [
                  "string"
                ],
                "internalDnsNameLabel": "string",
                "internalFqdn": "string"
              },
              "macAddress": "string",
              "primary": boolean,
              "enableIPForwarding": boolean,
              "resourceGuid": "string",
              "provisioningState": "string"
            },
            "etag": "string"
          }
        ],
        "subnets": [
          {
            "id": "string",
            "properties": "SubnetPropertiesFormat",
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
        "subnets": [
          {
            "id": "string",
            "properties": "SubnetPropertiesFormat",
            "name": "string",
            "etag": "string"
          }
        ],
        "provisioningState": "string"
      },
      "etag": "string"
    },
    "ipConfigurations": [
      {
        "id": "string",
        "properties": {
          "privateIPAddress": "string",
          "privateIPAllocationMethod": "string",
          "subnet": {
            "id": "string",
            "properties": "SubnetPropertiesFormat",
            "name": "string",
            "etag": "string"
          },
          "publicIPAddress": {
            "id": "string",
            "location": "string",
            "tags": {},
            "properties": {
              "publicIPAllocationMethod": "string",
              "ipConfiguration": "IPConfiguration",
              "dnsSettings": {
                "domainNameLabel": "string",
                "fqdn": "string",
                "reverseFqdn": "string"
              },
              "ipAddress": "string",
              "idleTimeoutInMinutes": "integer",
              "resourceGuid": "string",
              "provisioningState": "string"
            },
            "etag": "string"
          },
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "provisioningState": "string"
  },
  "etag": "string"
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/virtualnetworks/subnets" />
### Microsoft.Network/virtualnetworks/subnets object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Network/virtualnetworks/subnets |
|  apiVersion | enum | Yes | 2015-06-15 |
|  id | string | No | Resource Id |
|  properties | object | Yes | [SubnetPropertiesFormat object](#SubnetPropertiesFormat) |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="SubnetPropertiesFormat" />
### SubnetPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  addressPrefix | string | No | Gets or sets Address prefix for the subnet. |
|  networkSecurityGroup | object | No | Gets or sets the reference of the NetworkSecurityGroup resource - [NetworkSecurityGroup object](#NetworkSecurityGroup) |
|  routeTable | object | No | Gets or sets the reference of the RouteTable resource - [RouteTable object](#RouteTable) |
|  ipConfigurations | array | No | Gets array of references to the network interface IP configurations using subnet - [IPConfiguration object](#IPConfiguration) |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


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


<a id="IPConfiguration" />
### IPConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [IPConfigurationPropertiesFormat object](#IPConfigurationPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="NetworkSecurityGroupPropertiesFormat" />
### NetworkSecurityGroupPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  securityRules | array | No | Gets or sets Security rules of network security group - [SecurityRule object](#SecurityRule) |
|  defaultSecurityRules | array | No | Gets or sets Default security rules of network security group - [SecurityRule object](#SecurityRule) |
|  networkInterfaces | array | No | Gets collection of references to Network Interfaces - [NetworkInterface object](#NetworkInterface) |
|  subnets | array | No | Gets collection of references to subnets - [Subnet object](#Subnet) |
|  resourceGuid | string | No | Gets or sets resource guid property of the network security group resource |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="RouteTablePropertiesFormat" />
### RouteTablePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  routes | array | No | Gets or sets Routes in a Route Table - [Route object](#Route) |
|  subnets | array | No | Gets collection of references to subnets - [Subnet object](#Subnet) |
|  provisioningState | string | No | Gets or sets Provisioning state of the resource Updating/Deleting/Failed |


<a id="IPConfigurationPropertiesFormat" />
### IPConfigurationPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  privateIPAddress | string | No | Gets or sets the privateIPAddress of the IP Configuration |
|  privateIPAllocationMethod | enum | No | Gets or sets PrivateIP allocation method (Static/Dynamic). - Static or Dynamic |
|  subnet | object | No | Gets or sets the reference of the subnet resource - [Subnet object](#Subnet) |
|  publicIPAddress | object | No | Gets or sets the reference of the PublicIP resource - [PublicIPAddress object](#PublicIPAddress) |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="SecurityRule" />
### SecurityRule object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [SecurityRulePropertiesFormat object](#SecurityRulePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="NetworkInterface" />
### NetworkInterface object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  location | string | No | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | No | [NetworkInterfacePropertiesFormat object](#NetworkInterfacePropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="Subnet" />
### Subnet object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [SubnetPropertiesFormat object](#SubnetPropertiesFormat) |
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


<a id="PublicIPAddress" />
### PublicIPAddress object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  location | string | No | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | No | [PublicIPAddressPropertiesFormat object](#PublicIPAddressPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


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
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="NetworkInterfacePropertiesFormat" />
### NetworkInterfacePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  virtualMachine | object | No | Gets or sets the reference of a VirtualMachine - [SubResource object](#SubResource) |
|  networkSecurityGroup | object | No | Gets or sets the reference of the NetworkSecurityGroup resource - [NetworkSecurityGroup object](#NetworkSecurityGroup) |
|  ipConfigurations | array | No | Gets or sets list of IPConfigurations of the NetworkInterface - [NetworkInterfaceIPConfiguration object](#NetworkInterfaceIPConfiguration) |
|  dnsSettings | object | No | Gets or sets DNS Settings in  NetworkInterface - [NetworkInterfaceDnsSettings object](#NetworkInterfaceDnsSettings) |
|  macAddress | string | No | Gets the MAC Address of the network interface |
|  primary | boolean | No | Gets whether this is a primary NIC on a virtual machine |
|  enableIPForwarding | boolean | No | Gets or sets whether IPForwarding is enabled on the NIC |
|  resourceGuid | string | No | Gets or sets resource guid property of the network interface resource |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="RoutePropertiesFormat" />
### RoutePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  addressPrefix | string | No | Gets or sets the destination CIDR to which the route applies. |
|  nextHopType | enum | Yes | Gets or sets the type of Azure hop the packet should be sent to. - VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance, None |
|  nextHopIpAddress | string | No | Gets or sets the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance. |
|  provisioningState | string | No | Gets or sets Provisioning state of the resource Updating/Deleting/Failed |


<a id="PublicIPAddressPropertiesFormat" />
### PublicIPAddressPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  publicIPAllocationMethod | enum | No | Gets or sets PublicIP allocation method (Static/Dynamic). - Static or Dynamic |
|  ipConfiguration | object | No | [IPConfiguration object](#IPConfiguration) |
|  dnsSettings | object | No | Gets or sets FQDN of the DNS record associated with the public IP address - [PublicIPAddressDnsSettings object](#PublicIPAddressDnsSettings) |
|  ipAddress | string | No |  |
|  idleTimeoutInMinutes | integer | No | Gets or sets the Idletimeout of the public IP address |
|  resourceGuid | string | No | Gets or sets resource guid property of the PublicIP resource |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="SubResource" />
### SubResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |


<a id="NetworkInterfaceIPConfiguration" />
### NetworkInterfaceIPConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [NetworkInterfaceIPConfigurationPropertiesFormat object](#NetworkInterfaceIPConfigurationPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="NetworkInterfaceDnsSettings" />
### NetworkInterfaceDnsSettings object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  dnsServers | array | No | Gets or sets list of DNS servers IP addresses - string |
|  appliedDnsServers | array | No | Gets or sets list of Applied DNS servers IP addresses - string |
|  internalDnsNameLabel | string | No | Gets or sets the Internal DNS name |
|  internalFqdn | string | No | Gets or sets full IDNS name in the form, DnsName.VnetId.ZoneId.TopleveSuffix. This is set when the NIC is associated to a VM |


<a id="PublicIPAddressDnsSettings" />
### PublicIPAddressDnsSettings object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  domainNameLabel | string | No | Gets or sets the Domain name label.The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. |
|  fqdn | string | No | Gets the FQDN, Fully qualified domain name of the A DNS record associated with the public IP. This is the concatenation of the domainNameLabel and the regionalized DNS zone. |
|  reverseFqdn | string | No | Gets or Sests the Reverse FQDN. A user-visible, fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN.  |


<a id="NetworkInterfaceIPConfigurationPropertiesFormat" />
### NetworkInterfaceIPConfigurationPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  loadBalancerBackendAddressPools | array | No | Gets or sets the reference of LoadBalancerBackendAddressPool resource - [BackendAddressPool object](#BackendAddressPool) |
|  loadBalancerInboundNatRules | array | No | Gets or sets list of references of LoadBalancerInboundNatRules - [InboundNatRule object](#InboundNatRule) |
|  privateIPAddress | string | No |  |
|  privateIPAllocationMethod | enum | No | Gets or sets PrivateIP allocation method (Static/Dynamic). - Static or Dynamic |
|  subnet | object | No | [Subnet object](#Subnet) |
|  publicIPAddress | object | No | [PublicIPAddress object](#PublicIPAddress) |
|  provisioningState | string | No |  |


<a id="BackendAddressPool" />
### BackendAddressPool object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [BackendAddressPoolPropertiesFormat object](#BackendAddressPoolPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="InboundNatRule" />
### InboundNatRule object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [InboundNatRulePropertiesFormat object](#InboundNatRulePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="BackendAddressPoolPropertiesFormat" />
### BackendAddressPoolPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  backendIPConfigurations | array | No | Gets collection of references to IPs defined in NICs - [NetworkInterfaceIPConfiguration object](#NetworkInterfaceIPConfiguration) |
|  loadBalancingRules | array | No | Gets Load Balancing rules that use this Backend Address Pool - [SubResource object](#SubResource) |
|  outboundNatRule | object | No | Gets outbound rules that use this Backend Address Pool - [SubResource object](#SubResource) |
|  provisioningState | string | No | Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="InboundNatRulePropertiesFormat" />
### InboundNatRulePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  frontendIPConfiguration | object | No | Gets or sets a reference to frontend IP Addresses - [SubResource object](#SubResource) |
|  backendIPConfiguration | object | No | Gets or sets a reference to a private ip address defined on a NetworkInterface of a VM. Traffic sent to frontendPort of each of the frontendIPConfigurations is forwarded to the backed IP - [NetworkInterfaceIPConfiguration object](#NetworkInterfaceIPConfiguration) |
|  protocol | enum | No | Gets or sets the transport potocol for the external endpoint. Possible values are Udp or Tcp. - Udp or Tcp |
|  frontendPort | integer | No | Gets or sets the port for the external endpoint. You can spcify any port number you choose, but the port numbers specified for each role in the service must be unique. Possible values range between 1 and 65535, inclusive |
|  backendPort | integer | No | Gets or sets a port used for internal connections on the endpoint. The localPort attribute maps the eternal port of the endpoint to an internal port on a role. This is useful in scenarios where a role must communicate to an internal compotnent on a port that is different from the one that is exposed externally. If not specified, the value of localPort is the same as the port attribute. Set the value of localPort to '*' to automatically assign an unallocated port that is discoverable using the runtime API |
|  idleTimeoutInMinutes | integer | No | Gets or sets the timeout for the Tcp idle connection. The value can be set between 4 and 30 minutes. The default value is 4 minutes. This emlement is only used when the protocol is set to Tcp |
|  enableFloatingIP | boolean | No | Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn availability Group. This setting is required when using the SQL Always ON availability Groups in SQL server. This setting can't be changed after you create the endpoint |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |

