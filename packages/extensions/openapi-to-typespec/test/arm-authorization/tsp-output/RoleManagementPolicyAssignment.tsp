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
@extensionResource
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
  get is Extension.Read<
    Extension.ScopeParameter,
    RoleManagementPolicyAssignment
  >;

  /**
   * Create a role management policy assignment
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  create is Extension.CreateOrReplaceSync<
    Extension.ScopeParameter,
    RoleManagementPolicyAssignment,
    Response = ArmResourceCreatedSyncResponse<RoleManagementPolicyAssignment>
  >;

  /**
   * Gets role management assignment policies for a resource scope.
   */
  listForScope is Extension.ListByTarget<
    Extension.ScopeParameter,
    RoleManagementPolicyAssignment
  >;
}

@@doc(RoleManagementPolicyAssignment.name,
  "The name of format {guid_guid} the role management policy assignment to get."
);
@@doc(RoleManagementPolicyAssignment.properties,
  "Role management policy properties."
);
@@doc(RoleManagementPolicyAssignments.create::parameters.resource,
  "Parameters for the role management policy assignment."
);
