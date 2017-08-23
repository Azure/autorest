# Microsoft.Network/applicationGateways template reference
API Version: 2015-05-01-preview
## Template format

To create a Microsoft.Network/applicationGateways resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Network/applicationGateways",
  "apiVersion": "2015-05-01-preview",
  "location": "string",
  "tags": {},
  "properties": {
    "sku": {
      "name": "string",
      "tier": "Standard",
      "capacity": "integer"
    },
    "gatewayIPConfigurations": [
      {
        "id": "string",
        "properties": {
          "subnet": {
            "id": "string"
          },
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "sslCertificates": [
      {
        "id": "string",
        "properties": {
          "data": "string",
          "password": "string",
          "publicCertData": "string",
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
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
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "frontendPorts": [
      {
        "id": "string",
        "properties": {
          "port": "integer",
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
          "backendAddresses": [
            {
              "fqdn": "string",
              "ipAddress": "string"
            }
          ],
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "backendHttpSettingsCollection": [
      {
        "id": "string",
        "properties": {
          "port": "integer",
          "protocol": "string",
          "cookieBasedAffinity": "string",
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "httpListeners": [
      {
        "id": "string",
        "properties": {
          "frontendIPConfiguration": {
            "id": "string"
          },
          "frontendPort": {
            "id": "string"
          },
          "protocol": "string",
          "sslCertificate": {
            "id": "string"
          },
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "requestRoutingRules": [
      {
        "id": "string",
        "properties": {
          "ruleType": "Basic",
          "backendAddressPool": {
            "id": "string"
          },
          "backendHttpSettings": {
            "id": "string"
          },
          "httpListener": {
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

<a id="Microsoft.Network/applicationGateways" />
### Microsoft.Network/applicationGateways object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Network/applicationGateways |
|  apiVersion | enum | Yes | 2015-05-01-preview |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [ApplicationGatewayPropertiesFormat object](#ApplicationGatewayPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayPropertiesFormat" />
### ApplicationGatewayPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  sku | object | No | Gets or sets sku of application gateway resource - [ApplicationGatewaySku object](#ApplicationGatewaySku) |
|  gatewayIPConfigurations | array | No | Gets or sets subnets of application gateway resource - [ApplicationGatewayIPConfiguration object](#ApplicationGatewayIPConfiguration) |
|  sslCertificates | array | No | Gets or sets ssl certificates of application gateway resource - [ApplicationGatewaySslCertificate object](#ApplicationGatewaySslCertificate) |
|  frontendIPConfigurations | array | No | Gets or sets frontend IP addresses of application gateway resource - [ApplicationGatewayFrontendIPConfiguration object](#ApplicationGatewayFrontendIPConfiguration) |
|  frontendPorts | array | No | Gets or sets frontend ports of application gateway resource - [ApplicationGatewayFrontendPort object](#ApplicationGatewayFrontendPort) |
|  backendAddressPools | array | No | Gets or sets backend address pool of application gateway resource - [ApplicationGatewayBackendAddressPool object](#ApplicationGatewayBackendAddressPool) |
|  backendHttpSettingsCollection | array | No | Gets or sets backend http settings of application gateway resource - [ApplicationGatewayBackendHttpSettings object](#ApplicationGatewayBackendHttpSettings) |
|  httpListeners | array | No | Gets or sets HTTP listeners of application gateway resource - [ApplicationGatewayHttpListener object](#ApplicationGatewayHttpListener) |
|  requestRoutingRules | array | No | Gets or sets request routing rules of application gateway resource - [ApplicationGatewayRequestRoutingRule object](#ApplicationGatewayRequestRoutingRule) |
|  resourceGuid | string | No | Gets or sets resource guid property of the ApplicationGateway resource |
|  provisioningState | string | No | Gets or sets Provisioning state of the ApplicationGateway resource Updating/Deleting/Failed |


<a id="ApplicationGatewaySku" />
### ApplicationGatewaySku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | No | Gets or sets name of application gateway SKU. - Standard_Small, Standard_Medium, Standard_Large |
|  tier | enum | No | Gets or sets tier of application gateway. - Standard |
|  capacity | integer | No | Gets or sets capacity (instance count) of application gateway |


<a id="ApplicationGatewayIPConfiguration" />
### ApplicationGatewayIPConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayIPConfigurationPropertiesFormat object](#ApplicationGatewayIPConfigurationPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewaySslCertificate" />
### ApplicationGatewaySslCertificate object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewaySslCertificatePropertiesFormat object](#ApplicationGatewaySslCertificatePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayFrontendIPConfiguration" />
### ApplicationGatewayFrontendIPConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayFrontendIPConfigurationPropertiesFormat object](#ApplicationGatewayFrontendIPConfigurationPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayFrontendPort" />
### ApplicationGatewayFrontendPort object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayFrontendPortPropertiesFormat object](#ApplicationGatewayFrontendPortPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayBackendAddressPool" />
### ApplicationGatewayBackendAddressPool object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayBackendAddressPoolPropertiesFormat object](#ApplicationGatewayBackendAddressPoolPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayBackendHttpSettings" />
### ApplicationGatewayBackendHttpSettings object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayBackendHttpSettingsPropertiesFormat object](#ApplicationGatewayBackendHttpSettingsPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayHttpListener" />
### ApplicationGatewayHttpListener object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayHttpListenerPropertiesFormat object](#ApplicationGatewayHttpListenerPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayRequestRoutingRule" />
### ApplicationGatewayRequestRoutingRule object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayRequestRoutingRulePropertiesFormat object](#ApplicationGatewayRequestRoutingRulePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayIPConfigurationPropertiesFormat" />
### ApplicationGatewayIPConfigurationPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  subnet | object | No | Gets or sets the reference of the subnet resource.A subnet from where appliation gateway gets its private address  - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets or sets Provisioning state of the application gateway subnet resource Updating/Deleting/Failed |


<a id="ApplicationGatewaySslCertificatePropertiesFormat" />
### ApplicationGatewaySslCertificatePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  data | string | No | Gets or sets the certificate data  |
|  password | string | No | Gets or sets the certificate password  |
|  publicCertData | string | No | Gets or sets the certificate public data  |
|  provisioningState | string | No | Gets or sets Provisioning state of the ssl certificate resource Updating/Deleting/Failed |


<a id="ApplicationGatewayFrontendIPConfigurationPropertiesFormat" />
### ApplicationGatewayFrontendIPConfigurationPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  privateIPAddress | string | No | Gets or sets the privateIPAddress of the Network Interface IP Configuration |
|  privateIPAllocationMethod | enum | No | Gets or sets PrivateIP allocation method (Static/Dynamic). - Static or Dynamic |
|  subnet | object | No | Gets or sets the reference of the subnet resource - [SubResource object](#SubResource) |
|  publicIPAddress | object | No | Gets or sets the reference of the PublicIP resource - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="ApplicationGatewayFrontendPortPropertiesFormat" />
### ApplicationGatewayFrontendPortPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  port | integer | No | Gets or sets the frontend port |
|  provisioningState | string | No | Gets or sets Provisioning state of the frontend port resource Updating/Deleting/Failed |


<a id="ApplicationGatewayBackendAddressPoolPropertiesFormat" />
### ApplicationGatewayBackendAddressPoolPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  backendIPConfigurations | array | No | Gets or sets backendIPConfiguration of application gateway  - [SubResource object](#SubResource) |
|  backendAddresses | array | No | Gets or sets the backend addresses - [ApplicationGatewayBackendAddress object](#ApplicationGatewayBackendAddress) |
|  provisioningState | string | No | Gets or sets Provisioning state of the backend address pool resource Updating/Deleting/Failed |


<a id="ApplicationGatewayBackendHttpSettingsPropertiesFormat" />
### ApplicationGatewayBackendHttpSettingsPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  port | integer | No | Gets or sets the port |
|  protocol | enum | No | Gets or sets the protocol. - Http or Https |
|  cookieBasedAffinity | enum | No | Gets or sets the cookie affinity. - Enabled or Disabled |
|  provisioningState | string | No | Gets or sets Provisioning state of the backend http settings resource Updating/Deleting/Failed |


<a id="ApplicationGatewayHttpListenerPropertiesFormat" />
### ApplicationGatewayHttpListenerPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  frontendIPConfiguration | object | No | Gets or sets frontend IP configuration resource of application gateway  - [SubResource object](#SubResource) |
|  frontendPort | object | No | Gets or sets frontend port resource of application gateway  - [SubResource object](#SubResource) |
|  protocol | enum | No | Gets or sets the protocol. - Http or Https |
|  sslCertificate | object | No | Gets or sets ssl certificate resource of application gateway  - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets or sets Provisioning state of the http listener resource Updating/Deleting/Failed |


<a id="ApplicationGatewayRequestRoutingRulePropertiesFormat" />
### ApplicationGatewayRequestRoutingRulePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  ruleType | enum | No | Gets or sets the rule type. - Basic |
|  backendAddressPool | object | No | Gets or sets backend address pool resource of application gateway  - [SubResource object](#SubResource) |
|  backendHttpSettings | object | No | Gets or sets frontend port resource of application gateway  - [SubResource object](#SubResource) |
|  httpListener | object | No | Gets or sets http listener resource of application gateway  - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets or sets Provisioning state of the request routing rule resource Updating/Deleting/Failed |


<a id="SubResource" />
### SubResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |


<a id="ApplicationGatewayBackendAddress" />
### ApplicationGatewayBackendAddress object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  fqdn | string | No | Gets or sets the dns name |
|  ipAddress | string | No | Gets or sets the ip address |

