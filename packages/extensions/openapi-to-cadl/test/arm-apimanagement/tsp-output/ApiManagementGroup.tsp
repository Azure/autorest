import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementService.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Contract details.")
@parentResource(ApiManagementService)
model ApiManagementGroup is ProxyResource<GroupContractProperties> {
  @doc("Group identifier. Must be unique in the current API Management service instance.")
  @maxLength(256)
  @minLength(1)
  @path
  @key("groupId")
  @segment("groups")
  name: string;
}

@armResourceOperations
interface ApiManagementGroups {
  @doc("Gets the details of the group specified by its identifier.")
  get is ArmResourceRead<ApiManagementGroup>;
  @doc("Gets the entity state (Etag) version of the group specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiManagementGroup,
      BaseParameters<ApiManagementGroup>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Creates or Updates a group.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiManagementGroup,
    {
      ...BaseParameters<ApiManagementGroup>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Updates the details of the group specified by its identifier.")
  update is ArmResourcePatchSync<
    ApiManagementGroup,
    GroupContractProperties,
    {
      ...BaseParameters<ApiManagementGroup>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Deletes specific group of the API Management service instance.")
  delete is ArmResourceDeleteSync<
    ApiManagementGroup,
    {
      ...BaseParameters<ApiManagementGroup>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists a collection of groups defined within a service instance.")
  listByService is ArmResourceListByParent<
    ApiManagementGroup,
    {
      ...BaseParameters<ApiManagementGroup>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| externalId | filter | eq |     |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;
    }
  >;
  @doc("Lists a collection of user entities associated with the group.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}/users")
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

      @doc("Group identifier. Must be unique in the current API Management service instance.")
      @maxLength(256)
      @minLength(1)
      @path
      groupId: string;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| firstName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| lastName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| email | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| registrationDate | filter | ge, le, eq, ne, gt, lt |     |</br>| note | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
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
    ApiManagementGroupUserListResult
  >;
}
