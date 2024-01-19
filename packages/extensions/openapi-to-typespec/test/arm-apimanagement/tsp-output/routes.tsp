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
  listByApi is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
       */
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    ResourceListResult<TagContract>
  >;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}")
  @head
  getEntityStateByApi is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
       */
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      /**
       * Tag identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;

  /**
   * Get tag associated with the API.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}")
  @get
  getByApi is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
       */
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      /**
       * Tag identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    TagContract
  >;

  /**
   * Assign tag to the Api.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}")
  @put
  assignToApi is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
       */
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      /**
       * Tag identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    TagContract
  >;

  /**
   * Detach the tag from the Api.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}")
  @delete
  detachFromApi is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
       */
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      /**
       * Tag identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;

  /**
   * Lists all Tags associated with the Product.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags")
  @get
  listByProduct is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Product identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    ResourceListResult<TagContract>
  >;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}")
  @head
  getEntityStateByProduct is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Product identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      /**
       * Tag identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;

  /**
   * Get tag associated with the Product.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}")
  @get
  getByProduct is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Product identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      /**
       * Tag identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    TagContract
  >;

  /**
   * Assign tag to the Product.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}")
  @put
  assignToProduct is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Product identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      /**
       * Tag identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    TagContract
  >;

  /**
   * Detach the tag from the Product.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}")
  @delete
  detachFromProduct is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Product identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      /**
       * Tag identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;

  /**
   * Lists a collection of tags defined within a service instance.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags")
  @get
  listByService is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
       * Scope like 'apis', 'products' or 'apis/{apiId}
       */
      @query("scope")
      scope?: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    ResourceListResult<TagContract>
  >;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}")
  @head
  getEntityState is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Tag identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;

  /**
   * Gets the details of the tag specified by its identifier.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Tag identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    TagContract
  >;

  /**
   * Creates a tag.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Tag identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * Create parameters.
       */
      @body
      parameters: TagCreateUpdateParameters;
    },
    TagContract
  >;

  /**
   * Updates the details of the tag specified by its identifier.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}")
  @patch
  update is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Tag identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * Update parameters.
       */
      @body
      parameters: TagCreateUpdateParameters;
    },
    TagContract
  >;

  /**
   * Deletes specific tag of the API Management service instance.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}")
  @delete
  delete is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Tag identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface ApiPolicyOperations {
  /**
   * Get the policy configuration at the API level.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies")
  @get
  listByApi is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
       */
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    ResourceListResult<PolicyContract>
  >;

  /**
   * Gets the entity state (Etag) version of the API policy specified by its identifier.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}")
  @head
  getEntityTag is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
       */
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      /**
       * The identifier of the Policy.
       */
      @path
      policyId: PolicyIdName;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;

  /**
   * Get the policy configuration at the API level.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
       */
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      /**
       * The identifier of the Policy.
       */
      @path
      policyId: PolicyIdName;

      /**
       * Policy Export Format.
       */
      @query("format")
      format?: PolicyExportFormat = PolicyExportFormat.xml;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * Accept header
       */
      @header
      accept: "application/json, application/vnd.ms-azure-apim.policy+xml, application/vnd.ms-azure-apim.policy.raw+xml";
    },
    PolicyContract
  >;

  /**
   * Creates or updates policy configuration for the API.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
       */
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      /**
       * The identifier of the Policy.
       */
      @path
      policyId: PolicyIdName;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * The policy contents to apply.
       */
      @body
      parameters: PolicyContract;
    },
    PolicyContract
  >;

  /**
   * Deletes the policy configuration at the Api.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}")
  @delete
  delete is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
       */
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      /**
       * The identifier of the Policy.
       */
      @path
      policyId: PolicyIdName;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface ApiExportOperations {
  /**
   * Gets the details of the API specified by its identifier in the format specified to the Storage Blob with SAS Key valid for 5 minutes.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
       */
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      /**
       * Format in which to export the Api Details to the Storage Blob with Sas Key valid for 5 minutes.
       */
      @query("format")
      format: ExportFormat;

      /**
       * Query parameter required to export the API details.
       */
      @query("export")
      export: ExportApi;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    ApiExportResult
  >;
}

interface DiagnosticOperations {
  /**
   * Lists all diagnostics of the API Management service instance.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics")
  @get
  listByService is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    ResourceListResult<DiagnosticContract>
  >;

  /**
   * Gets the entity state (Etag) version of the Diagnostic specified by its identifier.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}")
  @head
  getEntityTag is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Diagnostic identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      diagnosticId: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;

  /**
   * Gets the details of the Diagnostic specified by its identifier.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Diagnostic identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      diagnosticId: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    DiagnosticContract
  >;

  /**
   * Creates a new Diagnostic or updates an existing one.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Diagnostic identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      diagnosticId: string;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * Create parameters.
       */
      @body
      parameters: DiagnosticContract;
    },
    DiagnosticContract
  >;

  /**
   * Updates the details of the Diagnostic specified by its identifier.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}")
  @patch
  update is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Diagnostic identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      diagnosticId: string;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * Diagnostic Update parameters.
       */
      @body
      parameters: DiagnosticContract;
    },
    DiagnosticContract
  >;

  /**
   * Deletes the specified Diagnostic.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}")
  @delete
  delete is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Diagnostic identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      diagnosticId: string;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface IssueOperations {
  /**
   * Lists a collection of issues in the specified service instance.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/issues")
  @get
  listByService is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| apiId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| title | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| authorName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq |     |</br>
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
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    ResourceListResult<IssueContract>
  >;

  /**
   * Gets API Management issue details
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/issues/{issueId}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Issue identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      issueId: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    IssueContract
  >;
}

interface PolicyOperations {
  /**
   * Lists all the Global Policy definitions of the Api Management service.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies")
  @get
  listByService is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    ResourceListResult<PolicyContract>
  >;

  /**
   * Gets the entity state (Etag) version of the Global policy definition in the Api Management service.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}")
  @head
  getEntityTag is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * The identifier of the Policy.
       */
      @path
      policyId: PolicyIdName;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;

  /**
   * Get the Global policy definition of the Api Management service.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * The identifier of the Policy.
       */
      @path
      policyId: PolicyIdName;

      /**
       * Policy Export Format.
       */
      @query("format")
      format?: PolicyExportFormat = PolicyExportFormat.xml;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    PolicyContract
  >;

  /**
   * Creates or updates the global policy configuration of the Api Management service.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * The identifier of the Policy.
       */
      @path
      policyId: PolicyIdName;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * The policy contents to apply.
       */
      @body
      parameters: PolicyContract;
    },
    PolicyContract
  >;

  /**
   * Deletes the global policy configuration of the Api Management Service.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}")
  @delete
  delete is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * The identifier of the Policy.
       */
      @path
      policyId: PolicyIdName;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface ProductPolicyOperations {
  /**
   * Get the policy configuration at the Product level.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies")
  @get
  listByProduct is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Product identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    ResourceListResult<PolicyContract>
  >;

  /**
   * Get the ETag of the policy configuration at the Product level.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}")
  @head
  getEntityTag is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Product identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      /**
       * The identifier of the Policy.
       */
      @path
      policyId: PolicyIdName;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;

  /**
   * Get the policy configuration at the Product level.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Product identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      /**
       * The identifier of the Policy.
       */
      @path
      policyId: PolicyIdName;

      /**
       * Policy Export Format.
       */
      @query("format")
      format?: PolicyExportFormat = PolicyExportFormat.xml;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    PolicyContract
  >;

  /**
   * Creates or updates policy configuration for the Product.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Product identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      /**
       * The identifier of the Policy.
       */
      @path
      policyId: PolicyIdName;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * The policy contents to apply.
       */
      @body
      parameters: PolicyContract;
    },
    PolicyContract
  >;

  /**
   * Deletes the policy configuration at the Product.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}")
  @delete
  delete is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Product identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      /**
       * The identifier of the Policy.
       */
      @path
      policyId: PolicyIdName;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface ApiManagementSkusOperations {
  /**
   * Gets the list of Microsoft.ApiManagement SKUs available for your Subscription.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.ApiManagement/skus")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    ApiManagementSkusResult
  >;
}

interface UserSubscriptionOperations {
  /**
   * Lists the collection of subscriptions of the specified user.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/subscriptions")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * User identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @path
      userId: string;

      /**
       * | Field     |     Usage     |     Supported operators    | Supported functions               |</br>|-------------|------------------------|-----------------------------------|</br>|name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|stateComment | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|ownerId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|scope | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|userId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|productId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    ResourceListResult<SubscriptionContract>
  >;

  /**
   * Gets the specified Subscription entity associated with a particular user.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/subscriptions/{sid}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * User identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @path
      userId: string;

      /**
       * Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
       */
      @maxLength(256)
      @pattern("^[^*#&+:<>?]+$")
      @path
      sid: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    SubscriptionContract
  >;
}
