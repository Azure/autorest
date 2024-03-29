import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * API details.
 */
@parentResource(ApiManagementServiceResource)
model ApiContract is ProxyResource<ApiContractProperties> {
  /**
   * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
   */
  @maxLength(256)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("apiId")
  @segment("apis")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface ApiContracts {
  /**
   * Gets the details of the API specified by its identifier.
   */
  get is ArmResourceRead<ApiContract>;

  /**
   * Gets the entity state (Etag) version of the API specified by its identifier.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<ApiContract, BaseParameters<ApiContract>>,
  ): OkResponse | ErrorResponse;

  /**
   * Creates new or updates existing specified API of the API Management service instance.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    ApiContract,
    {
      ...BaseParameters<ApiContract>;

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
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    ApiContract,
    ApiUpdateContract,
    {
      ...BaseParameters<ApiContract>;

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
  delete is ArmResourceDeleteSync<
    ApiContract,
    {
      ...BaseParameters<ApiContract>;

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
  listByService is ArmResourceListByParent<
    ApiContract,
    {
      ...BaseParameters<ApiContract>;

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

@@doc(ApiContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@doc(ApiContracts.update::parameters.properties,
  "API Update Contract parameters."
);
