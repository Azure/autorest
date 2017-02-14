# Microsoft.Storage/storageAccounts template reference
API Version: 2016-01-01
## Template format

To create a Microsoft.Storage/storageAccounts resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Storage/storageAccounts",
  "apiVersion": "2016-01-01",
  "sku": {
    "name": "string"
  },
  "kind": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "customDomain": {
      "name": "string",
      "useSubDomain": boolean
    },
    "encryption": {
      "services": {
        "blob": {
          "enabled": boolean
        }
      },
      "keySource": "Microsoft.Storage"
    },
    "accessTier": "string"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Storage/storageAccounts" />
### Microsoft.Storage/storageAccounts object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Storage/storageAccounts |
|  apiVersion | enum | Yes | 2016-01-01 |
|  sku | object | Yes | Required. Gets or sets the sku type. - [Sku object](#Sku) |
|  kind | enum | Yes | Required. Indicates the type of storage account. - Storage or BlobStorage |
|  location | string | Yes | Required. Gets or sets the location of the resource. This will be one of the supported and registered Azure Geo Regions (e.g. West US, East US, Southeast Asia, etc.). The geo region of a resource cannot be changed once it is created, but if an identical geo region is specified on update the request will succeed. |
|  tags | object | No | Gets or sets a list of key value pairs that describe the resource. These tags can be used in viewing and grouping this resource (across resource groups). A maximum of 15 tags can be provided for a resource. Each tag must have a key no greater than 128 characters and value no greater than 256 characters. |
|  properties | object | Yes | [StorageAccountPropertiesCreateParameters object](#StorageAccountPropertiesCreateParameters) |


<a id="Sku" />
### Sku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | Yes | Gets or sets the sku name. Required for account creation, optional for update. Note that in older versions, sku name was called accountType. - Standard_LRS, Standard_GRS, Standard_RAGRS, Standard_ZRS, Premium_LRS |


<a id="StorageAccountPropertiesCreateParameters" />
### StorageAccountPropertiesCreateParameters object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  customDomain | object | No | User domain assigned to the storage account. Name is the CNAME source. Only one custom domain is supported per storage account at this time. To clear the existing custom domain, use an empty string for the custom domain name property. - [CustomDomain object](#CustomDomain) |
|  encryption | object | No | Provides the encryption settings on the account. If left unspecified the account encryption settings will remain. The default setting is unencrypted. - [Encryption object](#Encryption) |
|  accessTier | enum | No | Required for StandardBlob accounts. The access tier used for billing. Access tier cannot be changed more than once every 7 days (168 hours). Access tier cannot be set for StandardLRS, StandardGRS, StandardRAGRS, or PremiumLRS account types. - Hot or Cool |


<a id="CustomDomain" />
### CustomDomain object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes | Gets or sets the custom domain name. Name is the CNAME source. |
|  useSubDomain | boolean | No | Indicates whether indirect CName validation is enabled. Default value is false. This should only be set on updates |


<a id="Encryption" />
### Encryption object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  services | object | No | Gets the services which are encrypted. - [EncryptionServices object](#EncryptionServices) |
|  keySource | enum | Yes | Gets the encryption keySource(provider). Possible values (case-insensitive):  Microsoft.Storage - Microsoft.Storage |


<a id="EncryptionServices" />
### EncryptionServices object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  blob | object | No | The blob service. - [EncryptionService object](#EncryptionService) |


<a id="EncryptionService" />
### EncryptionService object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  enabled | boolean | No | A boolean indicating whether or not the service is encrypted. |

