import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;
/**
 * The storage account.
 */
model StorageAccount
  is Azure.ResourceManager.TrackedResource<StorageAccountProperties> {
  ...ResourceNameParameter<
    Resource = StorageAccount,
    KeyName = "accountName",
    SegmentName = "storageAccounts",
    NamePattern = ""
  >;

  /**
   * Gets the Kind.
   */
  @visibility("read")
  kind?: Kind;

  /**
   * The extendedLocation of the resource.
   */
  extendedLocation?: ExtendedLocation;

  ...Azure.ResourceManager.ManagedServiceIdentityProperty;
  ...Azure.ResourceManager.ResourceSkuProperty;
}

@armResourceOperations
interface StorageAccounts {
  /**
   * Returns the properties for the specified storage account including but not limited to name, SKU name, location, and account status. The ListKeys operation should be used to retrieve storage keys.
   */
  getProperties is ArmResourceRead<
    StorageAccount,
    Parameters = {
      /**
       * May be used to expand the properties within account's properties. By default, data is not included when fetching properties. Currently we only support geoReplicationStats and blobRestoreStatus.
       */
      @query("$expand")
      $expand?: StorageAccountExpand;
    }
  >;

  /**
   * Asynchronously creates a new storage account with the specified parameters. If an account is already created and a subsequent create request is issued with different properties, the account properties will be updated. If an account is already created and a subsequent create or update request is issued with the exact same set of properties, the request will succeed.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "For backward compatibility"
  create is ArmResourceCreateOrReplaceAsync<
    StorageAccount,
    Response = ArmResourceCreatedResponse<StorageAccount> | ArmResourceUpdatedResponse<StorageAccount> | ArmAcceptedLroResponse
  >;

  /**
   * The update operation can be used to update the SKU, encryption, access tier, or tags for a storage account. It can also be used to map the account to a custom domain. Only one custom domain is supported per storage account; the replacement/change of custom domain is not supported. In order to replace an old custom domain, the old value must be cleared/unregistered before a new value can be set. The update of multiple properties is supported. This call does not change the storage keys for the account. If you want to change the storage account keys, use the regenerate keys operation. The location and name of the storage account cannot be changed after creation.
   */
  @parameterVisibility
  update is ArmCustomPatchSync<StorageAccount, StorageAccountUpdateParameters>;

  /**
   * Deletes a storage account in Microsoft Azure.
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<StorageAccount>;

  /**
   * Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
   */
  listByResourceGroup is ArmResourceListByParent<
    StorageAccount,
    Response = StorageAccountListResult
  >;

  /**
   * Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
   */
  list is ArmListBySubscription<
    StorageAccount,
    Response = StorageAccountListResult
  >;

  /**
   * Lists the access keys or Kerberos keys (if active directory enabled) for the specified storage account.
   */
  listKeys is ArmResourceActionSync<
    StorageAccount,
    void,
    StorageAccountListKeysResult,
    Parameters = {
      /**
       * Specifies type of the key to be listed. Possible value is kerb.
       */
      @query("$expand")
      $expand?: "kerb";
    }
  >;

  /**
   * Regenerates one of the access keys or Kerberos keys for the specified storage account.
   */
  regenerateKey is ArmResourceActionSync<
    StorageAccount,
    StorageAccountRegenerateKeyParameters,
    StorageAccountListKeysResult
  >;

  /**
   * List SAS credentials of a storage account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_ListAccountSAS")
  listAccountSAS is ArmResourceActionSync<
    StorageAccount,
    AccountSasParameters,
    ListAccountSasResponse
  >;

  /**
   * List service SAS credentials of a specific resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_ListServiceSAS")
  listServiceSAS is ArmResourceActionSync<
    StorageAccount,
    ServiceSasParameters,
    ListServiceSasResponse
  >;

  /**
   * A failover request can be triggered for a storage account in the event a primary endpoint becomes unavailable for any reason. The failover occurs from the storage account's primary cluster to the secondary cluster for RA-GRS accounts. The secondary cluster will become primary after failover and the account is converted to LRS. In the case of a Planned Failover, the primary and secondary clusters are swapped after failover and the account remains geo-replicated. Failover should continue to be used in the event of availability issues as Planned failover is only available while the primary and secondary endpoints are available. The primary use case of a Planned Failover is disaster recovery testing drills. This type of failover is invoked by setting FailoverType parameter to 'Planned'. Learn more about the failover options here- https://learn.microsoft.com/en-us/azure/storage/common/storage-disaster-recovery-guidance
   */
  failover is ArmResourceActionAsync<
    StorageAccount,
    void,
    void,
    Parameters = {
      /**
       * The parameter is set to 'Planned' to indicate whether a Planned failover is requested.
       */
      @query("failoverType")
      failoverType?: "Planned";
    }
  >;

  /**
   * Live Migration of storage account to enable Hns
   */
  hierarchicalNamespaceMigration is ArmResourceActionAsync<
    StorageAccount,
    void,
    void,
    Parameters = {
      /**
       * Required. Hierarchical namespace migration type can either be a hierarchical namespace validation request 'HnsOnValidationRequest' or a hydration request 'HnsOnHydrationRequest'. The validation request will validate the migration whereas the hydration request will migrate the account.
       */
      @query("requestType")
      requestType: string;
    }
  >;

  /**
   * Abort live Migration of storage account to enable Hns
   */
  abortHierarchicalNamespaceMigration is ArmResourceActionAsync<
    StorageAccount,
    void,
    void
  >;

  /**
   * Restore blobs in the specified blob ranges
   */
  restoreBlobRanges is ArmResourceActionAsync<
    StorageAccount,
    BlobRestoreParameters,
    BlobRestoreStatus
  >;

  /**
   * Revoke user delegation keys.
   */
  revokeUserDelegationKeys is ArmResourceActionSync<StorageAccount, void, void>;

  /**
   * Gets the private link resources that need to be created for a storage account.
   */
  // FIXME: PrivateLinkResources_ListByStorageAccount could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("PrivateLinkResources_ListByStorageAccount")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/privateLinkResources")
  @get
  listByStorageAccount(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
     */
    @maxLength(24)
    @minLength(3)
    @path
    accountName: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<PrivateLinkResourceListResult> | ErrorResponse;
}

@@maxLength(StorageAccount.name, 24);
@@minLength(StorageAccount.name, 3);
@@doc(StorageAccount.name,
  "The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only."
);
@@doc(StorageAccount.properties, "Properties of the storage account.");
@@doc(StorageAccounts.create::parameters.resource,
  "The parameters to provide for the created account."
);
@@doc(StorageAccounts.update::parameters.properties,
  "The parameters to provide for the updated account."
);
@@doc(StorageAccounts.regenerateKey::parameters.body,
  "Specifies name of the key which should be regenerated -- key1, key2, kerb1, kerb2."
);
@@doc(StorageAccounts.listAccountSAS::parameters.body,
  "The parameters to provide to list SAS credentials for the storage account."
);
@@doc(StorageAccounts.listServiceSAS::parameters.body,
  "The parameters to provide to list service SAS credentials."
);
@@doc(StorageAccounts.restoreBlobRanges::parameters.body,
  "The parameters to provide for restore blob ranges."
);
