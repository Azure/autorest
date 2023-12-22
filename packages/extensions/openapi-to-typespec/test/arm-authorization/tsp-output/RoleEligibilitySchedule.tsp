import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Authorization;
@doc("Role eligibility schedule")
model RoleEligibilitySchedule
  is ExtensionResource<RoleEligibilityScheduleProperties> {
  @doc("The name (guid) of the role eligibility schedule to get.")
  @path
  @key("roleEligibilityScheduleName")
  @segment("roleEligibilitySchedules")
  name: string;
}

@armResourceOperations
interface RoleEligibilitySchedules {
  @doc("Get the specified role eligibility schedule for a resource scope")
  get is ArmResourceRead<RoleEligibilitySchedule>;
  @doc("Gets role eligibility schedules for a resource scope.")
  listForScope is ArmResourceListByParent<
    RoleEligibilitySchedule,
    {
      ...BaseParameters<RoleEligibilitySchedule>;

      @doc("The filter to apply on the operation. Use $filter=atScope() to return all role eligibility schedules at or above the scope. Use $filter=principalId eq {id} to return all role eligibility schedules at, above or below the scope for the specified principal. Use $filter=assignedTo('{userId}') to return all role eligibility schedules for the user. Use $filter=asTarget() to return all role eligibility schedules created for the current user.")
      @query("$filter")
      $filter?: string;
    }
  >;
}
