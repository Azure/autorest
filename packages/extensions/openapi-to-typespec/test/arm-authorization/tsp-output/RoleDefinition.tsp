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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(RoleDefinitionProperties)
model RoleDefinition extends Foundations.ExtensionResource {
  ...ResourceNameParameter<
    Resource = RoleDefinition,
    KeyName = "roleDefinitionId",
    SegmentName = "roleDefinitions",
    NamePattern = ""
  >;

  /**
   * Role definition properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: RoleDefinitionProperties;
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
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<RoleDefinition>;

  /**
   * Get all role definitions that are applicable at scope and above.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RoleDefinitions_List")
  list is ArmResourceListByParent<
    RoleDefinition,
    {
      ...Azure.ResourceManager.Foundations.ExtensionBaseParameters;

      /**
       * The filter to apply on the operation. Use atScopeAndBelow filter to search below the given scope as well.
       */
      @query("$filter")
      $filter?: string;
    }
  >;
}

@@doc(RoleDefinition.name, "The ID of the role definition.");
@@encodedName(RoleDefinitions.createOrUpdate::parameters.resource,
  "application/json",
  "roleDefinition"
);
@@extension(RoleDefinitions.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "roleDefinition"
);
@@doc(RoleDefinitions.createOrUpdate::parameters.resource,
  "The values for the role definition."
);
