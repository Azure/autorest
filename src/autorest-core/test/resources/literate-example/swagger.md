# Search Management

## General
This client that can be used to manage Azure Search services and API keys.

ASd

- ASd
- qawe

```yaml
swagger: '2.0'
info:
  title: Search Management
  description: ['Search Management', 'General']
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

### List

```yaml
paths:
  '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{serviceName}/listQueryKeys':
    get:
      tags:
      - QueryKeys
      operationId: QueryKeys_List
      description: ['Description']
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

#### Description
Returns the list of query API keys for the given Azure Search service.

### Model Definition: ListQueryKeysResult

```yaml
definitions:
  ListQueryKeysResult:
    properties:
      value:
        readOnly: true
        type: array
        items:
          '$ref': '#/definitions/QueryKey'
        description: ['Property: value']
    description: ['Description']
```

#### Description
Response containing the query API keys for a given Azure Search service.

#### Property: value
The query keys for the Azure Search service.

### Model Definition: QueryKey

```yaml
definitions:
  QueryKey:
    properties:
      name:
        readOnly: true
        type: string
        description: ['Property: name']
      key:
        readOnly: true
        type: string
        description: ['Property: key']
    description: ['Description']
```

#### Description
Describes an API key for a given Azure Search service that has permissions for query operations only.

#### Property: name
The name of the query API key; may be empty.

#### Property: key
The value of the query API key.

## Operations on Services

### CreateOrUpdate

```yaml
paths:
  '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{serviceName}':
    put:
      tags:
      - Services
      operationId: Services_CreateOrUpdate
      description: ['Description']
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

#### Description
Creates or updates a Search service in the given resource group.
If the Search service already exists, all properties will be updated with the given values.

#### Parameter: parameters
The properties to set or update on the Search service.

### Delete

```yaml
paths:
  '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{serviceName}':
    delete:
      tags:
      - Services
      operationId: Services_Delete
      description: ['Description']
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

#### Description
Deletes a Search service in the given resource group, along with its associated resources.

### List

```yaml
paths:
  '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices':
    get:
      tags:
      - Services
      operationId: Services_List
      description: ['Description']
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

#### Description
Returns a list of all Search services in the given resource group.

### Model Definition: SearchServiceProperties

```yaml
definitions:
  SearchServiceProperties:
    properties:
      replicaCount:
        type: integer
        format: int32
        minimum: 1
        maximum: 6
        description: ['Property: replicaCount']
      partitionCount:
        type: integer
        format: int32
        description: ['Property: partitionCount']
    description: ['Description']
```

#### Description
Defines properties of an Azure Search service that can be modified.

#### Property: replicaCount
The number of replicas in the Search service.

#### Property: partitionCount
The number of partitions in the Search service; if specified, it can be 1, 2, 3, 4, 6, or 12.

### Model Definition: SearchServiceCreateOrUpdateParameters

```yaml
definitions:
  SearchServiceCreateOrUpdateParameters:
    properties:
      location:
        type: string
        description: ['Model Definition: SearchServiceCreateOrUpdateParameters', 'Property: location']
      tags:
        type: object
        additionalProperties:
          type: string
        description: ['Property: tags']
      properties:
        '$ref': '#/definitions/SearchServiceProperties'
        description: ['Property: properties']
    description: ['Description']
```

#### Description
Properties that describe an Azure Search service.

#### Property: location
The geographic location of the Search service.

#### Property: tags
Tags to help categorize the Search service in the Azure Portal.

#### Property: properties
Properties of the Search service.

### Model Definition: SearchServiceResource

```yaml
definitions:
  SearchServiceResource:
    properties:
      id:
        readOnly: true
        type: string
        description: ['Property: id']
      name:
        externalDocs:
          url: https://msdn.microsoft.com/library/azure/dn857353.aspx
        type: string
        description: ['Property: name']
      location:
        type: string
        description: ['Property: location']
      tags:
        type: object
        additionalProperties:
          type: string
        description: ['Property: tags']
    description: ['Description']
```

#### Description
Describes an Azure Search service and its current state.

#### Property: id
The resource Id of the Azure Search service.

#### Property: name
The name of the Search service.

#### Property: location
The geographic location of the Search service.

#### Property: tags
Tags to help categorize the Search service in the Azure Portal.

### Model Definition: SearchServiceListResult

```yaml
definitions:
  SearchServiceListResult:
    properties:
      value:
        readOnly: true
        type: array
        items:
          '$ref': '#/definitions/SearchServiceResource'
        description: ['Property: value']
    description: ['Description']
```

#### Description
Response containing a list of Azure Search services for a given resource group.

#### Property: value
The Search services in the resource group.

## Common Definitions

### Client Parameter: SubscriptionId
Gets subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.

```yaml
parameters:
  SubscriptionId:
    name: subscriptionId
    in: path
    required: true
    type: string
    description: []
```

### Client Parameter: ApiVersion
The client API version.

```yaml
parameters:
  ApiVersion:
    name: api-version
    in: query
    required: true
    type: string
    description: []
```

### Method Parameter: ResourceGroupName
The name of the resource group within the current subscription.

```yaml
parameters:
  ResourceGroupName:
    name: resourceGroupName
    in: path
    required: true
    type: string
    x-ms-parameter-location: method
    description: []
```

### Method Parameter: SearchServiceName
The name of the Search service to operate on.

```yaml
parameters:
  SearchServiceName:
    name: serviceName
    in: path
    required: true
    type: string
    x-ms-parameter-location: method
    description: ['Method Parameter: SearchServiceName']
```

### Error Response

The default response will be deserialized as per the Error defintion and will be part of the exception.

```yaml
definitions:
  Error:
    type: object
    properties:
      code:
        type: integer
      message:
        type: string
responses:
  error:
    description: OK
    schema:
      '$ref': '#/definitions/Error'
```