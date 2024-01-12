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
@doc("Role Eligibility schedule request")
model RoleEligibilityScheduleRequest
  is ExtensionResource<RoleEligibilityScheduleRequestProperties> {
  @doc("The name (guid) of the role eligibility schedule request to get.")
  @path
  @key("roleEligibilityScheduleRequestName")
  @segment("roleEligibilityScheduleRequests")
  name: string;
}

@armResourceOperations
interface RoleEligibilityScheduleRequests {
  @doc("Get the specified role eligibility schedule request.")
  get is ArmResourceRead<RoleEligibilityScheduleRequest>;

  @doc("Creates a role eligibility schedule request.")
  create is ArmResourceCreateOrReplaceSync<RoleEligibilityScheduleRequest>;

  @doc("Gets role eligibility schedule requests for a scope.")
  listForScope is ArmResourceListByParent<
    RoleEligibilityScheduleRequest,
    {
      ...BaseParameters<RoleEligibilityScheduleRequest>;

      @doc("The filter to apply on the operation. Use $filter=atScope() to return all role eligibility schedule requests at or above the scope. Use $filter=principalId eq {id} to return all role eligibility schedule requests at, above or below the scope for the specified principal. Use $filter=asRequestor() to return all role eligibility schedule requests requested by the current user. Use $filter=asTarget() to return all role eligibility schedule requests created for the current user. Use $filter=asApprover() to return all role eligibility schedule requests where the current user is an approver.")
      @query("$filter")
      $filter?: string;
    }
  >;

  @doc("Cancels a pending role eligibility schedule request.")
  cancel is ArmResourceActionSync<RoleEligibilityScheduleRequest, void, void>;

  @doc("Validates a new role eligibility schedule request.")
  validate is ArmResourceActionSync<
    RoleEligibilityScheduleRequest,
    RoleEligibilityScheduleRequest,
    RoleEligibilityScheduleRequest
  >;
}

@@projectedName(RoleEligibilityScheduleRequests.create::parameters.resource,
  "json",
  "parameters"
);
@@extension(RoleEligibilityScheduleRequests.create::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(RoleEligibilityScheduleRequests.create::parameters.resource,
  "Parameters for the role eligibility schedule request."
);
@@projectedName(RoleEligibilityScheduleRequests.validate::parameters.body,
  "json",
  "parameters"
);
@@extension(RoleEligibilityScheduleRequests.validate::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(RoleEligibilityScheduleRequests.validate::parameters.body,
  "Parameters for the role eligibility schedule request."
);
