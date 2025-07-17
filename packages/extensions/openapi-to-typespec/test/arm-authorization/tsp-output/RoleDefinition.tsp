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
 * Role definition.
 */
@extensionResource
model RoleDefinition
  is Azure.ResourceManager.ExtensionResource<RoleDefinitionProperties> {
  ...ResourceNameParameter<
    Resource = RoleDefinition,
    KeyName = "roleDefinitionId",
    SegmentName = "roleDefinitions",
    NamePattern = ""
  >;
}

@armResourceOperations
interface RoleDefinitions {
  /**
   * Get role definition by name (GUID).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RoleDefinitions_Get")
  get is Extension.Read<Extension.ScopeParameter, RoleDefinition>;

  /**
   * Creates or updates a role definition.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  @operationId("RoleDefinitions_CreateOrUpdate")
  createOrUpdate is Extension.CreateOrReplaceSync<
    Extension.ScopeParameter,
    RoleDefinition,
    Response = ArmResourceCreatedSyncResponse<RoleDefinition>
  >;

  /**
   * Deletes a role definition.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RoleDefinitions_Delete")
  delete is Extension.DeleteSync<
    Extension.ScopeParameter,
    RoleDefinition,
    Response = ArmResponse<RoleDefinition> | ArmDeletedNoContentResponse
  >;

  /**
   * Get all role definitions that are applicable at scope and above.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RoleDefinitions_List")
  list is Extension.ListByTarget<
    Extension.ScopeParameter,
    RoleDefinition,
    Parameters = {
      /**
       * The filter to apply on the operation. Use atScopeAndBelow filter to search below the given scope as well.
       */
      @query("$filter")
      $filter?: string;
    }
  >;
}

@@doc(RoleDefinition.name, "The ID of the role definition.");
@@doc(RoleDefinition.properties, "Role definition properties.");
@@doc(RoleDefinitions.createOrUpdate::parameters.resource,
  "The values for the role definition."
);
