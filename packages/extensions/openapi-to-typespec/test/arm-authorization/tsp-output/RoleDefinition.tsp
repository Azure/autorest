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
  get is ArmResourceRead<
    RoleDefinition,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters
  >;

  /**
   * Creates or updates a role definition.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    RoleDefinition,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Response = ArmResourceCreatedSyncResponse<RoleDefinition>
  >;

  /**
   * Deletes a role definition.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteSync<
    RoleDefinition,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Response = ArmResponse<RoleDefinition> | ArmDeletedNoContentResponse
  >;

  /**
   * Get all role definitions that are applicable at scope and above.
   */
  list is ArmResourceListByParent<
    RoleDefinition,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
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
