import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Authorization;
@doc("Information about current or upcoming role eligibility schedule instance")
model RoleEligibilityScheduleInstance
  is ExtensionResource<RoleEligibilityScheduleInstanceProperties> {
  @doc("The name (hash of schedule name + time) of the role eligibility schedule to get.")
  @key("roleEligibilityScheduleInstanceName")
  @segment("roleEligibilityScheduleInstances")
  name: string;
}

@armResourceOperations
interface RoleEligibilityScheduleInstances {
  @doc("Gets the specified role eligibility schedule instance.")
  get is ArmResourceRead<RoleEligibilityScheduleInstance>;
  @doc("Gets role eligibility schedule instances of a role eligibility schedule.")
  listForScope is ArmResourceListByParent<
    RoleEligibilityScheduleInstance,
    {
      ...BaseParameters<RoleEligibilityScheduleInstance>;

      @doc("The filter to apply on the operation. Use $filter=atScope() to return all role assignment schedules at or above the scope. Use $filter=principalId eq {id} to return all role assignment schedules at, above or below the scope for the specified principal. Use $filter=assignedTo('{userId}') to return all role eligibility schedules for the user. Use $filter=asTarget() to return all role eligibility schedules created for the current user.")
      @query("$filter")
      $filter?: string;
    }
  >;
}
