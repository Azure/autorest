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
 * Role Assignments
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(RoleAssignmentProperties)
model RoleAssignment extends ExtensionResourceBase {
  /**
   * The name of the role assignment. It can be any valid GUID.
   */
  @path
  @key("roleAssignmentName")
  @segment("roleAssignments")
  @visibility("read")
  name: string;

  /**
   * Role assignment properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: RoleAssignmentProperties;
}

@armResourceOperations
interface RoleAssignments {
  /**
   * Get a role assignment by scope and name.
   */
  get is ArmResourceRead<
    RoleAssignment,
    {
      ...BaseParameters<RoleAssignment>;

      /**
       * Tenant ID for cross-tenant request
       */
      @query("tenantId")
      tenantId?: string;
    }
  >;

  /**
   * Create or update a role assignment by scope and name.
   */
  create is ArmResourceCreateOrReplaceSync<RoleAssignment>;

  /**
   * Delete a role assignment by scope and name.
   */
  delete is ArmResourceDeleteSync<
    RoleAssignment,
    {
      ...BaseParameters<RoleAssignment>;

      /**
       * Tenant ID for cross-tenant request
       */
      @query("tenantId")
      tenantId?: string;
    }
  >;

  /**
   * List all role assignments that apply to a scope.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RoleAssignments_ListForScope")
  listForScope is ArmResourceListByParent<
    RoleAssignment,
    {
      ...BaseParameters<RoleAssignment>;

      /**
       * The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
       */
      @query("$filter")
      $filter?: string;

      /**
       * Tenant ID for cross-tenant request
       */
      @query("tenantId")
      tenantId?: string;

      /**
       * The skipToken to apply on the operation. Use $skipToken={skiptoken} to return paged role assignments following the skipToken passed. Only supported on provider level calls.
       */
      @query("$skipToken")
      $skipToken?: string;
    }
  >;
}

@@projectedName(RoleAssignments.create::parameters.resource,
  "json",
  "parameters"
);
@@extension(RoleAssignments.create::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(RoleAssignments.create::parameters.resource,
  "Parameters for the role assignment."
);
