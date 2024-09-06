// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.ApiManagement;

interface ApiOperations {
  /**
   * Gets the entity state (Etag) version of the API specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface ApiReleaseOperations {
  /**
   * Returns the etag of an API release.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface ApiOperationOperations {
  /**
   * Gets the entity state (Etag) version of the API operation specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface ApiOperationPolicyOperations {
  /**
   * Gets the entity state (Etag) version of the API operation policy specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface TagOperations {
  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Lists all Tags associated with the API.
   */
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
  ): ArmResponse<ResourceListResult<TagContract>> | ErrorResponse;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Get tag associated with the API.
   */
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
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Lists all Tags associated with the Product.
   */
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
  ): ArmResponse<ResourceListResult<TagContract>> | ErrorResponse;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Get tag associated with the Product.
   */
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
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Lists a collection of tags defined within a service instance.
   */
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
  ): ArmResponse<ResourceListResult<TagContract>> | ErrorResponse;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Gets the details of the tag specified by its identifier.
   */
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
    @body
    parameters: TagCreateUpdateParameters,
  ): ArmResponse<TagContract> | ErrorResponse;

  /**
   * Updates the details of the tag specified by its identifier.
   */
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
    @body
    parameters: TagCreateUpdateParameters,
  ): ArmResponse<TagContract> | ErrorResponse;

  /**
   * Deletes specific tag of the API Management service instance.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface ApiPolicyOperations {
  /**
   * Get the policy configuration at the API level.
   */
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
  ): ArmResponse<ResourceListResult<PolicyContract>> | ErrorResponse;

  /**
   * Gets the entity state (Etag) version of the API policy specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Get the policy configuration at the API level.
   */
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
    @body
    parameters: PolicyContract,
  ): ArmResponse<PolicyContract> | ErrorResponse;

  /**
   * Deletes the policy configuration at the Api.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface ApiSchemaOperations {
  /**
   * Gets the entity state (Etag) version of the schema specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface ApiDiagnosticOperations {
  /**
   * Gets the entity state (Etag) version of the Diagnostic for an API specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface ApiIssueOperations {
  /**
   * Gets the entity state (Etag) version of the Issue for an API specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface ApiIssueCommentOperations {
  /**
   * Gets the entity state (Etag) version of the issue Comment for an API specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface ApiIssueAttachmentOperations {
  /**
   * Gets the entity state (Etag) version of the issue Attachment for an API specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface ApiTagDescriptionOperations {
  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface ApiExportOperations {
  /**
   * Gets the details of the API specified by its identifier in the format specified to the Storage Blob with SAS Key valid for 5 minutes.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface AuthorizationServerOperations {
  /**
   * Gets the entity state (Etag) version of the authorizationServer specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface BackendOperations {
  /**
   * Gets the entity state (Etag) version of the backend specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface CacheOperations {
  /**
   * Gets the entity state (Etag) version of the Cache specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface CertificateOperations {
  /**
   * Gets the entity state (Etag) version of the certificate specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface ContentItemOperations {
  /**
   * Returns the entity state (ETag) version of the developer portal's content item specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface DeletedServicesOperations {
  /**
   * Lists all soft-deleted services available for undelete for the given subscription.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.ApiManagement/deletedservices")
  @get
  listBySubscription(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
  ): ArmResponse<DeletedServicesListResult> | ErrorResponse;
}

interface ApiManagementServiceOperations {
  /**
   * Checks availability and correctness of a name for an API Management service.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.ApiManagement/checkNameAvailability")
  @post
  checkNameAvailability(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,

    /**
     * Parameters supplied to the CheckNameAvailability operation.
     */
    @body
    parameters: ApiManagementServiceCheckNameAvailabilityParameters,
  ): ArmResponse<ApiManagementServiceNameAvailabilityResult> | ErrorResponse;

  /**
   * Get the custom domain ownership identifier for an API Management service.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.ApiManagement/getDomainOwnershipIdentifier")
  @post
  getDomainOwnershipIdentifier(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
  ): ArmResponse<ApiManagementServiceGetDomainOwnershipIdentifierResult> | ErrorResponse;
}

interface DiagnosticOperations {
  /**
   * Lists all diagnostics of the API Management service instance.
   */
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
  ): ArmResponse<ResourceListResult<DiagnosticContract>> | ErrorResponse;

  /**
   * Gets the entity state (Etag) version of the Diagnostic specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Gets the details of the Diagnostic specified by its identifier.
   */
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
    @body
    parameters: DiagnosticContract,
  ): ArmResponse<DiagnosticContract> | ErrorResponse;

  /**
   * Updates the details of the Diagnostic specified by its identifier.
   */
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
    @body
    parameters: DiagnosticContract,
  ): ArmResponse<DiagnosticContract> | ErrorResponse;

  /**
   * Deletes the specified Diagnostic.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface EmailTemplateOperations {
  /**
   * Gets the entity state (Etag) version of the email template specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface GatewayOperations {
  /**
   * Gets the entity state (Etag) version of the Gateway specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface GatewayHostnameConfigurationOperations {
  /**
   * Checks that hostname configuration entity specified by identifier exists for specified Gateway entity.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface GatewayCertificateAuthorityOperations {
  /**
   * Checks if Certificate entity is assigned to Gateway entity as Certificate Authority.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface GroupOperations {
  /**
   * Gets the entity state (Etag) version of the group specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface IdentityProviderOperations {
  /**
   * Gets the entity state (Etag) version of the identityProvider specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface IssueOperations {
  /**
   * Lists a collection of issues in the specified service instance.
   */
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
  ): ArmResponse<ResourceListResult<IssueContract>> | ErrorResponse;

  /**
   * Gets API Management issue details
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface NamedValueOperations {
  /**
   * Gets the entity state (Etag) version of the named value specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface OpenIdConnectProviderOperations {
  /**
   * Gets the entity state (Etag) version of the openIdConnectProvider specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface PolicyOperations {
  /**
   * Lists all the Global Policy definitions of the Api Management service.
   */
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
  ): ArmResponse<ResourceListResult<PolicyContract>> | ErrorResponse;

  /**
   * Gets the entity state (Etag) version of the Global policy definition in the Api Management service.
   */
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
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Get the Global policy definition of the Api Management service.
   */
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
    @body
    parameters: PolicyContract,
  ): ArmResponse<PolicyContract> | ErrorResponse;

  /**
   * Deletes the global policy configuration of the Api Management Service.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface PortalRevisionOperations {
  /**
   * Gets the developer portal revision specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface SignInSettingsOperations {
  /**
   * Gets the entity state (Etag) version of the SignInSettings.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface SignUpSettingsOperations {
  /**
   * Gets the entity state (Etag) version of the SignUpSettings.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface DelegationSettingsOperations {
  /**
   * Gets the entity state (Etag) version of the DelegationSettings.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface ProductOperations {
  /**
   * Gets the entity state (Etag) version of the product specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface ProductPolicyOperations {
  /**
   * Get the policy configuration at the Product level.
   */
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
  ): ArmResponse<ResourceListResult<PolicyContract>> | ErrorResponse;

  /**
   * Get the ETag of the policy configuration at the Product level.
   */
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
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Get the policy configuration at the Product level.
   */
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
    @body
    parameters: PolicyContract,
  ): ArmResponse<PolicyContract> | ErrorResponse;

  /**
   * Deletes the policy configuration at the Product.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface GlobalSchemaOperations {
  /**
   * Gets the entity state (Etag) version of the Schema specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface ApiManagementSkusOperations {
  /**
   * Gets the list of Microsoft.ApiManagement SKUs available for your Subscription.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.ApiManagement/skus")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
  ): ArmResponse<ApiManagementSkusResult> | ErrorResponse;
}

interface SubscriptionOperations {
  /**
   * Gets the entity state (Etag) version of the apimanagement subscription specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface TenantAccessOperations {
  /**
   * Tenant access metadata
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface UserOperations {
  /**
   * Gets the entity state (Etag) version of the user specified by its identifier.
   */
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
  ): ArmResponse<void> | ErrorResponse;
}

interface UserSubscriptionOperations {
  /**
   * Lists the collection of subscriptions of the specified user.
   */
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
  ): ArmResponse<ResourceListResult<SubscriptionContract>> | ErrorResponse;

  /**
   * Gets the specified Subscription entity associated with a particular user.
   */
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
