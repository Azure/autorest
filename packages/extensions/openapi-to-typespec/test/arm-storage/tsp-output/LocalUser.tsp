import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./StorageAccount.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;
/**
 * The local user associated with the storage accounts.
 */
@parentResource(StorageAccount)
model LocalUser is ProxyResource<LocalUserProperties> {
  /**
   * The name of local user. The username must contain lowercase letters and numbers only. It must be unique only within the storage account.
   */
  @maxLength(64)
  @minLength(3)
  @path
  @key("username")
  @segment("localUsers")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface LocalUsers {
  /**
   * Get the local user of the storage account by username.
   */
  get is ArmResourceRead<LocalUser>;

  /**
   * Create or update the properties of a local user associated with the storage account
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<LocalUser>;

  /**
   * Deletes the local user associated with the specified storage account.
   */
  delete is ArmResourceDeleteSync<LocalUser>;

  /**
   * List the local users associated with the storage account.
   */
  list is ArmResourceListByParent<LocalUser>;

  /**
   * List SSH authorized keys and shared key of the local user.
   */
  listKeys is ArmResourceActionSync<LocalUser, void, LocalUserKeys>;

  /**
   * Regenerate the local user SSH password.
   */
  regeneratePassword is ArmResourceActionSync<
    LocalUser,
    void,
    LocalUserRegeneratePasswordResult
  >;
}

@@doc(LocalUsers.createOrUpdate::parameters.resource,
  "The local user associated with a storage account."
);
