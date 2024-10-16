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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantAccess_Create")
  create is ArmResourceCreateOrReplaceSync<
    AccessInformationContract,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("TenantAccess_Update")
  update is ArmCustomPatchSync<
    AccessInformationContract,
    AccessInformationUpdateParameters,
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
    },
    Response = AccessInformationListResult
  >;

  /**
   * Regenerate primary access key
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantAccess_RegeneratePrimaryKey")
  regeneratePrimaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  /**
   * Regenerate secondary access key
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantAccess_RegenerateSecondaryKey")
  regenerateSecondaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  /**
   * Get tenant access information details.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantAccess_ListSecrets")
  listSecrets is ArmResourceActionSync<
    AccessInformationContract,
    void,
    AccessInformationSecretsContract
  >;

  /**
   * Regenerate primary access key for GIT.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantAccessGit_RegeneratePrimaryKey")
  tenantAccessGitRegeneratePrimaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  /**
   * Regenerate secondary access key for GIT.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantAccessGit_RegenerateSecondaryKey")
  tenantAccessGitRegenerateSecondaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  /**
   * This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantConfiguration_Deploy")
  deploy is ArmResourceActionAsync<
    AccessInformationContract,
    DeployConfigurationParameters,
    OperationResultContract,
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
    OperationResultContract,
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
    OperationResultContract,
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
  // FIXME: TenantConfiguration_GetSyncState could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantConfiguration_GetSyncState")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/syncState")
  @get
  getSyncState(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the API Management service.
     */
    @maxLength(50)
    @minLength(1)
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    @path
    serviceName: string,

    ...SubscriptionIdParameter,

    /**
     * The identifier of the Git Configuration Operation.
     */
    @path
    configurationName: ConfigurationIdName,
  ): ArmResponse<TenantConfigurationSyncStateContract> | ErrorResponse;
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
