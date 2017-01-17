# Microsoft.DataLakeAnalytics/accounts template reference
API Version: 2015-10-01-preview
## Template format

To create a Microsoft.DataLakeAnalytics/accounts resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.DataLakeAnalytics/accounts",
  "apiVersion": "2015-10-01-preview",
  "location": "string",
  "name": "string",
  "tags": {},
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
  },
  "resources": [
    null
  ]
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.DataLakeAnalytics/accounts" />
### Microsoft.DataLakeAnalytics/accounts object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.DataLakeAnalytics/accounts |
|  apiVersion | enum | Yes | 2015-10-01-preview |
|  location | string | No | Gets or sets the account regional location. |
|  name | string | No | Gets or sets the account name. |
|  tags | object | No | Gets or sets the value of custom properties. |
|  properties | object | Yes | Gets or sets the properties defined by Data Lake Analytics all properties are specific to each resource provider. - [DataLakeAnalyticsAccountProperties object](#DataLakeAnalyticsAccountProperties) |
|  resources | array | No | [accounts_DataLakeStoreAccounts_childResource object](#accounts_DataLakeStoreAccounts_childResource) [accounts_StorageAccounts_childResource object](#accounts_StorageAccounts_childResource) |


<a id="DataLakeAnalyticsAccountProperties" />
### DataLakeAnalyticsAccountProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  defaultDataLakeStoreAccount | string | No | Gets or sets the default data lake storage account associated with this Data Lake Analytics account. |
|  maxDegreeOfParallelism | integer | No | Gets or sets the maximum supported degree of parallelism for this account. |
|  maxJobCount | integer | No | Gets or sets the maximum supported jobs running under the account at the same time. |
|  dataLakeStoreAccounts | array | No | Gets or sets the list of Data Lake storage accounts associated with this account. - [DataLakeStoreAccountInfo object](#DataLakeStoreAccountInfo) |
|  storageAccounts | array | No | Gets or sets the list of Azure Blob storage accounts associated with this account. - [StorageAccountInfo object](#StorageAccountInfo) |


<a id="accounts_DataLakeStoreAccounts_childResource" />
### accounts_DataLakeStoreAccounts_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | DataLakeStoreAccounts |
|  apiVersion | enum | Yes | 2015-10-01-preview |
|  properties | object | Yes | Gets or sets the properties for the Data Lake Store account being added. - [DataLakeStoreAccountInfoProperties object](#DataLakeStoreAccountInfoProperties) |


<a id="accounts_StorageAccounts_childResource" />
### accounts_StorageAccounts_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | StorageAccounts |
|  apiVersion | enum | Yes | 2015-10-01-preview |
|  properties | object | Yes | Gets or sets the properties for the Azure Storage account being added. - [StorageAccountProperties object](#StorageAccountProperties) |


<a id="DataLakeStoreAccountInfo" />
### DataLakeStoreAccountInfo object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes | Gets or sets the account name of the Data Lake Store account. |
|  properties | object | No | Gets or sets the properties associated with this Data Lake Store account. - [DataLakeStoreAccountInfoProperties object](#DataLakeStoreAccountInfoProperties) |


<a id="StorageAccountInfo" />
### StorageAccountInfo object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes | Gets or sets the account name associated with the Azure storage account. |
|  properties | object | Yes | Gets or sets the properties associated with this storage account. - [StorageAccountProperties object](#StorageAccountProperties) |


<a id="DataLakeStoreAccountInfoProperties" />
### DataLakeStoreAccountInfoProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  suffix | string | No | Gets or sets the optional suffix for the Data Lake Store account. |


<a id="StorageAccountProperties" />
### StorageAccountProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  accessKey | string | Yes | Gets or sets the access key associated with this Azure Storage account that will be used to connect to it. |
|  suffix | string | No | Gets or sets the optional suffix for the Data Lake account. |

