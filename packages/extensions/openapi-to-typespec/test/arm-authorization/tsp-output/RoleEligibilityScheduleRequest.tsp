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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  RoleEligibilityScheduleRequestProperties
)
model RoleEligibilityScheduleRequest extends Foundations.ExtensionResource {
  ...ResourceNameParameter<
    Resource = RoleEligibilityScheduleRequest,
    KeyName = "roleEligibilityScheduleRequestName",
    SegmentName = "roleEligibilityScheduleRequests",
    NamePattern = ""
  >;

  /**
   * Role eligibility schedule request properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: RoleEligibilityScheduleRequestProperties;
}

@armResourceOperations
interface RoleEligibilityScheduleRequests {
  /**
   * Get the specified role eligibility schedule request.
   */
  get is ArmResourceRead<RoleEligibilityScheduleRequest>;

  /**
   * Creates a role eligibility schedule request.
   */
  create is ArmResourceCreateOrReplaceSync<RoleEligibilityScheduleRequest>;

  /**
   * Gets role eligibility schedule requests for a scope.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RoleEligibilityScheduleRequests_ListForScope")
  listForScope is ArmResourceListByParent<
    RoleEligibilityScheduleRequest,
    {
      ...Azure.ResourceManager.Foundations.ExtensionBaseParameters;

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
  cancel is ArmResourceActionSync<RoleEligibilityScheduleRequest, void, void>;

  /**
   * Validates a new role eligibility schedule request.
   */
  validate is ArmResourceActionSync<
    RoleEligibilityScheduleRequest,
    RoleEligibilityScheduleRequest,
    RoleEligibilityScheduleRequest
  >;
}

@@doc(RoleEligibilityScheduleRequest.name,
  "The name (guid) of the role eligibility schedule request to get."
);
@@encodedName(RoleEligibilityScheduleRequests.create::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(RoleEligibilityScheduleRequests.create::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(RoleEligibilityScheduleRequests.create::parameters.resource,
  "Parameters for the role eligibility schedule request."
);
@@encodedName(RoleEligibilityScheduleRequests.validate::parameters.body,
  "application/json",
  "parameters"
);
@@extension(RoleEligibilityScheduleRequests.validate::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(RoleEligibilityScheduleRequests.validate::parameters.body,
  "Parameters for the role eligibility schedule request."
);
