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
 * The Get Storage Account ManagementPolicies operation response.
 */
@singleton("default")
@parentResource(StorageAccount)
model ManagementPolicy is ProxyResource<ManagementPolicyProperties> {
  @key("managementPolicy")
  @segment("managementPolicies")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface ManagementPolicies {
  /**
   * Gets the managementpolicy associated with the specified storage account.
   */
  get is ArmResourceRead<ManagementPolicy>;

  /**
   * Sets the managementpolicy to the specified storage account.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<ManagementPolicy>;

  /**
   * Deletes the managementpolicy associated with the specified storage account.
   */
  delete is ArmResourceDeleteSync<ManagementPolicy>;
}

@@doc(ManagementPolicies.createOrUpdate::parameters.resource,
  "The ManagementPolicy set to a storage account."
);
