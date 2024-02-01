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
/**
 * Role management policy
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  RoleManagementPolicyProperties
)
model RoleManagementPolicy extends ExtensionResourceBase {
  /**
   * The name (guid) of the role management policy to get.
   */
  @path
  @key("roleManagementPolicyName")
  @segment("roleManagementPolicies")
  @visibility("read")
  name: string;

  /**
   * Role management policy properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: RoleManagementPolicyProperties;
}

@armResourceOperations
interface RoleManagementPolicies {
  /**
   * Get the specified role management policy for a resource scope
   */
  get is ArmResourceRead<RoleManagementPolicy>;

  /**
   * Update a role management policy
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<RoleManagementPolicy, RoleManagementPolicy>;

  /**
   * Gets role management policies for a resource scope.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
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
