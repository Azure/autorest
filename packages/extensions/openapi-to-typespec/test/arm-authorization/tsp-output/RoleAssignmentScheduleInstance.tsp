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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  RoleAssignmentScheduleInstanceProperties
)
model RoleAssignmentScheduleInstance extends Foundations.ExtensionResource {
  ...ResourceNameParameter<
    Resource = RoleAssignmentScheduleInstance,
    KeyName = "roleAssignmentScheduleInstanceName",
    SegmentName = "roleAssignmentScheduleInstances",
    NamePattern = ""
  >;

  /**
   * Role assignment schedule instance properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: RoleAssignmentScheduleInstanceProperties;
}

@armResourceOperations
interface RoleAssignmentScheduleInstances {
  /**
   * Gets the specified role assignment schedule instance.
   */
  get is ArmResourceRead<RoleAssignmentScheduleInstance>;

  /**
   * Gets role assignment schedule instances of a role assignment schedule.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RoleAssignmentScheduleInstances_ListForScope")
  listForScope is ArmResourceListByParent<
    RoleAssignmentScheduleInstance,
    {
      ...Azure.ResourceManager.Foundations.ExtensionBaseParameters;

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
