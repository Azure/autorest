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
  tenantAccessGitRegeneratePrimaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  /**
   * Regenerate secondary access key for GIT.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TenantAccessGit_RegenerateSecondaryKey")
  tenantAccessGitRegenerateSecondaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  /**
   * This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TenantConfiguration_Deploy")
  deploy is ArmResourceActionAsync<
    AccessInformationContract,
    DeployConfigurationParameters,
    OperationResultContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<AccessInformationContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TenantConfiguration_Save")
  save is ArmResourceActionAsync<
    AccessInformationContract,
    SaveConfigurationParameter,
    OperationResultContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<AccessInformationContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TenantConfiguration_Validate")
  validate is ArmResourceActionAsync<
    AccessInformationContract,
    DeployConfigurationParameters,
    OperationResultContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<AccessInformationContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
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
@@encodedName(AccessInformationContracts.deploy::parameters.body,
  "application/json",
  "parameters"
);
@@extension(AccessInformationContracts.deploy::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(AccessInformationContracts.deploy::parameters.body,
  "Deploy Configuration parameters."
);
@@encodedName(AccessInformationContracts.save::parameters.body,
  "application/json",
  "parameters"
);
@@extension(AccessInformationContracts.save::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(AccessInformationContracts.save::parameters.body,
  "Save Configuration parameters."
);
@@encodedName(AccessInformationContracts.validate::parameters.body,
  "application/json",
  "parameters"
);
@@extension(AccessInformationContracts.validate::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(AccessInformationContracts.validate::parameters.body,
  "Validate Configuration parameters."
);
