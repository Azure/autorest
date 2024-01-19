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
 * Role definition.
 */
model RoleDefinition is ExtensionResource<RoleDefinitionProperties> {
  /**
   * The ID of the role definition.
   */
  @path
  @key("roleDefinitionId")
  @segment("roleDefinitions")
  name: string;
}

@armResourceOperations
interface RoleDefinitions {
  /**
   * Get role definition by name (GUID).
   */
  get is ArmResourceRead<RoleDefinition>;

  /**
   * Creates or updates a role definition.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<RoleDefinition>;

  /**
   * Deletes a role definition.
   */
  delete is ArmResourceDeleteSync<RoleDefinition>;

  /**
   * Get all role definitions that are applicable at scope and above.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RoleDefinitions_List")
  list is ArmResourceListByParent<
    RoleDefinition,
    {
      ...BaseParameters<RoleDefinition>;

      /**
       * The filter to apply on the operation. Use atScopeAndBelow filter to search below the given scope as well.
       */
      @query("$filter")
      $filter?: string;
    }
  >;
}

@@projectedName(RoleDefinitions.createOrUpdate::parameters.resource,
  "json",
  "roleDefinition"
);
@@extension(RoleDefinitions.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "roleDefinition"
);
@@doc(RoleDefinitions.createOrUpdate::parameters.resource,
  "The values for the role definition."
);
