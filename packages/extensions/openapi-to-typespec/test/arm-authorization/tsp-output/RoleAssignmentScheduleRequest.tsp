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
 * Role Assignment schedule request
 */
@extensionResource
model RoleAssignmentScheduleRequest
  is Azure.ResourceManager.ExtensionResource<RoleAssignmentScheduleRequestProperties> {
  ...ResourceNameParameter<
    Resource = RoleAssignmentScheduleRequest,
    KeyName = "roleAssignmentScheduleRequestName",
    SegmentName = "roleAssignmentScheduleRequests",
    NamePattern = ""
  >;
}

@armResourceOperations
interface RoleAssignmentScheduleRequests {
  /**
   * Get the specified role assignment schedule request.
   */
  get is ArmResourceRead<
    RoleAssignmentScheduleRequest,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the role assignment schedule request.
       */
      @path
      scope: string;

      /**
       * The name (guid) of the role assignment schedule request to get.
       */
      @path
      roleAssignmentScheduleRequestName: string;
    }
  >;

  /**
   * Creates a role assignment schedule request.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  create is ArmResourceCreateOrReplaceSync<
    RoleAssignmentScheduleRequest,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the role assignment schedule request to create. The scope can be any REST resource instance. For example, use '/subscriptions/{subscription-id}/' for a subscription, '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}' for a resource group, and '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider}/{resource-type}/{resource-name}' for a resource.
       */
      @path
      scope: string;

      /**
       * A GUID for the role assignment to create. The name must be unique and different for each role assignment.
       */
      @path
      roleAssignmentScheduleRequestName: string;
    },
    Response = ArmResourceCreatedSyncResponse<RoleAssignmentScheduleRequest>
  >;

  /**
   * Gets role assignment schedule requests for a scope.
   */
  listForScope is ArmResourceListByParent<
    RoleAssignmentScheduleRequest,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the role assignments schedule requests.
       */
      @path
      scope: string;

      /**
       * The filter to apply on the operation. Use $filter=atScope() to return all role assignment schedule requests at or above the scope. Use $filter=principalId eq {id} to return all role assignment schedule requests at, above or below the scope for the specified principal. Use $filter=asRequestor() to return all role assignment schedule requests requested by the current user. Use $filter=asTarget() to return all role assignment schedule requests created for the current user. Use $filter=asApprover() to return all role assignment schedule requests where the current user is an approver.
       */
      @query("$filter")
      $filter?: string;
    }
  >;

  /**
   * Cancels a pending role assignment schedule request.
   */
  cancel is ArmResourceActionSync<
    RoleAssignmentScheduleRequest,
    void,
    OkResponse,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the role assignment request to cancel.
       */
      @path
      scope: string;

      /**
       * The name of the role assignment request to cancel.
       */
      @path
      roleAssignmentScheduleRequestName: string;
    }
  >;

  /**
   * Validates a new role assignment schedule request.
   */
  validate is ArmResourceActionSync<
    RoleAssignmentScheduleRequest,
    RoleAssignmentScheduleRequest,
    ArmResponse<RoleAssignmentScheduleRequest>,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the role assignment request to validate.
       */
      @path
      scope: string;

      /**
       * The name of the role assignment request to validate.
       */
      @path
      roleAssignmentScheduleRequestName: string;
    }
  >;
}

@@doc(RoleAssignmentScheduleRequest.name,
  "The name (guid) of the role assignment schedule request to get."
);
@@doc(RoleAssignmentScheduleRequest.properties,
  "Role assignment schedule request properties."
);
@@doc(RoleAssignmentScheduleRequests.create::parameters.resource,
  "Parameters for the role assignment schedule request."
);
@@doc(RoleAssignmentScheduleRequests.validate::parameters.body,
  "Parameters for the role assignment schedule request."
);
