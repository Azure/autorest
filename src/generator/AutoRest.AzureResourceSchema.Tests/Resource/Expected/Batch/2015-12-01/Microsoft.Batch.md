# Microsoft.Batch template schema

Creates a Microsoft.Batch resource.

## Schema format

To create a Microsoft.Batch, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.Batch/batchAccounts",
  "apiVersion": "2015-12-01",
  "properties": {
    "autoStorage": {
      "storageAccountId": "string"
    }
  }
}
```
```
{
  "type": "Microsoft.Batch/batchAccounts/applications",
  "apiVersion": "2015-12-01"
}
```
```
{
  "type": "Microsoft.Batch/batchAccounts/applications/versions",
  "apiVersion": "2015-12-01"
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="batchAccounts" />
## batchAccounts object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Batch/batchAccounts**<br /> |
|  apiVersion | Yes | enum<br />**2015-12-01**<br /> |
|  location | No | string<br /><br />The region in which the account is created. |
|  tags | No | object<br /><br />The user specified tags associated with the account. |
|  properties | Yes | object<br />[AccountBaseProperties object](#AccountBaseProperties)<br /><br />The properties of the account. |
|  resources | No | array<br />[applications object](#applications)<br /> |


<a id="batchAccounts_applications" />
## batchAccounts_applications object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Batch/batchAccounts/applications**<br /> |
|  apiVersion | Yes | enum<br />**2015-12-01**<br /> |
|  allowUpdates | No | boolean<br /><br />A value indicating whether packages within the application may be overwritten using the same version string. |
|  displayName | No | string<br /><br />The display name for the application. |
|  resources | No | array<br />[versions object](#versions)<br /> |


<a id="batchAccounts_applications_versions" />
## batchAccounts_applications_versions object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Batch/batchAccounts/applications/versions**<br /> |
|  apiVersion | Yes | enum<br />**2015-12-01**<br /> |


<a id="AccountBaseProperties" />
## AccountBaseProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  autoStorage | No | object<br />[AutoStorageBaseProperties object](#AutoStorageBaseProperties)<br /><br />The properties related to auto storage account. |


<a id="AutoStorageBaseProperties" />
## AutoStorageBaseProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  storageAccountId | Yes | string<br /><br />The resource id of the storage account to be used for auto storage account. |


<a id="batchAccounts_applications_versions_childResource" />
## batchAccounts_applications_versions_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**versions**<br /> |
|  apiVersion | Yes | enum<br />**2015-12-01**<br /> |


<a id="batchAccounts_applications_childResource" />
## batchAccounts_applications_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**applications**<br /> |
|  apiVersion | Yes | enum<br />**2015-12-01**<br /> |
|  allowUpdates | No | boolean<br /><br />A value indicating whether packages within the application may be overwritten using the same version string. |
|  displayName | No | string<br /><br />The display name for the application. |
|  resources | No | array<br />[versions object](#versions)<br /> |

