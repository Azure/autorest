# Microsoft.DataLakeAnalytics template schema

Creates a Microsoft.DataLakeAnalytics resource.

## Schema format

To create a Microsoft.DataLakeAnalytics, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.DataLakeAnalytics/accounts/StorageAccounts",
  "apiVersion": "2015-10-01-preview",
  "properties": {
    "accessKey": "string",
    "suffix": "string"
  }
}
```
```
{
  "type": "Microsoft.DataLakeAnalytics/accounts/DataLakeStoreAccounts",
  "apiVersion": "2015-10-01-preview",
  "properties": {
    "suffix": "string"
  }
}
```
```
{
  "type": "Microsoft.DataLakeAnalytics/accounts",
  "apiVersion": "2015-10-01-preview",
  "properties": {
    "defaultDataLakeStoreAccount": "string",
    "maxDegreeOfParallelism": "integer",
    "maxJobCount": "integer",
    "dataLakeStoreAccounts": [
      {
        "name": "string",
        "properties": {
          "suffix": "string"
        }
      }
    ],
    "storageAccounts": [
      {
        "name": "string",
        "properties": {
          "accessKey": "string",
          "suffix": "string"
        }
      }
    ]
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="accounts_StorageAccounts" />
## accounts_StorageAccounts object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.DataLakeAnalytics/accounts/StorageAccounts**<br /> |
|  apiVersion | Yes | enum<br />**2015-10-01-preview**<br /> |
|  properties | Yes | object<br />[StorageAccountProperties object](#StorageAccountProperties)<br /><br />Gets or sets the properties for the Azure Storage account being added. |


<a id="accounts_DataLakeStoreAccounts" />
## accounts_DataLakeStoreAccounts object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.DataLakeAnalytics/accounts/DataLakeStoreAccounts**<br /> |
|  apiVersion | Yes | enum<br />**2015-10-01-preview**<br /> |
|  properties | Yes | object<br />[DataLakeStoreAccountInfoProperties object](#DataLakeStoreAccountInfoProperties)<br /><br />Gets or sets the properties for the Data Lake Store account being added. |


<a id="accounts" />
## accounts object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.DataLakeAnalytics/accounts**<br /> |
|  apiVersion | Yes | enum<br />**2015-10-01-preview**<br /> |
|  location | No | string<br /><br />Gets or sets the account regional location. |
|  name | No | string<br /><br />Gets or sets the account name. |
|  tags | No | object<br /><br />Gets or sets the value of custom properties. |
|  properties | Yes | object<br />[DataLakeAnalyticsAccountProperties object](#DataLakeAnalyticsAccountProperties)<br /><br />Gets or sets the properties defined by Data Lake Analytics all properties are specific to each resource provider. |
|  resources | No | array<br />[DataLakeStoreAccounts object](#DataLakeStoreAccounts)<br />[StorageAccounts object](#StorageAccounts)<br /> |


<a id="StorageAccountProperties" />
## StorageAccountProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  accessKey | Yes | string<br /><br />Gets or sets the access key associated with this Azure Storage account that will be used to connect to it. |
|  suffix | No | string<br /><br />Gets or sets the optional suffix for the Data Lake account. |


<a id="DataLakeStoreAccountInfoProperties" />
## DataLakeStoreAccountInfoProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  suffix | No | string<br /><br />Gets or sets the optional suffix for the Data Lake Store account. |


<a id="DataLakeAnalyticsAccountProperties" />
## DataLakeAnalyticsAccountProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  defaultDataLakeStoreAccount | No | string<br /><br />Gets or sets the default data lake storage account associated with this Data Lake Analytics account. |
|  maxDegreeOfParallelism | No | integer<br /><br />Gets or sets the maximum supported degree of parallelism for this account. |
|  maxJobCount | No | integer<br /><br />Gets or sets the maximum supported jobs running under the account at the same time. |
|  dataLakeStoreAccounts | No | array<br />[DataLakeStoreAccountInfo object](#DataLakeStoreAccountInfo)<br /><br />Gets or sets the list of Data Lake storage accounts associated with this account. |
|  storageAccounts | No | array<br />[StorageAccountInfo object](#StorageAccountInfo)<br /><br />Gets or sets the list of Azure Blob storage accounts associated with this account. |


<a id="DataLakeStoreAccountInfo" />
## DataLakeStoreAccountInfo object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | Yes | string<br /><br />Gets or sets the account name of the Data Lake Store account. |
|  properties | No | object<br />[DataLakeStoreAccountInfoProperties object](#DataLakeStoreAccountInfoProperties)<br /><br />Gets or sets the properties associated with this Data Lake Store account. |


<a id="StorageAccountInfo" />
## StorageAccountInfo object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | Yes | string<br /><br />Gets or sets the account name associated with the Azure storage account. |
|  properties | Yes | object<br />[StorageAccountProperties object](#StorageAccountProperties)<br /><br />Gets or sets the properties associated with this storage account. |


<a id="accounts_DataLakeStoreAccounts_childResource" />
## accounts_DataLakeStoreAccounts_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**DataLakeStoreAccounts**<br /> |
|  apiVersion | Yes | enum<br />**2015-10-01-preview**<br /> |
|  properties | Yes | object<br />[DataLakeStoreAccountInfoProperties object](#DataLakeStoreAccountInfoProperties)<br /><br />Gets or sets the properties for the Data Lake Store account being added. |


<a id="accounts_StorageAccounts_childResource" />
## accounts_StorageAccounts_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**StorageAccounts**<br /> |
|  apiVersion | Yes | enum<br />**2015-10-01-preview**<br /> |
|  properties | Yes | object<br />[StorageAccountProperties object](#StorageAccountProperties)<br /><br />Gets or sets the properties for the Azure Storage account being added. |

