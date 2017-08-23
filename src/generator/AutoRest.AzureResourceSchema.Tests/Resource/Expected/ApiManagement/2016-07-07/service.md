# Microsoft.ApiManagement/service template reference
API Version: 2016-07-07
## Template format

To create a Microsoft.ApiManagement/service resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.ApiManagement/service",
  "apiVersion": "2016-07-07",
  "location": "string",
  "tags": {},
  "properties": {
    "publisherEmail": "string",
    "publisherName": "string",
    "provisioningState": "string",
    "targetProvisioningState": "string",
    "createdAtUtc": "string",
    "runtimeUrl": "string",
    "portalUrl": "string",
    "managementApiUrl": "string",
    "scmUrl": "string",
    "addresserEmail": "string",
    "hostnameConfigurations": [
      {
        "type": "string",
        "hostname": "string",
        "certificate": {
          "expiry": "string",
          "thumbprint": "string",
          "subject": "string"
        }
      }
    ],
    "staticIPs": [
      "string"
    ],
    "vpnconfiguration": {
      "subnetResourceId": "string",
      "location": "string"
    },
    "additionalLocations": [
      {
        "location": "string",
        "skuType": "string",
        "skuUnitCount": "integer",
        "staticIPs": [
          "string"
        ],
        "vpnconfiguration": {
          "subnetResourceId": "string",
          "location": "string"
        }
      }
    ],
    "customProperties": {},
    "vpnType": "string"
  },
  "sku": {
    "name": "string",
    "capacity": "integer"
  },
  "resources": []
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ApiManagement/service" />
### Microsoft.ApiManagement/service object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes | The name of the Api Management service. |
|  type | enum | Yes | Microsoft.ApiManagement/service |
|  apiVersion | enum | Yes | 2016-07-07 |
|  location | string | Yes | Api Management service data center location. |
|  tags | object | No | Api Management service tags. A maximum of 10 tags can be provided for a resource, and each tag must have a key no greater than 128 characters (and value no greater than 256 characters) |
|  properties | object | Yes | Properties of the Api Management service. - [ApiServiceProperties object](#ApiServiceProperties) |
|  sku | object | Yes | Sku properties of the Api Management service. - [ApiServiceSkuProperties object](#ApiServiceSkuProperties) |
|  resources | array | No | [openidConnectProviders](./service/openidConnectProviders.md) [properties](./service/properties.md) [loggers](./service/loggers.md) [authorizationServers](./service/authorizationServers.md) [users](./service/users.md) [certificates](./service/certificates.md) [groups](./service/groups.md) [products](./service/products.md) [subscriptions](./service/subscriptions.md) [apis](./service/apis.md) |


<a id="ApiServiceProperties" />
### ApiServiceProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  publisherEmail | string | No | Publisher email. |
|  publisherName | string | No | Publisher name. |
|  provisioningState | string | No | Provisioning state of the Api Management service. |
|  targetProvisioningState | string | No | Target provisioning state of the Api Management service.The state that is targeted for the Api Management service by the infrastructure. |
|  createdAtUtc | string | No | Creation UTC date of the Api Management service.The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard. |
|  runtimeUrl | string | No | Proxy endpoint Url of the Api Management service. |
|  portalUrl | string | No | management portal endpoint Url of the Api Management service. |
|  managementApiUrl | string | No | management api endpoint Url of the Api Management service. |
|  scmUrl | string | No | Scm endpoint Url of the Api Management service. |
|  addresserEmail | string | No | Addresser email. |
|  hostnameConfigurations | array | No | Custom hostname configuration of the Api Management service. - [HostnameConfiguration object](#HostnameConfiguration) |
|  staticIPs | array | No | Static ip addresses of the Api Management service virtual machines. Available only for Standard and Premium Sku. - string |
|  vpnconfiguration | object | No | Virtual network configuration of the Api Management service. - [VirtualNetworkConfiguration object](#VirtualNetworkConfiguration) |
|  additionalLocations | array | No | Additional datacenter locations description of the Api Management service. - [AdditionalRegion object](#AdditionalRegion) |
|  customProperties | object | No | Custom properties of the Api Management service. |
|  vpnType | enum | No | Virtual private network type of the Api Management service. - None, External, Internal |


<a id="ApiServiceSkuProperties" />
### ApiServiceSkuProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | No | Name of the Sku. - Developer, Standard, Premium |
|  capacity | integer | No | Capacity of the Sku (number of deployed units of the Sku). |


<a id="HostnameConfiguration" />
### HostnameConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Hostname type. - Proxy, Portal, Management, Scm |
|  hostname | string | Yes | Hostname. |
|  certificate | object | Yes | Certificate information. - [CertificateInformation object](#CertificateInformation) |


<a id="VirtualNetworkConfiguration" />
### VirtualNetworkConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  subnetResourceId | string | No | Subnet Resource Id. |
|  location | string | No | Virtual network location name. |


<a id="AdditionalRegion" />
### AdditionalRegion object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  location | string | No | Location name. |
|  skuType | enum | No | Sku type in the location. - Developer, Standard, Premium |
|  skuUnitCount | integer | No | Sku Unit count at the location. |
|  staticIPs | array | No | Static IP addresses of the location virtual machines. - string |
|  vpnconfiguration | object | No | Virtual network configuration for the location. - [VirtualNetworkConfiguration object](#VirtualNetworkConfiguration) |


<a id="CertificateInformation" />
### CertificateInformation object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  expiry | string | Yes | Expiration date of the certificate. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard. |
|  thumbprint | string | Yes | Thumbprint of the certificate. |
|  subject | string | Yes | Subject of the certificate. |

