# Microsoft.Network/loadBalancers template reference
API Version: 2015-05-01-preview
## Template format

To create a Microsoft.Network/loadBalancers resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Network/loadBalancers",
  "apiVersion": "2015-05-01-preview",
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
            "id": "string"
          },
          "publicIPAddress": {
            "id": "string"
          },
          "inboundNatRules": [
            {
              "id": "string"
            }
          ],
          "inboundNatPools": [
            {
              "id": "string"
            }
          ],
          "outboundNatRules": [
            {
              "id": "string"
            }
          ],
          "loadBalancingRules": [
            {
              "id": "string"
            }
          ],
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
          "backendIPConfigurations": [
            {
              "id": "string"
            }
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
          "loadBalancingRules": [
            {
              "id": "string"
            }
          ],
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
          "backendIPConfiguration": {
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
|  type | enum | Yes | Microsoft.Network/loadBalancers |
|  apiVersion | enum | Yes | 2015-05-01-preview |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [LoadBalancerPropertiesFormat object](#LoadBalancerPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="LoadBalancerPropertiesFormat" />
### LoadBalancerPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  frontendIPConfigurations | array | No | Gets or sets frontend IP addresses of the load balancer - [FrontendIpConfiguration object](#FrontendIpConfiguration) |
|  backendAddressPools | array | No | Gets or sets Pools of backend IP addresseses - [BackendAddressPool object](#BackendAddressPool) |
|  loadBalancingRules | array | No | Gets or sets loadbalancing rules - [LoadBalancingRule object](#LoadBalancingRule) |
|  probes | array | No | Gets or sets list of Load balancer probes - [Probe object](#Probe) |
|  inboundNatRules | array | No | Gets or sets list of inbound rules - [InboundNatRule object](#InboundNatRule) |
|  inboundNatPools | array | No | Gets or sets inbound NAT pools - [InboundNatPool object](#InboundNatPool) |
|  outboundNatRules | array | No | Gets or sets outbound NAT rules - [OutboundNatRule object](#OutboundNatRule) |
|  resourceGuid | string | No | Gets or sets resource guid property of the Load balancer resource |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="FrontendIpConfiguration" />
### FrontendIpConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [FrontendIpConfigurationPropertiesFormat object](#FrontendIpConfigurationPropertiesFormat) |
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


<a id="FrontendIpConfigurationPropertiesFormat" />
### FrontendIpConfigurationPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  privateIPAddress | string | No | Gets or sets the IP address of the Load Balancer.This is only specified if a specific private IP address shall be allocated from the subnet specified in subnetRef |
|  privateIPAllocationMethod | enum | No | Gets or sets PrivateIP allocation method (Static/Dynamic). - Static or Dynamic |
|  subnet | object | No | Gets or sets the reference of the subnet resource.A subnet from wher the load balancer gets its private frontend address  - [SubResource object](#SubResource) |
|  publicIPAddress | object | No | Gets or sets the reference of the PublicIP resource - [SubResource object](#SubResource) |
|  inboundNatRules | array | No | Read only.Inbound rules URIs that use this frontend IP - [SubResource object](#SubResource) |
|  inboundNatPools | array | No | Read only.Inbound pools URIs that use this frontend IP - [SubResource object](#SubResource) |
|  outboundNatRules | array | No | Read only.Outbound rules URIs that use this frontend IP - [SubResource object](#SubResource) |
|  loadBalancingRules | array | No | Gets Load Balancing rules URIs that use this frontend IP - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="BackendAddressPoolPropertiesFormat" />
### BackendAddressPoolPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  backendIPConfigurations | array | No | Gets collection of references to IPs defined in NICs - [SubResource object](#SubResource) |
|  loadBalancingRules | array | No | Gets Load Balancing rules that use this Backend Address Pool - [SubResource object](#SubResource) |
|  outboundNatRule | object | No | Gets outbound rules that use this Backend Address Pool - [SubResource object](#SubResource) |
|  provisioningState | string | No | Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="LoadBalancingRulePropertiesFormat" />
### LoadBalancingRulePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  frontendIPConfiguration | object | No | Gets or sets a reference to frontend IP Addresses - [SubResource object](#SubResource) |
|  backendAddressPool | object | Yes | Gets or sets  a reference to a pool of DIPs. Inbound traffic is randomly load balanced across IPs in the backend IPs - [SubResource object](#SubResource) |
|  probe | object | No | Gets or sets the reference of the load balancer probe used by the Load Balancing rule. - [SubResource object](#SubResource) |
|  protocol | enum | Yes | Gets or sets the transport protocol for the external endpoint. Possible values are Udp or Tcp. - Udp or Tcp |
|  loadDistribution | enum | No | Gets or sets the load distribution policy for this rule. - Default, SourceIP, SourceIPProtocol |
|  frontendPort | integer | Yes | Gets or sets the port for the external endpoint. You can specify any port number you choose, but the port numbers specified for each role in the service must be unique. Possible values range between 1 and 65535, inclusive |
|  backendPort | integer | No | Gets or sets a port used for internal connections on the endpoint. The localPort attribute maps the eternal port of the endpoint to an internal port on a role. This is useful in scenarios where a role must communicate to an internal compotnent on a port that is different from the one that is exposed externally. If not specified, the value of localPort is the same as the port attribute. Set the value of localPort to '*' to automatically assign an unallocated port that is discoverable using the runtime API |
|  idleTimeoutInMinutes | integer | No | Gets or sets the timeout for the Tcp idle connection. The value can be set between 4 and 30 minutes. The default value is 4 minutes. This emlement is only used when the protocol is set to Tcp |
|  enableFloatingIP | boolean | Yes | Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn availability Group. This setting is required when using the SQL Always ON availability Groups in SQL server. This setting can't be changed after you create the endpoint |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="ProbePropertiesFormat" />
### ProbePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  loadBalancingRules | array | No | Gets Load balancer rules that use this probe - [SubResource object](#SubResource) |
|  protocol | enum | Yes | Gets or sets the protocol of the end point. Possible values are http pr Tcp. If Tcp is specified, a received ACK is required for the probe to be successful. If http is specified,a 200 OK response from the specifies URI is required for the probe to be successful. - Http or Tcp |
|  port | integer | Yes | Gets or sets Port for communicating the probe. Possible values range from 1 to 65535, inclusive. |
|  intervalInSeconds | integer | No | Gets or sets the interval, in seconds, for how frequently to probe the endpoint for health status. Typically, the interval is slightly less than half the allocated timeout period (in seconds) which allows two full probes before taking the instance out of rotation. The default value is 15, the minimum value is 5 |
|  numberOfProbes | integer | No | Gets or sets the number of probes where if no response, will result in stopping further traffic from being delivered to the endpoint. This values allows endponints to be taken out of rotation faster or slower than the typical times used in Azure.  |
|  requestPath | string | No | Gets or sets the URI used for requesting health status from the VM. Path is required if a protocol is set to http. Otherwise, it is not allowed. There is no default value |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="InboundNatRulePropertiesFormat" />
### InboundNatRulePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  frontendIPConfiguration | object | No | Gets or sets a reference to frontend IP Addresses - [SubResource object](#SubResource) |
|  backendIPConfiguration | object | No | Gets or sets a reference to a private ip address defined on a NetworkInterface of a VM. Traffic sent to frontendPort of each of the frontendIPConfigurations is forwarded to the backed IP - [SubResource object](#SubResource) |
|  protocol | enum | Yes | Gets or sets the transport potocol for the external endpoint. Possible values are Udp or Tcp. - Udp or Tcp |
|  frontendPort | integer | Yes | Gets or sets the port for the external endpoint. You can spcify any port number you choose, but the port numbers specified for each role in the service must be unique. Possible values range between 1 and 65535, inclusive |
|  backendPort | integer | No | Gets or sets a port used for internal connections on the endpoint. The localPort attribute maps the eternal port of the endpoint to an internal port on a role. This is useful in scenarios where a role must communicate to an internal compotnent on a port that is different from the one that is exposed externally. If not specified, the value of localPort is the same as the port attribute. Set the value of localPort to '*' to automatically assign an unallocated port that is discoverable using the runtime API |
|  idleTimeoutInMinutes | integer | No | Gets or sets the timeout for the Tcp idle connection. The value can be set between 4 and 30 minutes. The default value is 4 minutes. This emlement is only used when the protocol is set to Tcp |
|  enableFloatingIP | boolean | Yes | Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn availability Group. This setting is required when using the SQL Always ON availability Groups in SQL server. This setting can't be changed after you create the endpoint |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="InboundNatPoolPropertiesFormat" />
### InboundNatPoolPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  frontendIPConfiguration | object | No | Gets or sets a reference to frontend IP Addresses - [SubResource object](#SubResource) |
|  protocol | enum | Yes | Gets or sets the transport potocol for the external endpoint. Possible values are Udp or Tcp. - Udp or Tcp |
|  frontendPortRangeStart | integer | Yes | Gets or sets the starting port range for the NAT pool. You can spcify any port number you choose, but the port numbers specified for each role in the service must be unique. Possible values range between 1 and 65535, inclusive |
|  frontendPortRangeEnd | integer | Yes | Gets or sets the ending port range for the NAT pool. You can spcify any port number you choose, but the port numbers specified for each role in the service must be unique. Possible values range between 1 and 65535, inclusive |
|  backendPort | integer | Yes | Gets or sets a port used for internal connections on the endpoint. The localPort attribute maps the eternal port of the endpoint to an internal port on a role. This is useful in scenarios where a role must communicate to an internal compotnent on a port that is different from the one that is exposed externally. If not specified, the value of localPort is the same as the port attribute. Set the value of localPort to '*' to automatically assign an unallocated port that is discoverable using the runtime API |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="OutboundNatRulePropertiesFormat" />
### OutboundNatRulePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  allocatedOutboundPorts | integer | Yes | Gets or sets the number of outbound ports to be used for SNAT |
|  frontendIPConfigurations | array | No | Gets or sets Frontend IP addresses of the load balancer - [SubResource object](#SubResource) |
|  backendAddressPool | object | Yes | Gets or sets a reference to a pool of DIPs. Outbound traffic is randomly load balanced across IPs in the backend IPs - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="SubResource" />
### SubResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |

