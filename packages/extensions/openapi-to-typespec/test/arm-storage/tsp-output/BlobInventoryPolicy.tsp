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
 * The storage account blob inventory policy.
 */
@singleton("default")
@parentResource(StorageAccount)
model BlobInventoryPolicy
  is Azure.ResourceManager.ProxyResource<BlobInventoryPolicyProperties> {
  ...ResourceNameParameter<
    Resource = BlobInventoryPolicy,
    KeyName = "inventoryPolicy",
    SegmentName = "inventoryPolicies",
    NamePattern = ""
  >;
}

@armResourceOperations
interface BlobInventoryPolicies {
  /**
   * Gets the blob inventory policy associated with the specified storage account.
   */
  get is ArmResourceRead<BlobInventoryPolicy>;

  /**
   * Sets the blob inventory policy to the specified storage account.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<BlobInventoryPolicy>;

  /**
   * Deletes the blob inventory policy associated with the specified storage account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<BlobInventoryPolicy>;

  /**
   * Gets the blob inventory policy associated with the specified storage account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BlobInventoryPolicies_List")
  list is ArmResourceListByParent<BlobInventoryPolicy>;
}

@@doc(BlobInventoryPolicy.name, "");
@@doc(BlobInventoryPolicy.properties,
  "Returns the storage account blob inventory policy rules."
);
@@encodedName(BlobInventoryPolicies.createOrUpdate::parameters.resource,
  "application/json",
  "properties"
);
@@extension(BlobInventoryPolicies.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "properties"
);
@@doc(BlobInventoryPolicies.createOrUpdate::parameters.resource,
  "The blob inventory policy set to a storage account."
);
