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
@doc("Information about current or upcoming role assignment schedule instance")
model RoleAssignmentScheduleInstance
  is ExtensionResource<RoleAssignmentScheduleInstanceProperties> {
  @doc("The name (hash of schedule name + time) of the role assignment schedule to get.")
  @path
  @key("roleAssignmentScheduleInstanceName")
  @segment("roleAssignmentScheduleInstances")
  name: string;
}

@armResourceOperations
interface RoleAssignmentScheduleInstances {
  @doc("Gets the specified role assignment schedule instance.")
  get is ArmResourceRead<RoleAssignmentScheduleInstance>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets role assignment schedule instances of a role assignment schedule.")
  @operationId("RoleAssignmentScheduleInstances_ListForScope")
  listForScope is ArmResourceListByParent<
    RoleAssignmentScheduleInstance,
    {
      ...BaseParameters<RoleAssignmentScheduleInstance>;

      @doc("The filter to apply on the operation. Use $filter=atScope() to return all role assignment schedules at or above the scope. Use $filter=principalId eq {id} to return all role assignment schedules at, above or below the scope for the specified principal.  Use $filter=assignedTo('{userId}') to return all role assignment schedule instances for the user. Use $filter=asTarget() to return all role assignment schedule instances created for the current user.")
      @query("$filter")
      $filter?: string;
    }
  >;
}
