import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Authorization;
@doc("Role Assignment schedule request")
model RoleAssignmentScheduleRequest
  is ExtensionResource<RoleAssignmentScheduleRequestProperties> {
  @doc("The name (guid) of the role assignment schedule request to get.")
  @key("roleAssignmentScheduleRequestName")
  @segment("roleAssignmentScheduleRequests")
  name: string;
}

@armResourceOperations
interface RoleAssignmentScheduleRequests {
  @doc("Get the specified role assignment schedule request.")
  get is ArmResourceRead<RoleAssignmentScheduleRequest>;

  @doc("Creates a role assignment schedule request.")
  create is ArmResourceCreateOrReplaceSync<RoleAssignmentScheduleRequest>;

  @doc("Gets role assignment schedule requests for a scope.")
  listForScope is ArmResourceListByParent<
    RoleAssignmentScheduleRequest,
    {
      ...BaseParameters<RoleAssignmentScheduleRequest>;

      @doc("The filter to apply on the operation. Use $filter=atScope() to return all role assignment schedule requests at or above the scope. Use $filter=principalId eq {id} to return all role assignment schedule requests at, above or below the scope for the specified principal. Use $filter=asRequestor() to return all role assignment schedule requests requested by the current user. Use $filter=asTarget() to return all role assignment schedule requests created for the current user. Use $filter=asApprover() to return all role assignment schedule requests where the current user is an approver.")
      @query("$filter")
      $filter?: string;
    }
  >;

  @doc("Cancels a pending role assignment schedule request.")
  cancel is ArmResourceActionSync<RoleAssignmentScheduleRequest, void, void>;

  @doc("Validates a new role assignment schedule request.")
  validate is ArmResourceActionSync<
    RoleAssignmentScheduleRequest,
    RoleAssignmentScheduleRequest,
    RoleAssignmentScheduleRequest
  >;
}
