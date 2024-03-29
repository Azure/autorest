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
 * The properties of a storage account’s Blob service.
 */
@singleton("default")
@parentResource(StorageAccount)
model BlobServiceProperties is ProxyResource<BlobServicePropertiesProperties> {
  @key("blobService")
  @segment("blobServices")
  @visibility("read")
  name: string;

  ...Azure.ResourceManager.ResourceSku;
}

@armResourceOperations
interface BlobServicePropertiesOperationGroup {
  /**
   * Gets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
   */
  getServiceProperties is ArmResourceRead<BlobServiceProperties>;

  /**
   * Sets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
   */
  setServiceProperties is ArmResourceCreateOrReplaceSync<BlobServiceProperties>;

  /**
   * List blob services of storage account. It returns a collection of one object named default.
   */
  list is ArmResourceListByParent<BlobServiceProperties>;
}

@@doc(BlobServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "The properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules."
);
