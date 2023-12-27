import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Authorization;
@doc("Role management policy")
model RoleManagementPolicyAssignment
  is ExtensionResource<RoleManagementPolicyAssignmentProperties> {
  @doc("The name of format {guid_guid} the role management policy assignment to get.")
  @key("roleManagementPolicyAssignmentName")
  @segment("roleManagementPolicyAssignments")
  name: string;
}

@armResourceOperations
interface RoleManagementPolicyAssignments {
  @doc("Get the specified role management policy assignment for a resource scope")
  get is ArmResourceRead<RoleManagementPolicyAssignment>;
  @doc("Create a role management policy assignment")
  create is ArmResourceCreateOrReplaceSync<RoleManagementPolicyAssignment>;
  @doc("Gets role management assignment policies for a resource scope.")
  listForScope is ArmResourceListByParent<RoleManagementPolicyAssignment>;
}
