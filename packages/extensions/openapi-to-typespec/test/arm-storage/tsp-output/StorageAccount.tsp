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
   * Gets the SKU.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @visibility(Lifecycle.Read)
  sku?: Sku;

  /**
   * Gets the Kind.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @visibility(Lifecycle.Read)
  kind?: Kind;

  /**
   * The identity of the resource.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  identity?: Identity;

  /**
   * The extendedLocation of the resource.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  extendedLocation?: ExtendedLocation;
}

@armResourceOperations
interface StorageAccounts {
  /**
   * Returns the properties for the specified storage account including but not limited to name, SKU name, location, and account status. The ListKeys operation should be used to retrieve storage keys.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_GetProperties")
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  @operationId("StorageAccounts_Create")
  create is ArmResourceCreateOrReplaceAsync<
    StorageAccount,
    Response = ArmResourceUpdatedResponse<StorageAccount> | ArmAcceptedLroResponse,
    LroHeaders = ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * The update operation can be used to update the SKU, encryption, access tier, or tags for a storage account. It can also be used to map the account to a custom domain. Only one custom domain is supported per storage account; the replacement/change of custom domain is not supported. In order to replace an old custom domain, the old value must be cleared/unregistered before a new value can be set. The update of multiple properties is supported. This call does not change the storage keys for the account. If you want to change the storage account keys, use the regenerate keys operation. The location and name of the storage account cannot be changed after creation.
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    StorageAccount,
    PatchModel = StorageAccountUpdateParameters
  >;

  /**
   * Deletes a storage account in Microsoft Azure.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_Delete")
  delete is ArmResourceDeleteSync<StorageAccount>;

  /**
   * Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<StorageAccount>;

  /**
   * Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_List")
  list is ArmListBySubscription<StorageAccount>;

  /**
   * Lists the access keys or Kerberos keys (if active directory enabled) for the specified storage account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_ListKeys")
  listKeys is ArmResourceActionSync<
    StorageAccount,
    void,
    ArmResponse<StorageAccountListKeysResult>,
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_RegenerateKey")
  regenerateKey is ArmResourceActionSync<
    StorageAccount,
    StorageAccountRegenerateKeyParameters,
    ArmResponse<StorageAccountListKeysResult>
  >;

  /**
   * List SAS credentials of a storage account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_ListAccountSAS")
  @action("ListAccountSas")
  listAccountSAS is ArmResourceActionSync<
    StorageAccount,
    AccountSasParameters,
    ArmResponse<ListAccountSasResponse>
  >;

  /**
   * List service SAS credentials of a specific resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_ListServiceSAS")
  @action("ListServiceSas")
  listServiceSAS is ArmResourceActionSync<
    StorageAccount,
    ServiceSasParameters,
    ArmResponse<ListServiceSasResponse>
  >;

  /**
   * A failover request can be triggered for a storage account in the event a primary endpoint becomes unavailable for any reason. The failover occurs from the storage account's primary cluster to the secondary cluster for RA-GRS accounts. The secondary cluster will become primary after failover and the account is converted to LRS. In the case of a Planned Failover, the primary and secondary clusters are swapped after failover and the account remains geo-replicated. Failover should continue to be used in the event of availability issues as Planned failover is only available while the primary and secondary endpoints are available. The primary use case of a Planned Failover is disaster recovery testing drills. This type of failover is invoked by setting FailoverType parameter to 'Planned'. Learn more about the failover options here- https://learn.microsoft.com/en-us/azure/storage/common/storage-disaster-recovery-guidance
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_Failover")
  failover is ArmResourceActionAsync<
    StorageAccount,
    void,
    OkResponse,
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_HierarchicalNamespaceMigration")
  @action("hnsonmigration")
  hierarchicalNamespaceMigration is ArmResourceActionAsync<
    StorageAccount,
    void,
    OkResponse,
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_AbortHierarchicalNamespaceMigration")
  @action("aborthnsonmigration")
  abortHierarchicalNamespaceMigration is ArmResourceActionAsync<
    StorageAccount,
    void,
    OkResponse
  >;

  /**
   * Restore blobs in the specified blob ranges
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_RestoreBlobRanges")
  restoreBlobRanges is ArmResourceActionAsync<
    StorageAccount,
    BlobRestoreParameters,
    ArmResponse<BlobRestoreStatus>
  >;

  /**
   * Revoke user delegation keys.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("StorageAccounts_RevokeUserDelegationKeys")
  revokeUserDelegationKeys is ArmResourceActionSync<
    StorageAccount,
    void,
    OkResponse
  >;

  /**
   * Gets the private link resources that need to be created for a storage account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("PrivateLinkResources_ListByStorageAccount")
  @get
  @action("privateLinkResources")
  listByStorageAccount is ArmResourceActionSync<
    StorageAccount,
    void,
    ArmResponse<PrivateLinkResourceListResult>
  >;
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
