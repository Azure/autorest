import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Authorization;
@doc("Role Assignments")
model RoleAssignment is ExtensionResource<RoleAssignmentProperties> {
  @doc("The name of the role assignment. It can be any valid GUID.")
  @key("roleAssignmentName")
  @segment("roleAssignments")
  name: string;
}

@armResourceOperations
interface RoleAssignments {
  @doc("Get a role assignment by scope and name.")
  get is ArmResourceRead<
    RoleAssignment,
    {
      ...BaseParameters<RoleAssignment>;

      @doc("Tenant ID for cross-tenant request")
      @query("tenantId")
      tenantId?: string;
    }
  >;

  @doc("Create or update a role assignment by scope and name.")
  create is ArmResourceCreateOrReplaceSync<RoleAssignment>;

  @doc("Delete a role assignment by scope and name.")
  delete is ArmResourceDeleteSync<
    RoleAssignment,
    {
      ...BaseParameters<RoleAssignment>;

      @doc("Tenant ID for cross-tenant request")
      @query("tenantId")
      tenantId?: string;
    }
  >;

  @doc("List all role assignments that apply to a scope.")
  listForScope is ArmResourceListByParent<
    RoleAssignment,
    {
      ...BaseParameters<RoleAssignment>;

      @doc("The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.")
      @query("$filter")
      $filter?: string;

      @doc("Tenant ID for cross-tenant request")
      @query("tenantId")
      tenantId?: string;

      @doc("The skipToken to apply on the operation. Use $skipToken={skiptoken} to return paged role assignments following the skipToken passed. Only supported on provider level calls.")
      @query("$skipToken")
      $skipToken?: string;
    }
  >;
}
