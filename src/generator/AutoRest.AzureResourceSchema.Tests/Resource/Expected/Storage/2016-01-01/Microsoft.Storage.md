# Microsoft.Storage template schema

Creates a Microsoft.Storage resource.

## Schema format

To create a Microsoft.Storage, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.Storage/storageAccounts",
  "apiVersion": "2016-01-01",
  "sku": {
    "name": "string"
  },
  "kind": "string",
  "location": "string",
  "properties": {
    "customDomain": {
      "name": "string",
      "useSubDomain": "boolean"
    },
    "encryption": {
      "services": {
        "blob": {
          "enabled": "boolean"
        }
      },
      "keySource": "Microsoft.Storage"
    },
    "accessTier": "string"
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="storageAccounts" />
## storageAccounts object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Storage/storageAccounts**<br /> |
|  apiVersion | Yes | enum<br />**2016-01-01**<br /> |
|  sku | Yes | object<br />[Sku object](#Sku)<br /><br />Required. Gets or sets the sku type. |
|  kind | Yes | enum<br />**Storage** or **BlobStorage**<br /><br />Required. Indicates the type of storage account. |
|  location | Yes | string<br /><br />Required. Gets or sets the location of the resource. This will be one of the supported and registered Azure Geo Regions (e.g. West US, East US, Southeast Asia, etc.). The geo region of a resource cannot be changed once it is created, but if an identical geo region is specified on update the request will succeed. |
|  tags | No | object<br /><br />Gets or sets a list of key value pairs that describe the resource. These tags can be used in viewing and grouping this resource (across resource groups). A maximum of 15 tags can be provided for a resource. Each tag must have a key no greater than 128 characters and value no greater than 256 characters. |
|  properties | Yes | object<br />[StorageAccountPropertiesCreateParameters object](#StorageAccountPropertiesCreateParameters)<br /> |


<a id="Sku" />
## Sku object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | Yes | enum<br />**Standard_LRS**, **Standard_GRS**, **Standard_RAGRS**, **Standard_ZRS**, **Premium_LRS**<br /><br />Gets or sets the sku name. Required for account creation, optional for update. Note that in older versions, sku name was called accountType. |


<a id="StorageAccountPropertiesCreateParameters" />
## StorageAccountPropertiesCreateParameters object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  customDomain | No | object<br />[CustomDomain object](#CustomDomain)<br /><br />User domain assigned to the storage account. Name is the CNAME source. Only one custom domain is supported per storage account at this time. To clear the existing custom domain, use an empty string for the custom domain name property. |
|  encryption | No | object<br />[Encryption object](#Encryption)<br /><br />Provides the encryption settings on the account. If left unspecified the account encryption settings will remain. The default setting is unencrypted. |
|  accessTier | No | enum<br />**Hot** or **Cool**<br /><br />Required for StandardBlob accounts. The access tier used for billing. Access tier cannot be changed more than once every 7 days (168 hours). Access tier cannot be set for StandardLRS, StandardGRS, StandardRAGRS, or PremiumLRS account types. |


<a id="CustomDomain" />
## CustomDomain object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | Yes | string<br /><br />Gets or sets the custom domain name. Name is the CNAME source. |
|  useSubDomain | No | boolean<br /><br />Indicates whether indirect CName validation is enabled. Default value is false. This should only be set on updates |


<a id="Encryption" />
## Encryption object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  services | No | object<br />[EncryptionServices object](#EncryptionServices)<br /><br />Gets the services which are encrypted. |
|  keySource | Yes | enum<br />**Microsoft.Storage**<br /><br />Gets the encryption keySource(provider). Possible values (case-insensitive):  Microsoft.Storage |


<a id="EncryptionServices" />
## EncryptionServices object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  blob | No | object<br />[EncryptionService object](#EncryptionService)<br /><br />The blob service. |


<a id="EncryptionService" />
## EncryptionService object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  enabled | No | boolean<br /><br />A boolean indicating whether or not the service is encrypted. |

