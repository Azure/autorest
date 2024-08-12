import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.Authorization;
/**
 * Role management policy
 */
model RoleManagementPolicyAssignment
  is Azure.ResourceManager.ExtensionResource<RoleManagementPolicyAssignmentProperties> {
  ...ResourceNameParameter<
    Resource = RoleManagementPolicyAssignment,
    KeyName = "roleManagementPolicyAssignmentName",
    SegmentName = "roleManagementPolicyAssignments",
    NamePattern = ""
  >;
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

@@doc(RoleManagementPolicyAssignment.name,
  "The name of format {guid_guid} the role management policy assignment to get."
);
@@doc(RoleManagementPolicyAssignment.properties,
  "Role management policy properties."
);
@@encodedName(RoleManagementPolicyAssignments.create::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(RoleManagementPolicyAssignments.create::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(RoleManagementPolicyAssignments.create::parameters.resource,
  "Parameters for the role management policy assignment."
);
