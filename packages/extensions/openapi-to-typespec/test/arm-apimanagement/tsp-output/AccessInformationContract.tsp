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
@parentResource(ApiManagementServiceResource)
model AccessInformationContract
  is Azure.ResourceManager.ProxyResource<AccessInformationContractProperties> {
  ...ResourceNameParameter<
    Resource = AccessInformationContract,
    KeyName = "accessName",
    SegmentName = "tenant",
    NamePattern = "",
    Type = AccessIdName
  >;
}

@armResourceOperations
interface AccessInformationContracts {
  /**
   * Get tenant access information details without secrets.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantAccess_Get")
  get is ArmResourceRead<AccessInformationContract>;

  /**
   * Tenant access metadata
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantAccess_GetEntityTag")
  getEntityTag is ArmResourceCheckExistence<AccessInformationContract>;

  /**
   * Update tenant access information details.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  @operationId("TenantAccess_Create")
  create is ArmResourceCreateOrReplaceSync<
    AccessInformationContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    },
    Response = ArmResourceUpdatedResponse<AccessInformationContract>
  >;

  /**
   * Update tenant access information details.
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    AccessInformationContract,
    PatchModel = AccessInformationUpdateParameters,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantAccess_ListByService")
  listByService is ArmResourceListByParent<
    AccessInformationContract,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantAccess_RegeneratePrimaryKey")
  regeneratePrimaryKey is ArmResourceActionSync<
    AccessInformationContract,
    void,
    NoContentResponse
  >;

  /**
   * Regenerate secondary access key
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantAccess_RegenerateSecondaryKey")
  regenerateSecondaryKey is ArmResourceActionSync<
    AccessInformationContract,
    void,
    NoContentResponse
  >;

  /**
   * Get tenant access information details.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantAccess_ListSecrets")
  listSecrets is ArmResourceActionSync<
    AccessInformationContract,
    void,
    ArmResponse<AccessInformationSecretsContract>
  >;

  /**
   * Regenerate primary access key for GIT.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantAccessGit_RegeneratePrimaryKey")
  @action("regeneratePrimaryKey")
  tenantAccessGitRegeneratePrimaryKey is ArmResourceActionSync<
    AccessInformationContract,
    void,
    NoContentResponse
  >;

  /**
   * Regenerate secondary access key for GIT.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantAccessGit_RegenerateSecondaryKey")
  @action("regenerateSecondaryKey")
  tenantAccessGitRegenerateSecondaryKey is ArmResourceActionSync<
    AccessInformationContract,
    void,
    NoContentResponse
  >;

  /**
   * This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantConfiguration_Deploy")
  deploy is ArmResourceActionAsync<
    AccessInformationContract,
    DeployConfigurationParameters,
    ArmResponse<OperationResultContract>,
    Parameters = {
      /**
       * The identifier of the Git Configuration Operation.
       */
      @path
      configurationName: ConfigurationIdName;
    }
  >;

  /**
   * This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantConfiguration_Save")
  save is ArmResourceActionAsync<
    AccessInformationContract,
    SaveConfigurationParameter,
    ArmResponse<OperationResultContract>,
    Parameters = {
      /**
       * The identifier of the Git Configuration Operation.
       */
      @path
      configurationName: ConfigurationIdName;
    }
  >;

  /**
   * This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantConfiguration_Validate")
  validate is ArmResourceActionAsync<
    AccessInformationContract,
    DeployConfigurationParameters,
    ArmResponse<OperationResultContract>,
    Parameters = {
      /**
       * The identifier of the Git Configuration Operation.
       */
      @path
      configurationName: ConfigurationIdName;
    }
  >;

  /**
   * Gets the status of the most recent synchronization between the configuration database and the Git repository.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantConfiguration_GetSyncState")
  @get
  @action("syncState")
  getSyncState is ArmResourceActionSync<
    AccessInformationContract,
    void,
    ArmResponse<TenantConfigurationSyncStateContract>,
    Parameters = {
      /**
       * The identifier of the Git Configuration Operation.
       */
      @path
      configurationName: ConfigurationIdName;
    }
  >;
}

@@doc(AccessInformationContract.name,
  "The identifier of the Access configuration."
);
@@doc(AccessInformationContract.properties,
  "AccessInformation entity contract properties."
);
@@doc(AccessInformationContracts.create::parameters.resource,
  "Parameters supplied to retrieve the Tenant Access Information."
);
@@doc(AccessInformationContracts.update::parameters.properties,
  "Parameters supplied to retrieve the Tenant Access Information."
);
@@doc(AccessInformationContracts.deploy::parameters.body,
  "Deploy Configuration parameters."
);
@@doc(AccessInformationContracts.save::parameters.body,
  "Save Configuration parameters."
);
@@doc(AccessInformationContracts.validate::parameters.body,
  "Validate Configuration parameters."
);
