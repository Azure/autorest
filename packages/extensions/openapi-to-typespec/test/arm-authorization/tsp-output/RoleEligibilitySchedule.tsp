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
 * Role eligibility schedule
 */
model RoleEligibilitySchedule
  is Azure.ResourceManager.ExtensionResource<RoleEligibilityScheduleProperties> {
  ...ResourceNameParameter<
    Resource = RoleEligibilitySchedule,
    KeyName = "roleEligibilityScheduleName",
    SegmentName = "roleEligibilitySchedules",
    NamePattern = ""
  >;
}

@armResourceOperations
interface RoleEligibilitySchedules {
  /**
   * Get the specified role eligibility schedule for a resource scope
   */
  get is ArmResourceRead<
    RoleEligibilitySchedule,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters
  >;

  /**
   * Gets role eligibility schedules for a resource scope.
   */
  listForScope is ArmResourceListByParent<
    RoleEligibilitySchedule,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The filter to apply on the operation. Use $filter=atScope() to return all role eligibility schedules at or above the scope. Use $filter=principalId eq {id} to return all role eligibility schedules at, above or below the scope for the specified principal. Use $filter=assignedTo('{userId}') to return all role eligibility schedules for the user. Use $filter=asTarget() to return all role eligibility schedules created for the current user.
       */
      @query("$filter")
      $filter?: string;
    }
  >;
}

@@doc(RoleEligibilitySchedule.name,
  "The name (guid) of the role eligibility schedule to get."
);
@@doc(RoleEligibilitySchedule.properties,
  "role eligibility schedule properties."
);
