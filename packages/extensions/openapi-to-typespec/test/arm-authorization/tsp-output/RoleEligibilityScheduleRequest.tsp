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
 * Role Eligibility schedule request
 */
model RoleEligibilityScheduleRequest
  is Azure.ResourceManager.ExtensionResource<RoleEligibilityScheduleRequestProperties> {
  ...ResourceNameParameter<
    Resource = RoleEligibilityScheduleRequest,
    KeyName = "roleEligibilityScheduleRequestName",
    SegmentName = "roleEligibilityScheduleRequests",
    NamePattern = ""
  >;
}

@armResourceOperations
interface RoleEligibilityScheduleRequests {
  /**
   * Get the specified role eligibility schedule request.
   */
  get is ArmResourceRead<
    RoleEligibilityScheduleRequest,
    Azure.ResourceManager.Foundations.ExtensionBaseParameters
  >;

  /**
   * Creates a role eligibility schedule request.
   */
  create is ArmResourceCreateOrReplaceSync<
    RoleEligibilityScheduleRequest,
    Azure.ResourceManager.Foundations.ExtensionBaseParameters
  >;

  /**
   * Gets role eligibility schedule requests for a scope.
   */
  listForScope is ArmResourceListByParent<
    RoleEligibilityScheduleRequest,
    Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The filter to apply on the operation. Use $filter=atScope() to return all role eligibility schedule requests at or above the scope. Use $filter=principalId eq {id} to return all role eligibility schedule requests at, above or below the scope for the specified principal. Use $filter=asRequestor() to return all role eligibility schedule requests requested by the current user. Use $filter=asTarget() to return all role eligibility schedule requests created for the current user. Use $filter=asApprover() to return all role eligibility schedule requests where the current user is an approver.
       */
      @query("$filter")
      $filter?: string;
    }
  >;

  /**
   * Cancels a pending role eligibility schedule request.
   */
  cancel is ArmResourceActionSync<
    RoleEligibilityScheduleRequest,
    void,
    void,
    Azure.ResourceManager.Foundations.ExtensionBaseParameters
  >;

  /**
   * Validates a new role eligibility schedule request.
   */
  validate is ArmResourceActionSync<
    RoleEligibilityScheduleRequest,
    RoleEligibilityScheduleRequest,
    RoleEligibilityScheduleRequest,
    Azure.ResourceManager.Foundations.ExtensionBaseParameters
  >;
}

@@doc(RoleEligibilityScheduleRequest.name,
  "The name (guid) of the role eligibility schedule request to get."
);
@@doc(RoleEligibilityScheduleRequest.properties,
  "Role eligibility schedule request properties."
);
@@doc(RoleEligibilityScheduleRequests.create::parameters.resource,
  "Parameters for the role eligibility schedule request."
);
@@doc(RoleEligibilityScheduleRequests.validate::parameters.body,
  "Parameters for the role eligibility schedule request."
);
