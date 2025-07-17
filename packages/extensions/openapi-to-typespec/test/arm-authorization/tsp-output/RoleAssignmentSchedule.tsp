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
 * Role Assignment schedule
 */
@extensionResource
model RoleAssignmentSchedule
  is Azure.ResourceManager.ExtensionResource<RoleAssignmentScheduleProperties> {
  ...ResourceNameParameter<
    Resource = RoleAssignmentSchedule,
    KeyName = "roleAssignmentScheduleName",
    SegmentName = "roleAssignmentSchedules",
    NamePattern = ""
  >;
}

@armResourceOperations
interface RoleAssignmentSchedules {
  /**
   * Get the specified role assignment schedule for a resource scope
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RoleAssignmentSchedules_Get")
  get is Extension.Read<Extension.ScopeParameter, RoleAssignmentSchedule>;

  /**
   * Gets role assignment schedules for a resource scope.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RoleAssignmentSchedules_ListForScope")
  listForScope is Extension.ListByTarget<
    Extension.ScopeParameter,
    RoleAssignmentSchedule,
    Parameters = {
      /**
       * The filter to apply on the operation. Use $filter=atScope() to return all role assignment schedules at or above the scope. Use $filter=principalId eq {id} to return all role assignment schedules at, above or below the scope for the specified principal. Use $filter=assignedTo('{userId}') to return all role assignment schedules for the current user. Use $filter=asTarget() to return all role assignment schedules created for the current user.
       */
      @query("$filter")
      $filter?: string;
    }
  >;
}

@@doc(RoleAssignmentSchedule.name,
  "The name (guid) of the role assignment schedule to get."
);
@@doc(RoleAssignmentSchedule.properties,
  "Role assignment schedule properties."
);
