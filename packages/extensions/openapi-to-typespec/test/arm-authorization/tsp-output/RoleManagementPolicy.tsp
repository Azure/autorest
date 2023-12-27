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
model RoleManagementPolicy
  is ExtensionResource<RoleManagementPolicyProperties> {
  @doc("The name (guid) of the role management policy to get.")
  @key("roleManagementPolicyName")
  @segment("roleManagementPolicies")
  name: string;
}

@armResourceOperations
interface RoleManagementPolicies {
  @doc("Get the specified role management policy for a resource scope")
  get is ArmResourceRead<RoleManagementPolicy>;
  @doc("Update a role management policy")
  update is ArmCustomPatchSync<RoleManagementPolicy, RoleManagementPolicy>;
  @doc("Gets role management policies for a resource scope.")
  listForScope is ArmResourceListByParent<RoleManagementPolicy>;
}
