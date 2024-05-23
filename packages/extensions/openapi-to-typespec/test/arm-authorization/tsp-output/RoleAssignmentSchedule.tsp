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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  RoleAssignmentScheduleProperties
)
model RoleAssignmentSchedule extends Foundations.ExtensionResource {
  ...ResourceNameParameter<
    Resource = RoleAssignmentSchedule,
    KeyName = "roleAssignmentScheduleName",
    SegmentName = "roleAssignmentSchedules",
    NamePattern = ""
  >;

  /**
   * Role assignment schedule properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: RoleAssignmentScheduleProperties;
}

@armResourceOperations
interface RoleAssignmentSchedules {
  /**
   * Get the specified role assignment schedule for a resource scope
   */
  get is ArmResourceRead<RoleAssignmentSchedule>;

  /**
   * Gets role assignment schedules for a resource scope.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RoleAssignmentSchedules_ListForScope")
  listForScope is ArmResourceListByParent<
    RoleAssignmentSchedule,
    {
      ...Azure.ResourceManager.Foundations.ExtensionBaseParameters;

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
