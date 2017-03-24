# Microsoft.MachineLearning/webServices template reference
API Version: 2016-05-01-preview
## Template format

To create a Microsoft.MachineLearning/webServices resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.MachineLearning/webServices",
  "apiVersion": "2016-05-01-preview",
  "location": "string",
  "tags": {},
  "properties": {
    "packageType": "Graph",
    "title": "string",
    "description": "string",
    "keys": {
      "primary": "string",
      "secondary": "string"
    },
    "readOnly": boolean,
    "exposeSampleData": boolean,
    "realtimeConfiguration": {
      "maxConcurrentCalls": "integer"
    },
    "diagnostics": {
      "level": "string",
      "expiry": "string"
    },
    "storageAccount": {
      "name": "string",
      "key": "string"
    },
    "machineLearningWorkspace": {
      "id": "string"
    },
    "commitmentPlan": {
      "id": "string"
    },
    "input": {
      "title": "string",
      "description": "string",
      "type": "object",
      "properties": {}
    },
    "output": {
      "title": "string",
      "description": "string",
      "type": "object",
      "properties": {}
    },
    "exampleRequest": {
      "inputs": {},
      "globalParameters": {}
    },
    "assets": {},
    "parameters": {}
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.MachineLearning/webServices" />
### Microsoft.MachineLearning/webServices object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.MachineLearning/webServices |
|  apiVersion | enum | Yes | 2016-05-01-preview |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | Web service resource properties. - [WebServiceProperties object](#WebServiceProperties) |


<a id="WebServiceProperties" />
### WebServiceProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  packageType | enum | No | Graph |
|  title | string | No | The title of the Azure ML web service. |
|  description | string | No | The description of the Azure ML web service. |
|  keys | object | No | The set of access keys for the web service. If not specified at creation time (PUT), they will be generated automatically by the resource provider. - [WebServiceKeys object](#WebServiceKeys) |
|  readOnly | boolean | No | If true, the web service can no longer be updated / patched, only removed. Otherwise, the service resource supports changes. |
|  exposeSampleData | boolean | No | Flag that controls whether to expose sample data or not in the web service's swagger definition. |
|  realtimeConfiguration | object | No | Configuration for the service's realtime endpoint. - [RealtimeConfiguration object](#RealtimeConfiguration) |
|  diagnostics | object | No | Settings controlling the diagnostics traces collection for the web service. - [DiagnosticsConfiguration object](#DiagnosticsConfiguration) |
|  storageAccount | object | No | The storage account associated with the service. This is used to store both datasets and diagnostic traces. This information is required at creation time (PUT) and only the key is updateable after that. The account credentials are hidden on a GET web service call. - [StorageAccount object](#StorageAccount) |
|  machineLearningWorkspace | object | No | This is only populated at creation time (PUT) for web services originating from an AzureML Studio experiment. - [MachineLearningWorkspace object](#MachineLearningWorkspace) |
|  commitmentPlan | object | No | The commitment plan associated with this web service. This is required to be specified at creation time (PUT) and is not updateable afterwards. - [CommitmentPlan object](#CommitmentPlan) |
|  input | object | No | Swagger schema for the service's input(s), as applicable. - [ServiceInputOutputSpecification object](#ServiceInputOutputSpecification) |
|  output | object | No | Swagger schema for the service's output(s), as applicable. - [ServiceInputOutputSpecification object](#ServiceInputOutputSpecification) |
|  exampleRequest | object | No | Sample request data for each of the service's inputs, as applicable. - [ExampleRequest object](#ExampleRequest) |
|  assets | object | No | Set of assets associated with the web service. |
|  parameters | object | No | The set of global parameters values defined for the web service, given as a global parameter name to default value map. If no default value is specified, the parameter is considered to be required. |


<a id="WebServiceKeys" />
### WebServiceKeys object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  primary | string | No | The primary access key. |
|  secondary | string | No | The secondary access key. |


<a id="RealtimeConfiguration" />
### RealtimeConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  maxConcurrentCalls | integer | No | Maximum number of concurrent calls allowed on the realtime endpoint. |


<a id="DiagnosticsConfiguration" />
### DiagnosticsConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  level | enum | Yes | Level of tracing to be used: None - disables tracing; Error - collects only error (stderr) traces; All - collects all traces (stdout and stderr). - None, Error, All |
|  expiry | string | No | Moment of time after which diagnostics are no longer collected. If null, diagnostic collection is not time limited. |


<a id="StorageAccount" />
### StorageAccount object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | The storage account's name. |
|  key | string | No | The storage account's active key. |


<a id="MachineLearningWorkspace" />
### MachineLearningWorkspace object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | Yes | The workspace ARM resource id. |


<a id="CommitmentPlan" />
### CommitmentPlan object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | Yes | The commitment plan ARM resource  id. |


<a id="ServiceInputOutputSpecification" />
### ServiceInputOutputSpecification object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  title | string | No | Swagger schema title. |
|  description | string | No | Swagger schema description. |
|  type | enum | Yes | The type of the entity described in swagger. Always 'object'. - object |
|  properties | object | Yes | Map of name to swagger schema for each input or output of the web service. |


<a id="ExampleRequest" />
### ExampleRequest object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  inputs | object | No | Sample input data for the web service's input(s) given as an input name to sample input values matrix map. |
|  globalParameters | object | No | Sample input data for the web service's global parameters |

