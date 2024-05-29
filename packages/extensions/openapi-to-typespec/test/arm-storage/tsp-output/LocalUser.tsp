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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(StorageAccount)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(LocalUserProperties)
model LocalUser extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = LocalUser,
    KeyName = "username",
    SegmentName = "localUsers",
    NamePattern = ""
  >;

  /**
   * Storage account local user properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: LocalUserProperties;
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
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<LocalUser>;

  /**
   * List the local users associated with the storage account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("LocalUsers_List")
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

@@maxLength(LocalUser.name, 64);
@@minLength(LocalUser.name, 3);
@@doc(LocalUser.name,
  "The name of local user. The username must contain lowercase letters and numbers only. It must be unique only within the storage account."
);
@@encodedName(LocalUsers.createOrUpdate::parameters.resource,
  "application/json",
  "properties"
);
@@extension(LocalUsers.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "properties"
);
@@doc(LocalUsers.createOrUpdate::parameters.resource,
  "The local user associated with a storage account."
);
