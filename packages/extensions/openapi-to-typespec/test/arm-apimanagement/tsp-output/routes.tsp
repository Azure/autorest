import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.ApiManagement;

interface TagOperations {
  @doc("Lists all Tags associated with the API.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags")
  @get
  ListByApi is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.")
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ResourceListResult<TagContract>
  >;

  @doc("Gets the entity state version of the tag specified by its identifier.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}")
  @head
  GetEntityStateByApi is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.")
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      @doc("Tag identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Get tag associated with the API.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}")
  @get
  GetByApi is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.")
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      @doc("Tag identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    TagContract
  >;

  @doc("Assign tag to the Api.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}")
  @put
  AssignToApi is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.")
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      @doc("Tag identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    TagContract
  >;

  @doc("Detach the tag from the Api.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}")
  @delete
  DetachFromApi is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.")
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      @doc("Tag identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Lists all Tags associated with the Product.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags")
  @get
  ListByProduct is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Product identifier. Must be unique in the current API Management service instance.")
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ResourceListResult<TagContract>
  >;

  @doc("Gets the entity state version of the tag specified by its identifier.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}")
  @head
  GetEntityStateByProduct is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Product identifier. Must be unique in the current API Management service instance.")
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      @doc("Tag identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Get tag associated with the Product.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}")
  @get
  GetByProduct is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Product identifier. Must be unique in the current API Management service instance.")
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      @doc("Tag identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    TagContract
  >;

  @doc("Assign tag to the Product.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}")
  @put
  AssignToProduct is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Product identifier. Must be unique in the current API Management service instance.")
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      @doc("Tag identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    TagContract
  >;

  @doc("Detach the tag from the Product.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}")
  @delete
  DetachFromProduct is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Product identifier. Must be unique in the current API Management service instance.")
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      @doc("Tag identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Lists a collection of tags defined within a service instance.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags")
  @get
  ListByService is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("Scope like 'apis', 'products' or 'apis/{apiId}")
      @query("scope")
      scope?: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ResourceListResult<TagContract>
  >;

  @doc("Gets the entity state version of the tag specified by its identifier.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}")
  @head
  GetEntityState is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Tag identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Gets the details of the tag specified by its identifier.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Tag identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    TagContract
  >;

  @doc("Creates a tag.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Tag identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("Create parameters.")
      @body
      parameters: TagCreateUpdateParameters;
    },
    TagContract
  >;

  @doc("Updates the details of the tag specified by its identifier.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Tag identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("Update parameters.")
      @body
      parameters: TagCreateUpdateParameters;
    },
    TagContract
  >;

  @doc("Deletes specific tag of the API Management service instance.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Tag identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      tagId: string;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface ApiPolicyOperations {
  @doc("Get the policy configuration at the API level.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies")
  @get
  ListByApi is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.")
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ResourceListResult<PolicyContract>
  >;

  @doc("Gets the entity state (Etag) version of the API policy specified by its identifier.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}")
  @head
  GetEntityTag is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.")
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      @doc("The identifier of the Policy.")
      @path
      policyId: PolicyIdName;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Get the policy configuration at the API level.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.")
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      @doc("The identifier of the Policy.")
      @path
      policyId: PolicyIdName;

      @doc("Policy Export Format.")
      @query("format")
      format?: PolicyExportFormat = "xml";

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("Accept header")
      @header
      accept: "application/json, application/vnd.ms-azure-apim.policy+xml, application/vnd.ms-azure-apim.policy.raw+xml";
    },
    PolicyContract
  >;

  @doc("Creates or updates policy configuration for the API.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.")
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      @doc("The identifier of the Policy.")
      @path
      policyId: PolicyIdName;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("The policy contents to apply.")
      @body
      parameters: PolicyContract;
    },
    PolicyContract
  >;

  @doc("Deletes the policy configuration at the Api.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.")
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      @doc("The identifier of the Policy.")
      @path
      policyId: PolicyIdName;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface ApiExportOperations {
  @doc("Gets the details of the API specified by its identifier in the format specified to the Storage Blob with SAS Key valid for 5 minutes.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.")
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;

      @doc("Format in which to export the Api Details to the Storage Blob with Sas Key valid for 5 minutes.")
      @query("format")
      format: ExportFormat;

      @doc("Query parameter required to export the API details.")
      @query("export")
      export: ExportApi;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ApiExportResult
  >;
}

interface DiagnosticOperations {
  @doc("Lists all diagnostics of the API Management service instance.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics")
  @get
  ListByService is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ResourceListResult<DiagnosticContract>
  >;

  @doc("Gets the entity state (Etag) version of the Diagnostic specified by its identifier.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}")
  @head
  GetEntityTag is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Diagnostic identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      diagnosticId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Gets the details of the Diagnostic specified by its identifier.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Diagnostic identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      diagnosticId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    DiagnosticContract
  >;

  @doc("Creates a new Diagnostic or updates an existing one.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Diagnostic identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      diagnosticId: string;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("Create parameters.")
      @body
      parameters: DiagnosticContract;
    },
    DiagnosticContract
  >;

  @doc("Updates the details of the Diagnostic specified by its identifier.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Diagnostic identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      diagnosticId: string;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("Diagnostic Update parameters.")
      @body
      parameters: DiagnosticContract;
    },
    DiagnosticContract
  >;

  @doc("Deletes the specified Diagnostic.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Diagnostic identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      diagnosticId: string;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface IssueOperations {
  @doc("Lists a collection of issues in the specified service instance.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/issues")
  @get
  ListByService is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| apiId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| title | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| authorName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq |     |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ResourceListResult<IssueContract>
  >;

  @doc("Gets API Management issue details")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/issues/{issueId}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Issue identifier. Must be unique in the current API Management service instance.")
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      issueId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    IssueContract
  >;
}

interface PolicyOperations {
  @doc("Lists all the Global Policy definitions of the Api Management service.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies")
  @get
  ListByService is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ResourceListResult<PolicyContract>
  >;

  @doc("Gets the entity state (Etag) version of the Global policy definition in the Api Management service.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}")
  @head
  GetEntityTag is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("The identifier of the Policy.")
      @path
      policyId: PolicyIdName;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Get the Global policy definition of the Api Management service.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("The identifier of the Policy.")
      @path
      policyId: PolicyIdName;

      @doc("Policy Export Format.")
      @query("format")
      format?: PolicyExportFormat = "xml";

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    PolicyContract
  >;

  @doc("Creates or updates the global policy configuration of the Api Management service.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("The identifier of the Policy.")
      @path
      policyId: PolicyIdName;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("The policy contents to apply.")
      @body
      parameters: PolicyContract;
    },
    PolicyContract
  >;

  @doc("Deletes the global policy configuration of the Api Management Service.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("The identifier of the Policy.")
      @path
      policyId: PolicyIdName;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface ProductPolicyOperations {
  @doc("Get the policy configuration at the Product level.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies")
  @get
  ListByProduct is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Product identifier. Must be unique in the current API Management service instance.")
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ResourceListResult<PolicyContract>
  >;

  @doc("Get the ETag of the policy configuration at the Product level.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}")
  @head
  GetEntityTag is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Product identifier. Must be unique in the current API Management service instance.")
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      @doc("The identifier of the Policy.")
      @path
      policyId: PolicyIdName;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Get the policy configuration at the Product level.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Product identifier. Must be unique in the current API Management service instance.")
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      @doc("The identifier of the Policy.")
      @path
      policyId: PolicyIdName;

      @doc("Policy Export Format.")
      @query("format")
      format?: PolicyExportFormat = "xml";

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    PolicyContract
  >;

  @doc("Creates or updates policy configuration for the Product.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Product identifier. Must be unique in the current API Management service instance.")
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      @doc("The identifier of the Policy.")
      @path
      policyId: PolicyIdName;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("The policy contents to apply.")
      @body
      parameters: PolicyContract;
    },
    PolicyContract
  >;

  @doc("Deletes the policy configuration at the Product.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Product identifier. Must be unique in the current API Management service instance.")
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

      @doc("The identifier of the Policy.")
      @path
      policyId: PolicyIdName;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface ApiManagementSkusOperations {
  @doc("Gets the list of Microsoft.ApiManagement SKUs available for your Subscription.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.ApiManagement/skus")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ApiManagementSkusResult
  >;
}

interface UserSubscriptionOperations {
  @doc("Lists the collection of subscriptions of the specified user.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/subscriptions")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("User identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @path
      userId: string;

      @doc("| Field     |     Usage     |     Supported operators    | Supported functions               |</br>|-------------|------------------------|-----------------------------------|</br>|name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|stateComment | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|ownerId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|scope | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|userId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>|productId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ResourceListResult<SubscriptionContract>
  >;

  @doc("Gets the specified Subscription entity associated with a particular user.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/subscriptions/{sid}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("User identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @path
      userId: string;

      @doc("Subscription entity Identifier. The entity represents the association between a user and a product in API Management.")
      @maxLength(256)
      @pattern("^[^*#&+:<>?]+$")
      @path
      sid: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    SubscriptionContract
  >;
}
