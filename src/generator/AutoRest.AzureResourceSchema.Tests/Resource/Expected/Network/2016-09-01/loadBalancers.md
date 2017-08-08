# Microsoft.Network/loadBalancers template reference
API Version: 2016-09-01
## Template format

To create a Microsoft.Network/loadBalancers resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Network/loadBalancers",
  "apiVersion": "2016-09-01",
  "id": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "frontendIPConfigurations": [
      {
        "id": "string",
        "properties": {
          "privateIPAddress": "string",
          "privateIPAllocationMethod": "string",
          "subnet": {
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
          },
          "publicIPAddress": {
            "id": "string",
            "location": "string",
            "tags": {},
            "properties": {
              "publicIPAllocationMethod": "string",
              "publicIPAddressVersion": "string",
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
    "backendAddressPools": [
      {
        "id": "string",
        "properties": {
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "loadBalancingRules": [
      {
        "id": "string",
        "properties": {
          "frontendIPConfiguration": {
            "id": "string"
          },
          "backendAddressPool": {
            "id": "string"
          },
          "probe": {
            "id": "string"
          },
          "protocol": "string",
          "loadDistribution": "string",
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
    "probes": [
      {
        "id": "string",
        "properties": {
          "protocol": "string",
          "port": "integer",
          "intervalInSeconds": "integer",
          "numberOfProbes": "integer",
          "requestPath": "string",
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "inboundNatRules": [
      {
        "id": "string",
        "properties": {
          "frontendIPConfiguration": {
            "id": "string"
          },
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
    "inboundNatPools": [
      {
        "id": "string",
        "properties": {
          "frontendIPConfiguration": {
            "id": "string"
          },
          "protocol": "string",
          "frontendPortRangeStart": "integer",
          "frontendPortRangeEnd": "integer",
          "backendPort": "integer",
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "outboundNatRules": [
      {
        "id": "string",
        "properties": {
          "allocatedOutboundPorts": "integer",
          "frontendIPConfigurations": [
            {
              "id": "string"
            }
          ],
          "backendAddressPool": {
            "id": "string"
          },
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
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/loadBalancers" />
### Microsoft.Network/loadBalancers object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Network/loadBalancers |
|  apiVersion | enum | Yes | 2016-09-01 |
|  id | string | No | Resource Id |
|  location | string | No | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [LoadBalancerPropertiesFormat object](#LoadBalancerPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="LoadBalancerPropertiesFormat" />
### LoadBalancerPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  frontendIPConfigurations | array | No | Gets or sets frontend IP addresses of the load balancer - [FrontendIPConfiguration object](#FrontendIPConfiguration) |
|  backendAddressPools | array | No | Gets or sets Pools of backend IP addresses - [BackendAddressPool object](#BackendAddressPool) |
|  loadBalancingRules | array | No | Gets or sets load balancing rules - [LoadBalancingRule object](#LoadBalancingRule) |
|  probes | array | No | Gets or sets list of Load balancer probes - [Probe object](#Probe) |
|  inboundNatRules | array | No | Gets or sets list of inbound rules - [InboundNatRule object](#InboundNatRule) |
|  inboundNatPools | array | No | Gets or sets inbound NAT pools - [InboundNatPool object](#InboundNatPool) |
|  outboundNatRules | array | No | Gets or sets outbound NAT rules - [OutboundNatRule object](#OutboundNatRule) |
|  resourceGuid | string | No | Gets or sets resource guid property of the Load balancer resource |
|  provisioningState | string | No | Gets provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="FrontendIPConfiguration" />
### FrontendIPConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [FrontendIPConfigurationPropertiesFormat object](#FrontendIPConfigurationPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="BackendAddressPool" />
### BackendAddressPool object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [BackendAddressPoolPropertiesFormat object](#BackendAddressPoolPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="LoadBalancingRule" />
### LoadBalancingRule object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [LoadBalancingRulePropertiesFormat object](#LoadBalancingRulePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="Probe" />
### Probe object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ProbePropertiesFormat object](#ProbePropertiesFormat) |
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


<a id="InboundNatPool" />
### InboundNatPool object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [InboundNatPoolPropertiesFormat object](#InboundNatPoolPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="OutboundNatRule" />
### OutboundNatRule object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [OutboundNatRulePropertiesFormat object](#OutboundNatRulePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="FrontendIPConfigurationPropertiesFormat" />
### FrontendIPConfigurationPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  privateIPAddress | string | No | Gets or sets the privateIPAddress of the IP Configuration |
|  privateIPAllocationMethod | enum | No | Gets or sets PrivateIP allocation method. - Static or Dynamic |
|  subnet | object | No | Gets or sets the reference of the subnet resource - [Subnet object](#Subnet) |
|  publicIPAddress | object | No | Gets or sets the reference of the PublicIP resource - [PublicIPAddress object](#PublicIPAddress) |
|  provisioningState | string | No | Gets provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="BackendAddressPoolPropertiesFormat" />
### BackendAddressPoolPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  provisioningState | string | No | Get provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="LoadBalancingRulePropertiesFormat" />
### LoadBalancingRulePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  frontendIPConfiguration | object | No | Gets or sets a reference to frontend IP Addresses - [SubResource object](#SubResource) |
|  backendAddressPool | object | No | Gets or sets  a reference to a pool of DIPs. Inbound traffic is randomly load balanced across IPs in the backend IPs - [SubResource object](#SubResource) |
|  probe | object | No | Gets or sets the reference of the load balancer probe used by the Load Balancing rule. - [SubResource object](#SubResource) |
|  protocol | enum | Yes | Gets or sets the transport protocol for the external endpoint. Possible values are Udp or Tcp. - Udp or Tcp |
|  loadDistribution | enum | No | Gets or sets the load distribution policy for this rule. - Default, SourceIP, SourceIPProtocol |
|  frontendPort | integer | Yes | Gets or sets the port for the external endpoint. You can specify any port number you choose, but the port numbers specified for each role in the service must be unique. Possible values range between 1 and 65535, inclusive |
|  backendPort | integer | No | Gets or sets a port used for internal connections on the endpoint. The localPort attribute maps the eternal port of the endpoint to an internal port on a role. This is useful in scenarios where a role must communicate to an internal component on a port that is different from the one that is exposed externally. If not specified, the value of localPort is the same as the port attribute. Set the value of localPort to '*' to automatically assign an unallocated port that is discoverable using the runtime API |
|  idleTimeoutInMinutes | integer | No | Gets or sets the timeout for the Tcp idle connection. The value can be set between 4 and 30 minutes. The default value is 4 minutes. This element is only used when the protocol is set to Tcp |
|  enableFloatingIP | boolean | No | Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn availability Group. This setting is required when using the SQL Always ON availability Groups in SQL server. This setting can't be changed after you create the endpoint |
|  provisioningState | string | No | Gets provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="ProbePropertiesFormat" />
### ProbePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  protocol | enum | Yes | Gets or sets the protocol of the end point. Possible values are http or Tcp. If Tcp is specified, a received ACK is required for the probe to be successful. If http is specified,a 200 OK response from the specifies URI is required for the probe to be successful. - Http or Tcp |
|  port | integer | Yes | Gets or sets Port for communicating the probe. Possible values range from 1 to 65535, inclusive. |
|  intervalInSeconds | integer | No | Gets or sets the interval, in seconds, for how frequently to probe the endpoint for health status. Typically, the interval is slightly less than half the allocated timeout period (in seconds) which allows two full probes before taking the instance out of rotation. The default value is 15, the minimum value is 5 |
|  numberOfProbes | integer | No | Gets or sets the number of probes where if no response, will result in stopping further traffic from being delivered to the endpoint. This values allows endpoints to be taken out of rotation faster or slower than the typical times used in Azure.  |
|  requestPath | string | No | Gets or sets the URI used for requesting health status from the VM. Path is required if a protocol is set to http. Otherwise, it is not allowed. There is no default value |
|  provisioningState | string | No | Gets provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="InboundNatRulePropertiesFormat" />
### InboundNatRulePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  frontendIPConfiguration | object | No | Gets or sets a reference to frontend IP Addresses - [SubResource object](#SubResource) |
|  protocol | enum | No | Gets or sets the transport protocol for the endpoint. Possible values are Udp or Tcp. - Udp or Tcp |
|  frontendPort | integer | No | Gets or sets the port for the external endpoint. You can specify any port number you choose, but the port numbers specified for each role in the service must be unique. Possible values range between 1 and 65535, inclusive |
|  backendPort | integer | No | Gets or sets a port used for internal connections on the endpoint. The localPort attribute maps the eternal port of the endpoint to an internal port on a role. This is useful in scenarios where a role must communicate to an internal component on a port that is different from the one that is exposed externally. If not specified, the value of localPort is the same as the port attribute. Set the value of localPort to '*' to automatically assign an unallocated port that is discoverable using the runtime API |
|  idleTimeoutInMinutes | integer | No | Gets or sets the timeout for the Tcp idle connection. The value can be set between 4 and 30 minutes. The default value is 4 minutes. This element is only used when the protocol is set to Tcp |
|  enableFloatingIP | boolean | No | Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn availability Group. This setting is required when using the SQL Always ON availability Groups in SQL server. This setting can't be changed after you create the endpoint |
|  provisioningState | string | No | Gets provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="InboundNatPoolPropertiesFormat" />
### InboundNatPoolPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  frontendIPConfiguration | object | No | Gets or sets a reference to frontend IP Addresses - [SubResource object](#SubResource) |
|  protocol | enum | Yes | Gets or sets the transport protocol for the endpoint. Possible values are Udp or Tcp. - Udp or Tcp |
|  frontendPortRangeStart | integer | Yes | Gets or sets the starting port range for the NAT pool. You can specify any port number you choose, but the port numbers specified for each role in the service must be unique. Possible values range between 1 and 65535, inclusive |
|  frontendPortRangeEnd | integer | Yes | Gets or sets the ending port range for the NAT pool. You can specify any port number you choose, but the port numbers specified for each role in the service must be unique. Possible values range between 1 and 65535, inclusive |
|  backendPort | integer | Yes | Gets or sets a port used for internal connections on the endpoint. The localPort attribute maps the eternal port of the endpoint to an internal port on a role. This is useful in scenarios where a role must communicate to an internal component on a port that is different from the one that is exposed externally. If not specified, the value of localPort is the same as the port attribute. Set the value of localPort to '*' to automatically assign an unallocated port that is discoverable using the runtime API |
|  provisioningState | string | No | Gets provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="OutboundNatRulePropertiesFormat" />
### OutboundNatRulePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  allocatedOutboundPorts | integer | No | Gets or sets the number of outbound ports to be used for SNAT |
|  frontendIPConfigurations | array | No | Gets or sets Frontend IP addresses of the load balancer - [SubResource object](#SubResource) |
|  backendAddressPool | object | Yes | Gets or sets a reference to a pool of DIPs. Outbound traffic is randomly load balanced across IPs in the backend IPs - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="Subnet" />
### Subnet object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [SubnetPropertiesFormat object](#SubnetPropertiesFormat) |
|  name | string | No | Gets or sets the name of the resource that is unique within a resource group. This name can be used to access the resource |
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


<a id="SubResource" />
### SubResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |


<a id="SubnetPropertiesFormat" />
### SubnetPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  addressPrefix | string | No | Gets or sets Address prefix for the subnet. |
|  networkSecurityGroup | object | No | Gets or sets the reference of the NetworkSecurityGroup resource - [NetworkSecurityGroup object](#NetworkSecurityGroup) |
|  routeTable | object | No | Gets or sets the reference of the RouteTable resource - [RouteTable object](#RouteTable) |
|  resourceNavigationLinks | array | No | Gets array of references to the external resources using subnet - [ResourceNavigationLink object](#ResourceNavigationLink) |
|  provisioningState | string | No | Gets provisioning state of the resource |


<a id="PublicIPAddressPropertiesFormat" />
### PublicIPAddressPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  publicIPAllocationMethod | enum | No | Gets or sets PublicIP allocation method (Static/Dynamic). - Static or Dynamic |
|  publicIPAddressVersion | enum | No | Gets or sets PublicIP address version (IPv4/IPv6). - IPv4 or IPv6 |
|  dnsSettings | object | No | Gets or sets FQDN of the DNS record associated with the public IP address - [PublicIPAddressDnsSettings object](#PublicIPAddressDnsSettings) |
|  ipAddress | string | No |  |
|  idleTimeoutInMinutes | integer | No | Gets or sets the Idletimeout of the public IP address |
|  resourceGuid | string | No | Gets or sets resource guid property of the PublicIP resource |
|  provisioningState | string | No | Gets provisioning state of the PublicIP resource Updating/Deleting/Failed |


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


<a id="PublicIPAddressDnsSettings" />
### PublicIPAddressDnsSettings object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  domainNameLabel | string | No | Gets or sets the Domain name label.The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. |
|  fqdn | string | No | Gets the FQDN, Fully qualified domain name of the A DNS record associated with the public IP. This is the concatenation of the domainNameLabel and the regionalized DNS zone. |
|  reverseFqdn | string | No | Gets or Sets the Reverse FQDN. A user-visible, fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN.  |


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

