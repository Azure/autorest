import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Authorization;
@doc("Role Assignment schedule")
model RoleAssignmentSchedule
  is ExtensionResource<RoleAssignmentScheduleProperties> {
  @doc("The name (guid) of the role assignment schedule to get.")
  @key("roleAssignmentScheduleName")
  @segment("roleAssignmentSchedules")
  name: string;
}

@armResourceOperations
interface RoleAssignmentSchedules {
  @doc("Get the specified role assignment schedule for a resource scope")
  get is ArmResourceRead<RoleAssignmentSchedule>;

  @doc("Gets role assignment schedules for a resource scope.")
  listForScope is ArmResourceListByParent<
    RoleAssignmentSchedule,
    {
      ...BaseParameters<RoleAssignmentSchedule>;

      @doc("The filter to apply on the operation. Use $filter=atScope() to return all role assignment schedules at or above the scope. Use $filter=principalId eq {id} to return all role assignment schedules at, above or below the scope for the specified principal. Use $filter=assignedTo('{userId}') to return all role assignment schedules for the current user. Use $filter=asTarget() to return all role assignment schedules created for the current user.")
      @query("$filter")
      $filter?: string;
    }
  >;
}
