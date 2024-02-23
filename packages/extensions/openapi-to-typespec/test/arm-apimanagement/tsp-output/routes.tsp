// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.ApiManagement;

interface TagOperations {
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
