import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.Authorization;
@doc("Deny Assignment")
model DenyAssignment is ExtensionResource<DenyAssignmentProperties> {
  @doc("The ID of the deny assignment to get.")
  @path
  @key("denyAssignmentId")
  @segment("denyAssignments")
  name: string;
}

@armResourceOperations
interface DenyAssignments {
  @doc("Get the specified deny assignment.")
  get is ArmResourceRead<DenyAssignment>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets deny assignments for a resource.")
  @operationId("DenyAssignments_ListForResource")
  listForResource is ArmResourceListByParent<
    DenyAssignment,
    {
      ...BaseParameters<DenyAssignment>;

      @doc("The ID of the target subscription.")
      @minLength(1)
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      @doc("The namespace of the resource provider.")
      @path
      resourceProviderNamespace: string;

      @doc("The parent resource identity.")
      @path
      parentResourcePath: string;

      @doc("The resource type of the resource.")
      @path
      resourceType: string;

      @doc("The name of the resource to get deny assignments for.")
      @path
      resourceName: string;

      @doc("The filter to apply on the operation. Use $filter=atScope() to return all deny assignments at or above the scope. Use $filter=denyAssignmentName eq '{name}' to search deny assignments by name at specified scope. Use $filter=principalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. Use $filter=gdprExportPrincipalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. This filter is different from the principalId filter as it returns not only those deny assignments that contain the specified principal is the Principals list but also those deny assignments that contain the specified principal is the ExcludePrincipals list. Additionally, when gdprExportPrincipalId filter is used, only the deny assignment name and description properties are returned.")
      @query("$filter")
      $filter?: string;
    }
  >;
}
