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
@Azure.ResourceManager.Private.armResourceInternal(
  RoleManagementPolicyAssignmentProperties
)
@includeInapplicableMetadataInPayload(false)
model RoleManagementPolicyAssignment extends ExtensionResourceBase {
  /**
   * The name of format {guid_guid} the role management policy assignment to get.
   */
  @path
  @key("roleManagementPolicyAssignmentName")
  @segment("roleManagementPolicyAssignments")
  name: string;

  /**
   * Role management policy properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: RoleManagementPolicyAssignmentProperties;
}

@armResourceOperations
interface RoleManagementPolicyAssignments {
  /**
   * Get the specified role management policy assignment for a resource scope
   */
  get is ArmResourceRead<RoleManagementPolicyAssignment>;

  /**
   * Create a role management policy assignment
   */
  create is ArmResourceCreateOrReplaceSync<RoleManagementPolicyAssignment>;

  /**
   * Gets role management assignment policies for a resource scope.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RoleManagementPolicyAssignments_ListForScope")
  listForScope is ArmResourceListByParent<RoleManagementPolicyAssignment>;
}

@@projectedName(RoleManagementPolicyAssignments.create::parameters.resource,
  "json",
  "parameters"
);
@@extension(RoleManagementPolicyAssignments.create::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(RoleManagementPolicyAssignments.create::parameters.resource,
  "Parameters for the role management policy assignment."
);
