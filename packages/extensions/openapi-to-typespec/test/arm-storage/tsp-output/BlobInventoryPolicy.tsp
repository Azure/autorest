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
@parentResource(StorageAccount)
model BlobInventoryPolicy
  is Azure.ResourceManager.ProxyResource<BlobInventoryPolicyProperties> {
  ...ResourceNameParameter<
    Resource = BlobInventoryPolicy,
    KeyName = "blobInventoryPolicyName",
    SegmentName = "inventoryPolicies",
    NamePattern = "",
    Type = BlobInventoryPolicyName
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
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    BlobInventoryPolicy,
    Response = ArmResourceUpdatedResponse<BlobInventoryPolicy>
  >;

  /**
   * Deletes the blob inventory policy associated with the specified storage account.
   */
  delete is ArmResourceDeleteSync<BlobInventoryPolicy>;

  /**
   * Gets the blob inventory policy associated with the specified storage account.
   */
  list is ArmResourceListByParent<
    BlobInventoryPolicy,
    Response = ArmResponse<ListBlobInventoryPolicy>
  >;
}

@@doc(BlobInventoryPolicy.name,
  "The name of the storage account blob inventory policy. It should always be 'default'"
);
@@doc(BlobInventoryPolicy.properties,
  "Returns the storage account blob inventory policy rules."
);
@@doc(BlobInventoryPolicies.createOrUpdate::parameters.resource,
  "The blob inventory policy set to a storage account."
);
