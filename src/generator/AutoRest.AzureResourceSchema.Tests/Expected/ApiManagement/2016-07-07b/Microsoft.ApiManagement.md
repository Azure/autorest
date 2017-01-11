# Microsoft.ApiManagement template schema

Creates a Microsoft.ApiManagement resource.

## Schema format

To create a Microsoft.ApiManagement, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.ApiManagement/service",
  "apiVersion": "2016-07-07",
  "location": "string",
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
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="service" />
## service object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ApiManagement/service**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  location | Yes | string<br /><br />Api Management service data center location. |
|  tags | No | object<br /><br />Api Management service tags. A maximum of 10 tags can be provided for a resource, and each tag must have a key no greater than 128 characters (and value no greater than 256 characters) |
|  properties | Yes | object<br />[ApiServiceProperties object](#ApiServiceProperties)<br /><br />Properties of the Api Management service. |
|  sku | Yes | object<br />[ApiServiceSkuProperties object](#ApiServiceSkuProperties)<br /><br />Sku properties of the Api Management service. |


<a id="ApiServiceProperties" />
## ApiServiceProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  publisherEmail | No | string<br /><br />Publisher email. |
|  publisherName | No | string<br /><br />Publisher name. |
|  provisioningState | No | string<br /><br />Provisioning state of the Api Management service. |
|  targetProvisioningState | No | string<br /><br />Target provisioning state of the Api Management service.The state that is targeted for the Api Management service by the infrastructure. |
|  createdAtUtc | No | string<br /><br />Creation UTC date of the Api Management service.The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
 |
|  runtimeUrl | No | string<br /><br />Proxy endpoint Url of the Api Management service. |
|  portalUrl | No | string<br /><br />management portal endpoint Url of the Api Management service. |
|  managementApiUrl | No | string<br /><br />management api endpoint Url of the Api Management service. |
|  scmUrl | No | string<br /><br />Scm endpoint Url of the Api Management service. |
|  addresserEmail | No | string<br /><br />Addresser email. |
|  hostnameConfigurations | No | array<br />[HostnameConfiguration object](#HostnameConfiguration)<br /><br />Custom hostname configuration of the Api Management service. |
|  staticIPs | No | array<br />**string**<br /><br />Static ip addresses of the Api Management service virtual machines. Available only for Standard and Premium Sku. |
|  vpnconfiguration | No | object<br />[VirtualNetworkConfiguration object](#VirtualNetworkConfiguration)<br /><br />Virtual network configuration of the Api Management service. |
|  additionalLocations | No | array<br />[AdditionalRegion object](#AdditionalRegion)<br /><br />Additional datacenter locations description of the Api Management service. |
|  customProperties | No | object<br /><br />Custom properties of the Api Management service. |
|  vpnType | No | enum<br />**None**, **External**, **Internal**<br /><br />Virtual private network type of the Api Management service. |


<a id="HostnameConfiguration" />
## HostnameConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Proxy**, **Portal**, **Management**, **Scm**<br /><br />Hostname type. |
|  hostname | Yes | string<br /><br />Hostname. |
|  certificate | Yes | object<br />[CertificateInformation object](#CertificateInformation)<br /><br />Certificate information. |


<a id="CertificateInformation" />
## CertificateInformation object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  expiry | Yes | string<br /><br />Expiration date of the certificate. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
 |
|  thumbprint | Yes | string<br /><br />Thumbprint of the certificate. |
|  subject | Yes | string<br /><br />Subject of the certificate. |


<a id="VirtualNetworkConfiguration" />
## VirtualNetworkConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  subnetResourceId | No | string<br /><br />Subnet Resource Id. |
|  location | No | string<br /><br />Virtual network location name. |


<a id="AdditionalRegion" />
## AdditionalRegion object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  location | No | string<br /><br />Location name. |
|  skuType | No | enum<br />**Developer**, **Standard**, **Premium**<br /><br />Sku type in the location. |
|  skuUnitCount | No | integer<br /><br />Sku Unit count at the location. |
|  staticIPs | No | array<br />**string**<br /><br />Static IP addresses of the location virtual machines. |
|  vpnconfiguration | No | object<br />[VirtualNetworkConfiguration object](#VirtualNetworkConfiguration)<br /><br />Virtual network configuration for the location. |


<a id="ApiServiceSkuProperties" />
## ApiServiceSkuProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | enum<br />**Developer**, **Standard**, **Premium**<br /><br />Name of the Sku. |
|  capacity | No | integer<br /><br />Capacity of the Sku (number of deployed units of the Sku). |

