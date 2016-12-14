# Microsoft.MachineLearning template schema

Creates a Microsoft.MachineLearning resource.

## Schema format

To create a Microsoft.MachineLearning, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.MachineLearning/webServices",
  "apiVersion": "2016-05-01-preview",
  "location": "string",
  "properties": {
    "title": "string",
    "description": "string",
    "keys": {
      "primary": "string",
      "secondary": "string"
    },
    "readOnly": "boolean",
    "exposeSampleData": "boolean",
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
    "parameters": {},
    "package": {
      "nodes": {},
      "edges": [
        {
          "sourceNodeId": "string",
          "sourcePortId": "string",
          "targetNodeId": "string",
          "targetPortId": "string"
        }
      ],
      "graphParameters": {}
    },
    "packageType": "Graph"
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="webServices" />
## webServices object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.MachineLearning/webServices**<br /> |
|  apiVersion | Yes | enum<br />**2016-05-01-preview**<br /> |
|  name | No | string<br /><br />Resource Name |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[WebServiceProperties object](#WebServiceProperties)<br /><br />Web service resource properties. |


<a id="WebServiceProperties" />
## WebServiceProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  title | No | string<br /><br />The title of the Azure ML web service. |
|  description | No | string<br /><br />The description of the Azure ML web service. |
|  keys | No | object<br />[WebServiceKeys object](#WebServiceKeys)<br /><br />The set of access keys for the web service. If not specified at creation time (PUT), they will be generated automatically by the resource provider. |
|  readOnly | No | boolean<br /><br />If true, the web service can no longer be updated / patched, only removed. Otherwise, the service resource supports changes. |
|  exposeSampleData | No | boolean<br /><br />Flag that controls whether to expose sample data or not in the web service's swagger definition. |
|  realtimeConfiguration | No | object<br />[RealtimeConfiguration object](#RealtimeConfiguration)<br /><br />Configuration for the service's realtime endpoint. |
|  diagnostics | No | object<br />[DiagnosticsConfiguration object](#DiagnosticsConfiguration)<br /><br />Settings controlling the diagnostics traces collection for the web service. |
|  storageAccount | No | object<br />[StorageAccount object](#StorageAccount)<br /><br />The storage account associated with the service. This is used to store both datasets and diagnostic traces. This information is required at creation time (PUT) and only the key is updateable after that. The account credentials are hidden on a GET web service call. |
|  machineLearningWorkspace | No | object<br />[MachineLearningWorkspace object](#MachineLearningWorkspace)<br /><br />This is only populated at creation time (PUT) for web services originating from an AzureML Studio experiment. |
|  commitmentPlan | No | object<br />[CommitmentPlan object](#CommitmentPlan)<br /><br />The commitment plan associated with this web service. This is required to be specified at creation time (PUT) and is not updateable afterwards. |
|  input | No | object<br />[ServiceInputOutputSpecification object](#ServiceInputOutputSpecification)<br /><br />Swagger schema for the service's input(s), as applicable. |
|  output | No | object<br />[ServiceInputOutputSpecification object](#ServiceInputOutputSpecification)<br /><br />Swagger schema for the service's output(s), as applicable. |
|  exampleRequest | No | object<br />[ExampleRequest object](#ExampleRequest)<br /><br />Sample request data for each of the service's inputs, as applicable. |
|  assets | No | object<br /><br />Set of assets associated with the web service. |
|  parameters | No | object<br /><br />The set of global parameters values defined for the web service, given as a global parameter name to default value map. If no default value is specified, the parameter is considered to be required. |
|  package | No | object<br />[GraphPackage object](#GraphPackage)<br /><br />The definition of the graph package making up this web service. |
|  packageType | No | enum<br />**Graph**<br /> |


<a id="WebServiceKeys" />
## WebServiceKeys object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  primary | No | string<br /><br />The primary access key. |
|  secondary | No | string<br /><br />The secondary access key. |


<a id="RealtimeConfiguration" />
## RealtimeConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  maxConcurrentCalls | No | integer<br /><br />Maximum number of concurrent calls allowed on the realtime endpoint. |


<a id="DiagnosticsConfiguration" />
## DiagnosticsConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  level | Yes | enum<br />**None**, **Error**, **All**<br /><br />Level of tracing to be used: None - disables tracing; Error - collects only error (stderr) traces; All - collects all traces (stdout and stderr). |
|  expiry | No | string<br /><br />Moment of time after which diagnostics are no longer collected. If null, diagnostic collection is not time limited. |


<a id="StorageAccount" />
## StorageAccount object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />The storage account's name. |
|  key | No | string<br /><br />The storage account's active key. |


<a id="MachineLearningWorkspace" />
## MachineLearningWorkspace object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | Yes | string<br /><br />The workspace ARM resource id. |


<a id="CommitmentPlan" />
## CommitmentPlan object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | Yes | string<br /><br />The commitment plan ARM resource  id. |


<a id="ServiceInputOutputSpecification" />
## ServiceInputOutputSpecification object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  title | No | string<br /><br />Swagger schema title. |
|  description | No | string<br /><br />Swagger schema description. |
|  type | Yes | enum<br />**object**<br /><br />The type of the entity described in swagger. Always 'object'. |
|  properties | Yes | object<br /><br />Map of name to swagger schema for each input or output of the web service. |


<a id="TableSpecification" />
## TableSpecification object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  title | No | string<br /><br />Swagger schema title. |
|  description | No | string<br /><br />Swagger schema description. |
|  type | Yes | enum<br />**object**<br /><br />The type of the entity described in swagger. |
|  format | No | string<br /><br />The format, if 'type' is not 'object' |
|  properties | No | object<br /><br />The set of columns within the data table. |


<a id="ColumnSpecification" />
## ColumnSpecification object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Boolean**, **Integer**, **Number**, **String**<br /><br />Data type of the column. |
|  format | No | enum<br />**Byte**, **Char**, **Datetime**, **Double**, **Duration**, **Float**, **Int8**, **Int16**, **Int32**, **Int64**, **Uint8**, **Uint16**, **Uint32**, **Uint64**<br /><br />Additional format information for the data type. |
|  enum | No | array<br />**object**<br /><br />If the data type is categorical, this provides the list of accepted categories. |
|  x-ms-isnullable | No | boolean<br /><br />Flag indicating if the type supports null values or not. |
|  x-ms-isordered | No | boolean<br /><br />Flag indicating whether the categories are treated as an ordered set or not, if this is a categorical column. |


<a id="ExampleRequest" />
## ExampleRequest object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  inputs | No | object<br /><br />Sample input data for the web service's input(s) given as an input name to sample input values matrix map. |
|  globalParameters | No | object<br /><br />Sample input data for the web service's global parameters |


<a id="AssetItem" />
## AssetItem object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | Yes | string<br /><br />Asset's friendly name. |
|  id | No | string<br /><br />Asset's Id. |
|  type | Yes | enum<br />**Module** or **Resource**<br /><br />Asset's type. |
|  locationInfo | Yes | object<br />[AssetLocation object](#AssetLocation)<br /><br />Access information for the asset. |
|  inputPorts | No | object<br /><br />Information about the asset's input ports. |
|  outputPorts | No | object<br /><br />Information about the asset's output ports. |
|  metadata | No | object<br /><br />If the asset is a custom module, this holds the module's metadata. |
|  parameters | No | array<br />[ModuleAssetParameter object](#ModuleAssetParameter)<br /><br />If the asset is a custom module, this holds the module's parameters. |


<a id="AssetLocation" />
## AssetLocation object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  uri | Yes | string<br /><br />The URI where the asset is accessible from, (e.g. aml://abc for system assets or https://xyz for user asets |
|  credentials | No | string<br /><br />Access credentials for the asset, if applicable (e.g. asset specified by storage account connection string + blob URI) |


<a id="InputPort" />
## InputPort object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | No | enum<br />**Dataset**<br /><br />Port data type. |


<a id="OutputPort" />
## OutputPort object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | No | enum<br />**Dataset**<br /><br />Port data type. |


<a id="ModuleAssetParameter" />
## ModuleAssetParameter object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />Parameter name. |
|  parameterType | No | string<br /><br />Parameter type. |
|  modeValuesInfo | No | object<br /><br />Definitions for nested interface parameters if this is a complex module parameter. |


<a id="ModeValueInfo" />
## ModeValueInfo object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  interfaceString | No | string<br /><br />The interface string name for the nested parameter. |
|  parameters | No | array<br />[ModuleAssetParameter object](#ModuleAssetParameter)<br /><br />The definition of the parameter. |


<a id="GraphPackage" />
## GraphPackage object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  nodes | No | object<br /><br />The set of nodes making up the graph, provided as a nodeId to GraphNode map |
|  edges | No | array<br />[GraphEdge object](#GraphEdge)<br /><br />The list of edges making up the graph. |
|  graphParameters | No | object<br /><br />The collection of global parameters for the graph, given as a global parameter name to GraphParameter map. Each parameter here has a 1:1 match with the global parameters values map declared at the WebServiceProperties level. |


<a id="GraphNode" />
## GraphNode object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  assetId | No | string<br /><br />The id of the asset represented by this node. |
|  inputId | No | string<br /><br />The id of the input element represented by this node. |
|  outputId | No | string<br /><br />The id of the output element represented by this node. |
|  parameters | No | object<br /><br />If applicable, parameters of the node. Global graph parameters map into these, with values set at runtime. |


<a id="GraphEdge" />
## GraphEdge object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  sourceNodeId | No | string<br /><br />The source graph node's identifier. |
|  sourcePortId | No | string<br /><br />The identifier of the source node's port that the edge connects from. |
|  targetNodeId | No | string<br /><br />The destination graph node's identifier. |
|  targetPortId | No | string<br /><br />The identifier of the destination node's port that the edge connects into. |


<a id="GraphParameter" />
## GraphParameter object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  description | No | string<br /><br />Description of this graph parameter. |
|  type | Yes | enum<br />**String**, **Int**, **Float**, **Enumerated**, **Script**, **Mode**, **Credential**, **Boolean**, **Double**, **ColumnPicker**, **ParameterRange**, **DataGatewayName**<br /><br />Graph parameter's type. |
|  links | Yes | array<br />[GraphParameterLink object](#GraphParameterLink)<br /><br />Association links for this parameter to nodes in the graph. |


<a id="GraphParameterLink" />
## GraphParameterLink object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  nodeId | Yes | string<br /><br />The graph node's identifier |
|  parameterKey | Yes | string<br /><br />The identifier of the node parameter that the global parameter maps to. |

