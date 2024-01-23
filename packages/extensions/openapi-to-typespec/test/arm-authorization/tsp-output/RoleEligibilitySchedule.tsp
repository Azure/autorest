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
 * Role eligibility schedule
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@Azure.ResourceManager.Private.armResourceInternal(
  RoleEligibilityScheduleProperties
)
@includeInapplicableMetadataInPayload(false)
model RoleEligibilitySchedule extends ExtensionResourceBase {
  /**
   * The name (guid) of the role eligibility schedule to get.
   */
  @path
  @key("roleEligibilityScheduleName")
  @segment("roleEligibilitySchedules")
  name: string;

  /**
   * role eligibility schedule properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: RoleEligibilityScheduleProperties;
}

@armResourceOperations
interface RoleEligibilitySchedules {
  /**
   * Get the specified role eligibility schedule for a resource scope
   */
  get is ArmResourceRead<RoleEligibilitySchedule>;

  /**
   * Gets role eligibility schedules for a resource scope.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RoleEligibilitySchedules_ListForScope")
  listForScope is ArmResourceListByParent<
    RoleEligibilitySchedule,
    {
      ...BaseParameters<RoleEligibilitySchedule>;

      /**
       * The filter to apply on the operation. Use $filter=atScope() to return all role eligibility schedules at or above the scope. Use $filter=principalId eq {id} to return all role eligibility schedules at, above or below the scope for the specified principal. Use $filter=assignedTo('{userId}') to return all role eligibility schedules for the user. Use $filter=asTarget() to return all role eligibility schedules created for the current user.
       */
      @query("$filter")
      $filter?: string;
    }
  >;
}
