# Search Management

## General (`$.info`, `description`)

> the above JSON query pushes this markdown section into node `$.info.description` of the OpenAPI definition.
> Furthermore, it "enters" scope `$.info`, meaning that all annotations on subheadings will have `@` point to that node (see below for examples).
> 
> The second part (`description`) can be omitted, but is useful for specifying other fields like `summary`.
>
> To set a description without entering a scope, one could have used (`$`, `info.description`)

This client that can be used to manage Azure Search services and API keys.

```yaml
swagger: '2.0'
info:
  title: Search Management
  # `description` will be injected.
  # If it was specified here, it would be overridden.
  version: '2015-02-28'
host: management.azure.com
schemes:
- https
consumes:
- application/json
produces:
- application/json
```

## Security

```yaml
security:
- azure_auth:
  - user_impersonation
securityDefinitions:
  azure_auth:
    type: oauth2
    authorizationUrl: https://login.microsoftonline.com/common/oauth2/authorize
    flow: implicit
    description: Azure Active Directory OAuth2 Flow
    scopes:
      user_impersonation: impersonate your user account
```

## Operations on Query Keys

### List (`#QueryKeys_List`)

> `#QueryKeys_List` is shorthand for `$..[?(@.operationId == "QueryKeys_List")]`

Returns the list of query API keys for the given Azure Search service.

```yaml
paths:
  '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{serviceName}/listQueryKeys':
    get:
      tags:
      - QueryKeys
      operationId: QueryKeys_List
      externalDocs:
        url: https://msdn.microsoft.com/library/azure/dn832701.aspx
      parameters:
      - '$ref': '#/parameters/ResourceGroupName'
      - '$ref': '#/parameters/SearchServiceName'
      - '$ref': '#/parameters/ApiVersion'
      - '$ref': '#/parameters/SubscriptionId'
      responses:
        '200':
          description: OK
          schema:
            '$ref': '#/definitions/ListQueryKeysResult'
        default:
          '$ref': '#/responses/error'
```

#### Parameter: Search Service Name (`@.parameters[1]`)

Some description.

### Model Definition: ListQueryKeysResult (`$.definitions.ListQueryKeysResult`)

Response containing the query API keys for a given Azure Search service.

```yaml
definitions:
  ListQueryKeysResult:
    properties:
      value:
        readOnly: true
        type: array
        items:
          '$ref': '#/definitions/QueryKey'
```

#### Examples
I am content under a subheading 

#### Property: value (`@.properties.value`)
The query keys for the Azure Search service.

### Model Definition: QueryKey (`$.definitions.QueryKey`)

Describes an API key for a given Azure Search service that has permissions for query operations only.

```yaml
definitions:
  QueryKey:
    properties:
      name:
        readOnly: true
        type: string
      key:
        readOnly: true
        type: string
```

#### Property: name (`@.properties.name`)
The name of the query API key; may be empty.

#### Property: key (`@.properties.key`)
The value of the query API key.

## Operations on Services

### CreateOrUpdate (`#Services_CreateOrUpdate`)

Creates or updates a Search service in the given resource group.
If the Search service already exists, all properties will be updated with the given values.

```yaml
paths:
  '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{serviceName}':
    put:
      tags:
      - Services
      operationId: Services_CreateOrUpdate
      externalDocs:
        url: https://msdn.microsoft.com/library/azure/dn832687.aspx
      parameters:
      - '$ref': '#/parameters/ResourceGroupName'
      - '$ref': '#/parameters/SearchServiceName'
      - name: parameters
        in: body
        required: true
        schema:
          '$ref': '#/definitions/SearchServiceCreateOrUpdateParameters'
        description: '#parameter-parameters'
      - '$ref': '#/parameters/ApiVersion'
      - '$ref': '#/parameters/SubscriptionId'
      responses:
        '200':
          description: OK
          schema:
            '$ref': '#/definitions/SearchServiceResource'
        '201':
          description: Created
          schema:
            '$ref': '#/definitions/SearchServiceResource'
        default:
          '$ref': '#/responses/error'
```

#### Parameter: parameters (`@.parameters[?(@.name == "parameters")]`)
The properties to set or update on the Search service.

### Delete (`#Services_Delete`)

Deletes a Search service in the given resource group, along with its associated resources.

```yaml
paths:
  '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{serviceName}':
    delete:
      tags:
      - Services
      operationId: Services_Delete
      externalDocs:
        url: https://msdn.microsoft.com/library/azure/dn832692.aspx
      parameters:
      - '$ref': '#/parameters/ResourceGroupName'
      - '$ref': '#/parameters/SearchServiceName'
      - '$ref': '#/parameters/ApiVersion'
      - '$ref': '#/parameters/SubscriptionId'
      responses:
        '200':
          description: OK
        '204':
          description: No Content
        '404':
          description: Not Found
        default:
          '$ref': '#/responses/error'
```

### List (`#Services_List`)

Returns a list of all Search services in the given resource group.

```yaml
paths:
  '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices':
    get:
      tags:
      - Services
      operationId: Services_List
      externalDocs:
        url: https://msdn.microsoft.com/library/azure/dn832688.aspx
      parameters:
      - '$ref': '#/parameters/ResourceGroupName'
      - '$ref': '#/parameters/ApiVersion'
      - '$ref': '#/parameters/SubscriptionId'
      responses:
        '200':
          description: OK
          schema:
            '$ref': '#/definitions/SearchServiceListResult'
        default:
          '$ref': '#/responses/error'
```

### Model Definition: SearchServiceProperties (`$.definitions.SearchServiceProperties`)

Defines properties of an Azure Search service that can be modified.

```yaml
definitions:
  SearchServiceProperties:
    properties:
      replicaCount:
        type: integer
        format: int32
        minimum: 1
        maximum: 6
      partitionCount:
        type: integer
        format: int32
```

#### Property: replicaCount (`@.properties.replicaCount`)
The number of replicas in the Search service.

#### Property: partitionCount (`@.properties.partitionCount`)
The number of partitions in the Search service; if specified, it can be 1, 2, 3, 4, 6, or 12.

### Model Definition: SearchServiceCreateOrUpdateParameters (`$.definitions.SearchServiceCreateOrUpdateParameters`)

Properties that describe an Azure Search service.

```yaml
definitions:
  SearchServiceCreateOrUpdateParameters:
    properties:
      location:
        type: string
      tags:
        type: object
        additionalProperties:
          type: string
      properties:
        '$ref': '#/definitions/SearchServiceProperties'
```

#### Property: location (`@.properties.location`)
The geographic location of the Search service.

#### Property: tags (`@.properties.tags`)
Tags to help categorize the Search service in the Azure Portal.

#### Property: properties (`@.properties.properties`)
Properties of the Search service.

### Model Definition: SearchServiceResource (`$.definitions.SearchServiceResource`)

Describes an Azure Search service and its current state.

```yaml
definitions:
  SearchServiceResource:
    properties:
      id:
        readOnly: true
        type: string
      name:
        externalDocs:
          url: https://msdn.microsoft.com/library/azure/dn857353.aspx
        type: string
      location:
        type: string
      tags:
        type: object
        additionalProperties:
          type: string
```

#### Property: id (`@.properties.id`)
The resource Id of the Azure Search service.

#### Property: name (`@.properties.name`)
The name of the Search service.

#### Property: location (`@.properties.location`)
The geographic location of the Search service.

#### Property: tags (`@.properties.tags`)
Tags to help categorize the Search service in the Azure Portal.

### Model Definition: SearchServiceListResult (`$.definitions.SearchServiceListResult`)

Response containing a list of Azure Search services for a given resource group.

```yaml
definitions:
  SearchServiceListResult:
    properties:
      value:
        readOnly: true
        type: array
        items:
          '$ref': '#/definitions/SearchServiceResource'
```

#### Property: value (`@.properties.value`)
The Search services in the resource group.

## Common Parameters (`$.parameters`, -)

> The "-" makes sure we inject nothing here, we just wanna enter the scope.

### Client: SubscriptionId (`@.SubscriptionId`)
Gets subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.

```yaml
parameters:
  SubscriptionId:
    name: subscriptionId
    in: path
    required: true
    type: string
```

### Client: ApiVersion (`@.ApiVersion`)
The client API version.

```yaml
parameters:
  ApiVersion:
    name: api-version
    in: query
    required: true
    type: string
```

### ResourceGroupName (`@.ResourceGroupName`)
The name of the resource group within the current subscription.

```yaml
parameters:
  ResourceGroupName:
    name: resourceGroupName
    in: path
    required: true
    type: string
    x-ms-parameter-location: method
```

### SearchServiceName (`@.SearchServiceName`)
The name of the Search service to operate on.

``` yaml
parameters:
  SearchServiceName:
    name: serviceName
    in: path
    required: true
    type: string
    x-ms-parameter-location: method
```

## Error Response

The default response will be deserialized as per the Error defintion and will be part of the exception.

```  yaml
definitions:
  Error:
    type: object
    properties:
      code:
        type: integer
      message:
        type: string
      details:
        schema:
          "$ref": "https://github.com/Azure/azure-rest-api-specs/blob/813c8e8b8b12f3d541daeb45bb2298d223845d37/arm-network/2016-09-01/swagger/network.json#/definitions/ErrorDetails"
responses:
  error:
    description: OK
    schema:
      '$ref': '#/definitions/Error'
```