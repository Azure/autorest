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
@doc("Role management policy")
model RoleManagementPolicy
  is ExtensionResource<RoleManagementPolicyProperties> {
  @doc("The name (guid) of the role management policy to get.")
  @path
  @key("roleManagementPolicyName")
  @segment("roleManagementPolicies")
  name: string;
}

@armResourceOperations
interface RoleManagementPolicies {
  @doc("Get the specified role management policy for a resource scope")
  get is ArmResourceRead<RoleManagementPolicy>;

  @doc("Update a role management policy")
  @parameterVisibility("read")
  update is ArmCustomPatchSync<RoleManagementPolicy, RoleManagementPolicy>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets role management policies for a resource scope.")
  @operationId("RoleManagementPolicies_ListForScope")
  listForScope is ArmResourceListByParent<RoleManagementPolicy>;
}

@@projectedName(RoleManagementPolicies.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(RoleManagementPolicies.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(RoleManagementPolicies.update::parameters.properties,
  "Parameters for the role management policy."
);
