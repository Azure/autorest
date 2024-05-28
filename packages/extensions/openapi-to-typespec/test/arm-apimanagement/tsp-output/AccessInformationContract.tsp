import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Tenant Settings.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  AccessInformationContractProperties
)
model AccessInformationContract extends Foundations.ProxyResource {
  /**
   * The identifier of the Access configuration.
   */
  @path
  @key("accessName")
  @segment("tenant")
  @visibility("read")
  name: AccessIdName;

  /**
   * AccessInformation entity contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: AccessInformationContractProperties;
}

@armResourceOperations
interface AccessInformationContracts {
  /**
   * Get tenant access information details without secrets.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TenantAccess_Get")
  get is ArmResourceRead<AccessInformationContract>;

  /**
   * Tenant access metadata
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("TenantAccess_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      AccessInformationContract,
      BaseParameters<AccessInformationContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Update tenant access information details.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TenantAccess_Create")
  create is ArmResourceCreateOrReplaceSync<
    AccessInformationContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<AccessInformationContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Update tenant access information details.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("TenantAccess_Update")
  update is ArmCustomPatchSync<
    AccessInformationContract,
    AccessInformationUpdateParameters,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<AccessInformationContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Returns list of access infos - for Git and Management endpoints.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TenantAccess_ListByService")
  listByService is ArmResourceListByParent<
    AccessInformationContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<AccessInformationContract>;

      /**
       * Not used
       */
      @query("$filter")
      $filter?: string;
    }
  >;

  /**
   * Regenerate primary access key
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TenantAccess_RegeneratePrimaryKey")
  regeneratePrimaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  /**
   * Regenerate secondary access key
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TenantAccess_RegenerateSecondaryKey")
  regenerateSecondaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  /**
   * Get tenant access information details.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TenantAccess_ListSecrets")
  listSecrets is ArmResourceActionSync<
    AccessInformationContract,
    void,
    AccessInformationSecretsContract
  >;

  /**
   * Regenerate primary access key for GIT.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TenantAccessGit_RegeneratePrimaryKey")
  regeneratePrimaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  /**
   * Regenerate secondary access key for GIT.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TenantAccessGit_RegenerateSecondaryKey")
  regenerateSecondaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;
}

@@encodedName(AccessInformationContracts.create::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(AccessInformationContracts.create::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(AccessInformationContracts.create::parameters.resource,
  "Parameters supplied to retrieve the Tenant Access Information."
);
@@encodedName(AccessInformationContracts.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(AccessInformationContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(AccessInformationContracts.update::parameters.properties,
  "Parameters supplied to retrieve the Tenant Access Information."
);
