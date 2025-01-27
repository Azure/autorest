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
@extensionResource
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
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the role eligibility schedule request.
       */
      @path
      scope: string;

      /**
       * The name (guid) of the role eligibility schedule request to get.
       */
      @path
      roleEligibilityScheduleRequestName: string;
    }
  >;

  /**
   * Creates a role eligibility schedule request.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  create is ArmResourceCreateOrReplaceSync<
    RoleEligibilityScheduleRequest,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the role eligibility schedule request to create. The scope can be any REST resource instance. For example, use '/subscriptions/{subscription-id}/' for a subscription, '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}' for a resource group, and '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider}/{resource-type}/{resource-name}' for a resource.
       */
      @path
      scope: string;

      /**
       * The name of the role eligibility to create. It can be any valid GUID.
       */
      @path
      roleEligibilityScheduleRequestName: string;
    },
    Response = ArmResourceCreatedSyncResponse<RoleEligibilityScheduleRequest>
  >;

  /**
   * Gets role eligibility schedule requests for a scope.
   */
  listForScope is ArmResourceListByParent<
    RoleEligibilityScheduleRequest,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the role eligibility schedule requests.
       */
      @path
      scope: string;

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
    OkResponse,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the role eligibility request to cancel.
       */
      @path
      scope: string;

      /**
       * The name of the role eligibility request to cancel.
       */
      @path
      roleEligibilityScheduleRequestName: string;
    }
  >;

  /**
   * Validates a new role eligibility schedule request.
   */
  validate is ArmResourceActionSync<
    RoleEligibilityScheduleRequest,
    RoleEligibilityScheduleRequest,
    ArmResponse<RoleEligibilityScheduleRequest>,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the role eligibility request to validate.
       */
      @path
      scope: string;

      /**
       * The name of the role eligibility request to validate.
       */
      @path
      roleEligibilityScheduleRequestName: string;
    }
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
