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
/**
 * Role Assignment schedule request
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  RoleAssignmentScheduleRequestProperties
)
model RoleAssignmentScheduleRequest extends ExtensionResourceBase {
  /**
   * The name (guid) of the role assignment schedule request to get.
   */
  @path
  @key("roleAssignmentScheduleRequestName")
  @segment("roleAssignmentScheduleRequests")
  @visibility("read")
  name: string;

  /**
   * Role assignment schedule request properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: RoleAssignmentScheduleRequestProperties;
}

@armResourceOperations
interface RoleAssignmentScheduleRequests {
  /**
   * Get the specified role assignment schedule request.
   */
  get is ArmResourceRead<RoleAssignmentScheduleRequest>;

  /**
   * Creates a role assignment schedule request.
   */
  create is ArmResourceCreateOrReplaceSync<RoleAssignmentScheduleRequest>;

  /**
   * Gets role assignment schedule requests for a scope.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RoleAssignmentScheduleRequests_ListForScope")
  listForScope is ArmResourceListByParent<
    RoleAssignmentScheduleRequest,
    {
      ...BaseParameters<RoleAssignmentScheduleRequest>;

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
  cancel is ArmResourceActionSync<RoleAssignmentScheduleRequest, void, void>;

  /**
   * Validates a new role assignment schedule request.
   */
  validate is ArmResourceActionSync<
    RoleAssignmentScheduleRequest,
    RoleAssignmentScheduleRequest,
    RoleAssignmentScheduleRequest
  >;
}

@@encodedName(RoleAssignmentScheduleRequests.create::parameters.resource,
  "json",
  "parameters"
);
@@extension(RoleAssignmentScheduleRequests.create::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(RoleAssignmentScheduleRequests.create::parameters.resource,
  "Parameters for the role assignment schedule request."
);
@@encodedName(RoleAssignmentScheduleRequests.validate::parameters.body,
  "json",
  "parameters"
);
@@extension(RoleAssignmentScheduleRequests.validate::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(RoleAssignmentScheduleRequests.validate::parameters.body,
  "Parameters for the role assignment schedule request."
);
