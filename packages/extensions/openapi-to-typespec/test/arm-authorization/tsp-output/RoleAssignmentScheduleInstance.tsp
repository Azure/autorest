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
 * Information about current or upcoming role assignment schedule instance
 */
@extensionResource
model RoleAssignmentScheduleInstance
  is Azure.ResourceManager.ExtensionResource<RoleAssignmentScheduleInstanceProperties> {
  ...ResourceNameParameter<
    Resource = RoleAssignmentScheduleInstance,
    KeyName = "roleAssignmentScheduleInstanceName",
    SegmentName = "roleAssignmentScheduleInstances",
    NamePattern = ""
  >;
}

@armResourceOperations
interface RoleAssignmentScheduleInstances {
  /**
   * Gets the specified role assignment schedule instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RoleAssignmentScheduleInstances_Get")
  get is Extension.Read<
    Extension.ScopeParameter,
    RoleAssignmentScheduleInstance
  >;

  /**
   * Gets role assignment schedule instances of a role assignment schedule.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RoleAssignmentScheduleInstances_ListForScope")
  listForScope is Extension.ListByTarget<
    Extension.ScopeParameter,
    RoleAssignmentScheduleInstance,
    Parameters = {
      /**
       * The filter to apply on the operation. Use $filter=atScope() to return all role assignment schedules at or above the scope. Use $filter=principalId eq {id} to return all role assignment schedules at, above or below the scope for the specified principal.  Use $filter=assignedTo('{userId}') to return all role assignment schedule instances for the user. Use $filter=asTarget() to return all role assignment schedule instances created for the current user.
       */
      @query("$filter")
      $filter?: string;
    }
  >;
}

@@doc(RoleAssignmentScheduleInstance.name,
  "The name (hash of schedule name + time) of the role assignment schedule to get."
);
@@doc(RoleAssignmentScheduleInstance.properties,
  "Role assignment schedule instance properties."
);
