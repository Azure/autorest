// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;

interface ApiOperations {
  /**
   * Gets the entity state (Etag) version of the API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Api_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}")
  @head
  getEntityTag(
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

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface ApiReleaseOperations {
  /**
   * Returns the etag of an API release.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiRelease_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}")
  @head
  getEntityTag(
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
     * Release identifier within an API. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    releaseId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface ApiOperationOperations {
  /**
   * Gets the entity state (Etag) version of the API operation specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiOperation_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}")
  @head
  getEntityTag(
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
     * Operation identifier within an API. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @path
    operationId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface ApiOperationPolicyOperations {
  /**
   * Gets the entity state (Etag) version of the API operation policy specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiOperationPolicy_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}")
  @head
  getEntityTag(
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
     * Operation identifier within an API. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @path
    operationId: string,

    /**
     * The identifier of the Policy.
     */
    @path
    policyId: PolicyIdName,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface TagOperations {
  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_GetEntityStateByOperation")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/tags/{tagId}")
  @head
  getEntityStateByOperation(
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
     * Operation identifier within an API. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @path
    operationId: string,

    /**
     * Tag identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    tagId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;

  /**
   * Lists all Tags associated with the API.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_ListByApi")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags")
  @get
  listByApi(
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
     * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
  ): ArmResponse<TagListResult> | ErrorResponse;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_GetEntityStateByApi")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}")
  @head
  getEntityStateByApi(
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
     * Tag identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    tagId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;

  /**
   * Get tag associated with the API.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_GetByApi")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}")
  @get
  getByApi(
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
     * Tag identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    tagId: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<TagContract> | ErrorResponse;

  /**
   * Assign tag to the Api.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_AssignToApi")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}")
  @put
  assignToApi(
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
     * Tag identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    tagId: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<TagContract> | ErrorResponse;

  /**
   * Detach the tag from the Api.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_DetachFromApi")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}")
  @delete
  detachFromApi(
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
     * Tag identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    tagId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;

  /**
   * Lists all Tags associated with the Product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_ListByProduct")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags")
  @get
  listByProduct(
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
     * Product identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    productId: string,

    /**
     * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
  ): ArmResponse<TagListResult> | ErrorResponse;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_GetEntityStateByProduct")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}")
  @head
  getEntityStateByProduct(
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
     * Product identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    productId: string,

    /**
     * Tag identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    tagId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;

  /**
   * Get tag associated with the Product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_GetByProduct")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}")
  @get
  getByProduct(
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
     * Product identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    productId: string,

    /**
     * Tag identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    tagId: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<TagContract> | ErrorResponse;

  /**
   * Assign tag to the Product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_AssignToProduct")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}")
  @put
  assignToProduct(
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
     * Product identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    productId: string,

    /**
     * Tag identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    tagId: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<TagContract> | ErrorResponse;

  /**
   * Detach the tag from the Product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_DetachFromProduct")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}")
  @delete
  detachFromProduct(
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
     * Product identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    productId: string,

    /**
     * Tag identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    tagId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;

  /**
   * Lists a collection of tags defined within a service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_ListByService")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags")
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
     * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
     * Scope like 'apis', 'products' or 'apis/{apiId}
     */
    @query("scope")
    scope?: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<TagListResult> | ErrorResponse;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_GetEntityState")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}")
  @head
  getEntityState(
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
     * Tag identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    tagId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;

  /**
   * Gets the details of the tag specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_Get")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}")
  @get
  get(
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
     * Tag identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    tagId: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<TagContract> | ErrorResponse;

  /**
   * Creates a tag.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_CreateOrUpdate")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}")
  @put
  createOrUpdate(
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
     * Tag identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    tagId: string,

    /**
     * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
     */
    @header
    `If-Match`?: string,

    ...SubscriptionIdParameter,

    /**
     * Create parameters.
     */
    @bodyRoot
    parameters: TagCreateUpdateParameters,
  ): ArmResponse<TagContract> | ErrorResponse;

  /**
   * Updates the details of the tag specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_Update")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}")
  @patch
  update(
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
     * Tag identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    tagId: string,

    /**
     * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
     */
    @header
    `If-Match`: string,

    ...SubscriptionIdParameter,

    /**
     * Update parameters.
     */
    @bodyRoot
    parameters: TagCreateUpdateParameters,
  ): ArmResponse<TagContract> | ErrorResponse;

  /**
   * Deletes specific tag of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_Delete")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}")
  @delete
  delete(
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
     * Tag identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    tagId: string,

    /**
     * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
     */
    @header
    `If-Match`: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface ApiPolicyOperations {
  /**
   * Get the policy configuration at the API level.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiPolicy_ListByApi")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies")
  @get
  listByApi(
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

    ...SubscriptionIdParameter,
  ): ArmResponse<PolicyListResult> | ErrorResponse;

  /**
   * Gets the entity state (Etag) version of the API policy specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiPolicy_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}")
  @head
  getEntityTag(
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
     * The identifier of the Policy.
     */
    @path
    policyId: PolicyIdName,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;

  /**
   * Get the policy configuration at the API level.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiPolicy_Get")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}")
  @get
  get(
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
     * The identifier of the Policy.
     */
    @path
    policyId: PolicyIdName,

    /**
     * Policy Export Format.
     */
    @query("format")
    format?: PolicyExportFormat = PolicyExportFormat.xml,

    ...SubscriptionIdParameter,

    /**
     * Accept header
     */
    @header
    accept: "application/json, application/vnd.ms-azure-apim.policy+xml, application/vnd.ms-azure-apim.policy.raw+xml",
  ): ArmResponse<PolicyContract> | ErrorResponse;

  /**
   * Creates or updates policy configuration for the API.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiPolicy_CreateOrUpdate")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}")
  @put
  createOrUpdate(
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
     * The identifier of the Policy.
     */
    @path
    policyId: PolicyIdName,

    /**
     * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
     */
    @header
    `If-Match`?: string,

    ...SubscriptionIdParameter,

    /**
     * The policy contents to apply.
     */
    @bodyRoot
    parameters: PolicyContract,
  ): ArmResponse<PolicyContract> | ErrorResponse;

  /**
   * Deletes the policy configuration at the Api.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiPolicy_Delete")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}")
  @delete
  delete(
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
     * The identifier of the Policy.
     */
    @path
    policyId: PolicyIdName,

    /**
     * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
     */
    @header
    `If-Match`: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface ApiSchemaOperations {
  /**
   * Gets the entity state (Etag) version of the schema specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiSchema_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}")
  @head
  getEntityTag(
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
     * Schema id identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @path
    schemaId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface ApiDiagnosticOperations {
  /**
   * Gets the entity state (Etag) version of the Diagnostic for an API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiDiagnostic_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}")
  @head
  getEntityTag(
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
     * Diagnostic identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    diagnosticId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface ApiIssueOperations {
  /**
   * Gets the entity state (Etag) version of the Issue for an API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiIssue_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}")
  @head
  getEntityTag(
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
     * Issue identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    issueId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface ApiIssueCommentOperations {
  /**
   * Gets the entity state (Etag) version of the issue Comment for an API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiIssueComment_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}")
  @head
  getEntityTag(
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
     * Issue identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    issueId: string,

    /**
     * Comment identifier within an Issue. Must be unique in the current Issue.
     */
    @maxLength(256)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    commentId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface ApiIssueAttachmentOperations {
  /**
   * Gets the entity state (Etag) version of the issue Attachment for an API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiIssueAttachment_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}")
  @head
  getEntityTag(
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
     * Issue identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    issueId: string,

    /**
     * Attachment identifier within an Issue. Must be unique in the current Issue.
     */
    @maxLength(256)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    attachmentId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface ApiTagDescriptionOperations {
  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiTagDescription_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tagDescriptions/{tagDescriptionId}")
  @head
  getEntityTag(
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
     * Tag description identifier. Used when creating tagDescription for API/Tag association. Based on API and Tag names.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    tagDescriptionId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface ApiExportOperations {
  /**
   * Gets the details of the API specified by its identifier in the format specified to the Storage Blob with SAS Key valid for 5 minutes.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiExport_Get")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}")
  @get
  get(
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
     * Format in which to export the Api Details to the Storage Blob with Sas Key valid for 5 minutes.
     */
    @query("format")
    format: ExportFormat,

    /**
     * Query parameter required to export the API details.
     */
    @query("export")
    export: ExportApi,

    ...SubscriptionIdParameter,
  ): ArmResponse<ApiExportResult> | ErrorResponse;
}

interface ApiVersionSetOperations {
  /**
   * Gets the entity state (Etag) version of the Api Version Set specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiVersionSet_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apiVersionSets/{versionSetId}")
  @head
  getEntityTag(
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
     * Api Version Set identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    versionSetId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface AuthorizationServerOperations {
  /**
   * Gets the entity state (Etag) version of the authorizationServer specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("AuthorizationServer_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/authorizationServers/{authsid}")
  @head
  getEntityTag(
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
     * Identifier of the authorization server.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    authsid: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface BackendOperations {
  /**
   * Gets the entity state (Etag) version of the backend specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Backend_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/backends/{backendId}")
  @head
  getEntityTag(
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
     * Identifier of the Backend entity. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @path
    backendId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface CacheOperations {
  /**
   * Gets the entity state (Etag) version of the Cache specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Cache_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/caches/{cacheId}")
  @head
  getEntityTag(
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
     * Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier).
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    cacheId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface CertificateOperations {
  /**
   * Gets the entity state (Etag) version of the certificate specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Certificate_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/certificates/{certificateId}")
  @head
  getEntityTag(
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
     * Identifier of the certificate entity. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    certificateId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface ContentItemOperations {
  /**
   * Returns the entity state (ETag) version of the developer portal's content item specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ContentItem_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/contentTypes/{contentTypeId}/contentItems/{contentItemId}")
  @head
  getEntityTag(
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
     * Content type identifier.
     */
    @maxLength(80)
    @minLength(1)
    @path
    contentTypeId: string,

    /**
     * Content item identifier.
     */
    @maxLength(80)
    @minLength(1)
    @path
    contentItemId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

@armResourceOperations
interface DeletedServicesOperations {
  /**
   * Lists all soft-deleted services available for undelete for the given subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DeletedServices_ListBySubscription")
  @get
  @action("deletedservices")
  listBySubscription is ArmProviderActionAsync<
    Response = DeletedServicesListResult,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;
}

@armResourceOperations
interface ApiManagementServiceOperations {
  /**
   * Checks availability and correctness of a name for an API Management service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiManagementService_CheckNameAvailability")
  @post
  checkNameAvailability is ArmProviderActionAsync<
    Response = ApiManagementServiceNameAvailabilityResult,
    Scope = SubscriptionActionScope,
    Parameters = {},
    Request = ApiManagementServiceCheckNameAvailabilityParameters
  >;
  /**
   * Get the custom domain ownership identifier for an API Management service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiManagementService_GetDomainOwnershipIdentifier")
  @post
  getDomainOwnershipIdentifier is ArmProviderActionAsync<
    Response = ApiManagementServiceGetDomainOwnershipIdentifierResult,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;
}

interface DiagnosticOperations {
  /**
   * Lists all diagnostics of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Diagnostic_ListByService")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics")
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
     * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
  ): ArmResponse<DiagnosticListResult> | ErrorResponse;

  /**
   * Gets the entity state (Etag) version of the Diagnostic specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Diagnostic_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}")
  @head
  getEntityTag(
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
     * Diagnostic identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    diagnosticId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;

  /**
   * Gets the details of the Diagnostic specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Diagnostic_Get")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}")
  @get
  get(
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
     * Diagnostic identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    diagnosticId: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<DiagnosticContract> | ErrorResponse;

  /**
   * Creates a new Diagnostic or updates an existing one.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Diagnostic_CreateOrUpdate")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}")
  @put
  createOrUpdate(
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
     * Diagnostic identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    diagnosticId: string,

    /**
     * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
     */
    @header
    `If-Match`?: string,

    ...SubscriptionIdParameter,

    /**
     * Create parameters.
     */
    @bodyRoot
    parameters: DiagnosticContract,
  ): ArmResponse<DiagnosticContract> | ErrorResponse;

  /**
   * Updates the details of the Diagnostic specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Diagnostic_Update")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}")
  @patch
  update(
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
     * Diagnostic identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    diagnosticId: string,

    /**
     * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
     */
    @header
    `If-Match`: string,

    ...SubscriptionIdParameter,

    /**
     * Diagnostic Update parameters.
     */
    @bodyRoot
    parameters: DiagnosticContract,
  ): ArmResponse<DiagnosticContract> | ErrorResponse;

  /**
   * Deletes the specified Diagnostic.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Diagnostic_Delete")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}")
  @delete
  delete(
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
     * Diagnostic identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    diagnosticId: string,

    /**
     * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
     */
    @header
    `If-Match`: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface EmailTemplateOperations {
  /**
   * Gets the entity state (Etag) version of the email template specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("EmailTemplate_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/templates/{templateName}")
  @head
  getEntityTag(
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
     * Email Template Name Identifier.
     */
    @path
    templateName: TemplateName,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface GatewayOperations {
  /**
   * Gets the entity state (Etag) version of the Gateway specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Gateway_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/gateways/{gatewayId}")
  @head
  getEntityTag(
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
     * Gateway entity identifier. Must be unique in the current API Management service instance. Must not have value 'managed'
     */
    @maxLength(80)
    @minLength(1)
    @path
    gatewayId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface GatewayHostnameConfigurationOperations {
  /**
   * Checks that hostname configuration entity specified by identifier exists for specified Gateway entity.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GatewayHostnameConfiguration_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/gateways/{gatewayId}/hostnameConfigurations/{hcId}")
  @head
  getEntityTag(
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
     * Gateway entity identifier. Must be unique in the current API Management service instance. Must not have value 'managed'
     */
    @maxLength(80)
    @minLength(1)
    @path
    gatewayId: string,

    /**
     * Gateway hostname configuration identifier. Must be unique in the scope of parent Gateway entity.
     */
    @maxLength(80)
    @minLength(1)
    @path
    hcId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface GatewayCertificateAuthorityOperations {
  /**
   * Checks if Certificate entity is assigned to Gateway entity as Certificate Authority.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GatewayCertificateAuthority_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/gateways/{gatewayId}/certificateAuthorities/{certificateId}")
  @head
  getEntityTag(
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
     * Gateway entity identifier. Must be unique in the current API Management service instance. Must not have value 'managed'
     */
    @maxLength(80)
    @minLength(1)
    @path
    gatewayId: string,

    /**
     * Identifier of the certificate entity. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    certificateId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface GroupOperations {
  /**
   * Gets the entity state (Etag) version of the group specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Group_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}")
  @head
  getEntityTag(
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
     * Group identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    groupId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface IdentityProviderOperations {
  /**
   * Gets the entity state (Etag) version of the identityProvider specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("IdentityProvider_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/identityProviders/{identityProviderName}")
  @head
  getEntityTag(
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
     * Identity Provider Type identifier.
     */
    @path
    identityProviderName: IdentityProviderType,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface IssueOperations {
  /**
   * Lists a collection of issues in the specified service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Issue_ListByService")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/issues")
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
     * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| apiId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| title | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| authorName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq |     |</br>
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
  ): ArmResponse<IssueListResult> | ErrorResponse;

  /**
   * Gets API Management issue details
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Issue_Get")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/issues/{issueId}")
  @get
  get(
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
     * Issue identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    issueId: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<IssueContract> | ErrorResponse;
}

interface LoggerOperations {
  /**
   * Gets the entity state (Etag) version of the logger specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Logger_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/loggers/{loggerId}")
  @head
  getEntityTag(
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
     * Logger identifier. Must be unique in the API Management service instance.
     */
    @maxLength(256)
    @pattern("^[^*#&+:<>?]+$")
    @path
    loggerId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface NamedValueOperations {
  /**
   * Gets the entity state (Etag) version of the named value specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("NamedValue_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/namedValues/{namedValueId}")
  @head
  getEntityTag(
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
     * Identifier of the NamedValue.
     */
    @maxLength(256)
    @pattern("^[^*#&+:<>?]+$")
    @path
    namedValueId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface OpenIdConnectProviderOperations {
  /**
   * Gets the entity state (Etag) version of the openIdConnectProvider specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OpenIdConnectProvider_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/openidConnectProviders/{opid}")
  @head
  getEntityTag(
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
     * Identifier of the OpenID Connect Provider.
     */
    @maxLength(256)
    @pattern("^[^*#&+:<>?]+$")
    @path
    OpenId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface PolicyOperations {
  /**
   * Lists all the Global Policy definitions of the Api Management service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Policy_ListByService")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies")
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

    ...SubscriptionIdParameter,
  ): ArmResponse<PolicyListResult> | ErrorResponse;

  /**
   * Gets the entity state (Etag) version of the Global policy definition in the Api Management service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Policy_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}")
  @head
  getEntityTag(
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
     * The identifier of the Policy.
     */
    @path
    policyId: PolicyIdName,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;

  /**
   * Get the Global policy definition of the Api Management service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Policy_Get")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}")
  @get
  get(
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
     * The identifier of the Policy.
     */
    @path
    policyId: PolicyIdName,

    /**
     * Policy Export Format.
     */
    @query("format")
    format?: PolicyExportFormat = PolicyExportFormat.xml,

    ...SubscriptionIdParameter,
  ): ArmResponse<PolicyContract> | ErrorResponse;

  /**
   * Creates or updates the global policy configuration of the Api Management service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Policy_CreateOrUpdate")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}")
  @put
  createOrUpdate(
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
     * The identifier of the Policy.
     */
    @path
    policyId: PolicyIdName,

    /**
     * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
     */
    @header
    `If-Match`?: string,

    ...SubscriptionIdParameter,

    /**
     * The policy contents to apply.
     */
    @bodyRoot
    parameters: PolicyContract,
  ): ArmResponse<PolicyContract> | ErrorResponse;

  /**
   * Deletes the global policy configuration of the Api Management Service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Policy_Delete")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}")
  @delete
  delete(
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
     * The identifier of the Policy.
     */
    @path
    policyId: PolicyIdName,

    /**
     * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
     */
    @header
    `If-Match`: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface PortalRevisionOperations {
  /**
   * Gets the developer portal revision specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("PortalRevision_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/portalRevisions/{portalRevisionId}")
  @head
  getEntityTag(
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
     * Portal revision identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    portalRevisionId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface SignInSettingsOperations {
  /**
   * Gets the entity state (Etag) version of the SignInSettings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("SignInSettings_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/portalsettings/signin")
  @head
  getEntityTag(
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

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface SignUpSettingsOperations {
  /**
   * Gets the entity state (Etag) version of the SignUpSettings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("SignUpSettings_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/portalsettings/signup")
  @head
  getEntityTag(
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

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface DelegationSettingsOperations {
  /**
   * Gets the entity state (Etag) version of the DelegationSettings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DelegationSettings_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/portalsettings/delegation")
  @head
  getEntityTag(
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

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface ProductOperations {
  /**
   * Gets the entity state (Etag) version of the product specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Product_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}")
  @head
  getEntityTag(
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
     * Product identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    productId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface ProductPolicyOperations {
  /**
   * Get the policy configuration at the Product level.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ProductPolicy_ListByProduct")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies")
  @get
  listByProduct(
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
     * Product identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    productId: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<PolicyListResult> | ErrorResponse;

  /**
   * Get the ETag of the policy configuration at the Product level.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ProductPolicy_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}")
  @head
  getEntityTag(
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
     * Product identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    productId: string,

    /**
     * The identifier of the Policy.
     */
    @path
    policyId: PolicyIdName,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;

  /**
   * Get the policy configuration at the Product level.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ProductPolicy_Get")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}")
  @get
  get(
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
     * Product identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    productId: string,

    /**
     * The identifier of the Policy.
     */
    @path
    policyId: PolicyIdName,

    /**
     * Policy Export Format.
     */
    @query("format")
    format?: PolicyExportFormat = PolicyExportFormat.xml,

    ...SubscriptionIdParameter,
  ): ArmResponse<PolicyContract> | ErrorResponse;

  /**
   * Creates or updates policy configuration for the Product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ProductPolicy_CreateOrUpdate")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}")
  @put
  createOrUpdate(
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
     * Product identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    productId: string,

    /**
     * The identifier of the Policy.
     */
    @path
    policyId: PolicyIdName,

    /**
     * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
     */
    @header
    `If-Match`?: string,

    ...SubscriptionIdParameter,

    /**
     * The policy contents to apply.
     */
    @bodyRoot
    parameters: PolicyContract,
  ): ArmResponse<PolicyContract> | ErrorResponse;

  /**
   * Deletes the policy configuration at the Product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ProductPolicy_Delete")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}")
  @delete
  delete(
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
     * Product identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    productId: string,

    /**
     * The identifier of the Policy.
     */
    @path
    policyId: PolicyIdName,

    /**
     * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
     */
    @header
    `If-Match`: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface GlobalSchemaOperations {
  /**
   * Gets the entity state (Etag) version of the Schema specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GlobalSchema_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/schemas/{schemaId}")
  @head
  getEntityTag(
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
     * Schema id identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @path
    schemaId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

@armResourceOperations
interface ApiManagementSkusOperations {
  /**
   * Gets the list of Microsoft.ApiManagement SKUs available for your Subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiManagementSkus_List")
  @get
  @action("skus")
  list is ArmProviderActionAsync<
    Response = ApiManagementSkusResult,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;
}

interface SubscriptionOperations {
  /**
   * Gets the entity state (Etag) version of the apimanagement subscription specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Subscription_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions/{sid}")
  @head
  getEntityTag(
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
     * Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
     */
    @maxLength(256)
    @pattern("^[^*#&+:<>?]+$")
    @path
    sid: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface TenantAccessOperations {
  /**
   * Tenant access metadata
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantAccess_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}")
  @head
  getEntityTag(
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

    ...SubscriptionIdParameter,

    /**
     * The identifier of the Access configuration.
     */
    @path
    accessName: AccessIdName,
  ): OkResponse | ErrorResponse;
}

interface UserOperations {
  /**
   * Gets the entity state (Etag) version of the user specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("User_GetEntityTag")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}")
  @head
  getEntityTag(
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
     * User identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @path
    userId: string,

    ...SubscriptionIdParameter,
  ): OkResponse | ErrorResponse;
}

interface UserSubscriptionOperations {
  /**
   * Lists the collection of subscriptions of the specified user.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("UserSubscription_List")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/subscriptions")
  @get
  list(
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
     * User identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @path
    userId: string,

    /**
     * | Field     |     Usage     |     Supported operators    | Supported functions               |</br>|-------------|------------------------|-----------------------------------|</br>|name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|stateComment | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|ownerId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|scope | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|userId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|productId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
  ): ArmResponse<SubscriptionListResult> | ErrorResponse;

  /**
   * Gets the specified Subscription entity associated with a particular user.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("UserSubscription_Get")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/subscriptions/{sid}")
  @get
  get(
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
     * User identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @path
    userId: string,

    /**
     * Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
     */
    @maxLength(256)
    @pattern("^[^*#&+:<>?]+$")
    @path
    sid: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<SubscriptionContract> | ErrorResponse;
}
