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
 * The Encryption Scope resource.
 */
@parentResource(StorageAccount)
model EncryptionScope is ProxyResource<EncryptionScopeProperties> {
  /**
   * The name of the encryption scope within the specified storage account. Encryption scope names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
   */
  @maxLength(63)
  @minLength(3)
  @path
  @key("encryptionScopeName")
  @segment("encryptionScopes")
  name: string;
}

@armResourceOperations
interface EncryptionScopes {
  /**
   * Returns the properties for the specified encryption scope.
   */
  get is ArmResourceRead<EncryptionScope>;

  /**
   * Synchronously creates or updates an encryption scope under the specified storage account. If an encryption scope is already created and a subsequent request is issued with different properties, the encryption scope properties will be updated per the specified request.
   */
  put is ArmResourceCreateOrReplaceSync<EncryptionScope>;

  /**
   * Update encryption scope properties as specified in the request body. Update fails if the specified encryption scope does not already exist.
   */
  @parameterVisibility("read")
  patch is ArmCustomPatchSync<EncryptionScope, EncryptionScope>;

  /**
   * Lists all the encryption scopes available under the specified storage account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("EncryptionScopes_List")
  list is ArmResourceListByParent<
    EncryptionScope,
    {
      ...BaseParameters<EncryptionScope>;

      /**
       * Optional, specifies the maximum number of encryption scopes that will be included in the list response.
       */
      @maxValue(5000)
      @minValue(1)
      @query("$maxpagesize")
      $maxpagesize?: int32;

      /**
       * Optional. When specified, only encryption scope names starting with the filter will be listed.
       */
      @query("$filter")
      $filter?: string;

      /**
       * Optional, when specified, will list encryption scopes with the specific state. Defaults to All
       */
      @query("$include")
      $include?: ListEncryptionScopesInclude;
    }
  >;
}

@@projectedName(EncryptionScopes.put::parameters.resource,
  "json",
  "encryptionScope"
);
@@extension(EncryptionScopes.put::parameters.resource,
  "x-ms-client-name",
  "encryptionScope"
);
@@doc(EncryptionScopes.put::parameters.resource,
  "Encryption scope properties to be used for the create or update."
);
@@projectedName(EncryptionScopes.patch::parameters.properties,
  "json",
  "encryptionScope"
);
@@extension(EncryptionScopes.patch::parameters.properties,
  "x-ms-client-name",
  "encryptionScope"
);
@@doc(EncryptionScopes.patch::parameters.properties,
  "Encryption scope properties to be used for the update."
);
