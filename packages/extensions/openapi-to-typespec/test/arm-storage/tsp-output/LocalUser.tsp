import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./StorageAccount.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;
/**
 * The local user associated with the storage accounts.
 */
@parentResource(StorageAccount)
model LocalUser is Azure.ResourceManager.ProxyResource<LocalUserProperties> {
  ...ResourceNameParameter<
    Resource = LocalUser,
    KeyName = "username",
    SegmentName = "localUsers",
    NamePattern = ""
  >;
}

@armResourceOperations
interface LocalUserOperationGroup {
  /**
   * Get the local user of the storage account by username.
   */
  get is ArmResourceRead<LocalUser>;

  /**
   * Create or update the properties of a local user associated with the storage account
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    LocalUser,
    Response = ArmResourceUpdatedResponse<LocalUser>
  >;

  /**
   * Deletes the local user associated with the specified storage account.
   */
  delete is ArmResourceDeleteSync<LocalUser>;

  /**
   * List the local users associated with the storage account.
   */
  list is ArmResourceListByParent<
    LocalUser,
    Response = ArmResponse<LocalUsers>
  >;

  /**
   * List SSH authorized keys and shared key of the local user.
   */
  listKeys is ArmResourceActionSync<
    LocalUser,
    void,
    ArmResponse<LocalUserKeys>
  >;

  /**
   * Regenerate the local user SSH password.
   */
  regeneratePassword is ArmResourceActionSync<
    LocalUser,
    void,
    ArmResponse<LocalUserRegeneratePasswordResult>
  >;
}

@@maxLength(LocalUser.name, 64);
@@minLength(LocalUser.name, 3);
@@doc(LocalUser.name,
  "The name of local user. The username must contain lowercase letters and numbers only. It must be unique only within the storage account."
);
@@doc(LocalUser.properties, "Storage account local user properties.");
@@doc(LocalUserOperationGroup.createOrUpdate::parameters.resource,
  "The local user associated with a storage account."
);
