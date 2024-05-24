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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@singleton("default")
@parentResource(StorageAccount)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  BlobInventoryPolicyProperties
)
model BlobInventoryPolicy extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = BlobInventoryPolicy,
    KeyName = "inventoryPolicy",
    SegmentName = "inventoryPolicies",
    NamePattern = ""
  >;

  /**
   * Returns the storage account blob inventory policy rules.
   */
  @extension("x-ms-client-flatten", true)
  properties?: BlobInventoryPolicyProperties;
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
