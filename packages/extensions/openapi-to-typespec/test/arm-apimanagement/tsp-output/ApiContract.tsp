import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * API details.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(ApiContractProperties)
model ApiContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = ApiContract,
    KeyName = "apiId",
    SegmentName = "apis",
    NamePattern = "^[^*#&+:<>?]+$"
  >;

  /**
   * API entity contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: ApiContractProperties;
}

@armResourceOperations
interface ApiContracts {
  /**
   * Gets the details of the API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Api_Get")
  get is ArmResourceRead<ApiContract>;

  /**
   * Gets the entity state (Etag) version of the API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("Api_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<ApiContract, BaseParameters<ApiContract>>,
  ): OkResponse | ErrorResponse;

  /**
   * Creates new or updates existing specified API of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Api_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    ApiContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ApiContract>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates the specified API of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("Api_Update")
  update is ArmCustomPatchSync<
    ApiContract,
    ApiUpdateContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ApiContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes the specified API of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Api_Delete")
  delete is ArmResourceDeleteSync<
    ApiContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ApiContract>;

      /**
       * Delete all revisions of the Api.
       */
      @query("deleteRevisions")
      deleteRevisions?: boolean;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists all APIs of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Api_ListByService")
  listByService is ArmResourceListByParent<
    ApiContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ApiContract>;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| serviceUrl | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| path | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| isCurrent | filter | eq, ne |  |</br>
       */
      @query("$filter")
      $filter?: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;

      /**
       * Include tags in the response.
       */
      @query("tags")
      tags?: string;

      /**
       * Include full ApiVersionSet resource in response
       */
      @query("expandApiVersionSet")
      expandApiVersionSet?: boolean;
    }
  >;

  /**
   * Lists all revisions of an API.
   */
  // FIXME: ApiRevision_ListByService could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiRevision_ListByService")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/revisions")
  @get
  listByService(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the API Management service.
     */
    @maxLength(50)
    @minLength(1)
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    @path
    serviceName: string,

    /**
     * API identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @path
    apiId: string,

    /**
     * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| apiRevision | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
     */
    @query("$filter")
    $filter?: string,

    /**
     * Number of records to return.
     */
    @minValue(1)
    @query("$top")
    $top?: int32,

    /**
     * Number of records to skip.
     */
    @query("$skip")
    $skip?: int32,

    ...SubscriptionIdParameter,
  ): ArmResponse<ApiRevisionListResult> | ErrorResponse;

  /**
   * Lists all Products, which the API is part of.
   */
  // FIXME: ApiProduct_ListByApis could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiProduct_ListByApis")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/products")
  @get
  listByApis(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the API Management service.
     */
    @maxLength(50)
    @minLength(1)
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    @path
    serviceName: string,

    /**
     * API identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @path
    apiId: string,

    /**
     * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
     */
    @query("$filter")
    $filter?: string,

    /**
     * Number of records to return.
     */
    @minValue(1)
    @query("$top")
    $top?: int32,

    /**
     * Number of records to skip.
     */
    @query("$skip")
    $skip?: int32,

    ...SubscriptionIdParameter,
  ): ArmResponse<ResourceListResult<ProductContract>> | ErrorResponse;

  /**
   * Lists a collection of operations associated with tags.
   */
  // FIXME: Operation_ListByTags could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Operation_ListByTags")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operationsByTags")
  @get
  listByTags(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the API Management service.
     */
    @maxLength(50)
    @minLength(1)
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    @path
    serviceName: string,

    /**
     * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
     */
    @maxLength(256)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    apiId: string,

    /**
     * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| apiName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| method | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| urlTemplate | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
     */
    @query("$filter")
    $filter?: string,

    /**
     * Number of records to return.
     */
    @minValue(1)
    @query("$top")
    $top?: int32,

    /**
     * Number of records to skip.
     */
    @query("$skip")
    $skip?: int32,

    /**
     * Include not tagged Operations.
     */
    @query("includeNotTaggedOperations")
    includeNotTaggedOperations?: boolean,

    ...SubscriptionIdParameter,
  ): ArmResponse<TagResourceListResult> | ErrorResponse;
}

@@maxLength(ApiContract.name, 256);
@@minLength(ApiContract.name, 1);
@@doc(ApiContract.name,
  "API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number."
);
@@encodedName(ApiContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(ApiContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(ApiContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@encodedName(ApiContracts.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(ApiContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(ApiContracts.update::parameters.properties,
  "API Update Contract parameters."
);
