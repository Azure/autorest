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
 * The properties of a storage account’s Blob service.
 */
@singleton("default")
@parentResource(StorageAccount)
model BlobServiceProperties
  is Azure.ResourceManager.ProxyResource<BlobServicePropertiesProperties> {
  ...ResourceNameParameter<
    Resource = BlobServiceProperties,
    KeyName = "blobService",
    SegmentName = "blobServices",
    NamePattern = ""
  >;
  ...Azure.ResourceManager.ResourceSkuProperty;
}

@armResourceOperations
interface BlobServicePropertiesOperationGroup {
  /**
   * Gets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("BlobServices_GetServiceProperties")
  getServiceProperties is ArmResourceRead<BlobServiceProperties>;

  /**
   * Sets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("BlobServices_SetServiceProperties")
  setServiceProperties is ArmResourceCreateOrReplaceSync<BlobServiceProperties>;

  /**
   * List blob services of storage account. It returns a collection of one object named default.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("BlobServices_List")
  list is ArmResourceListByParent<BlobServiceProperties>;
}

@@doc(BlobServiceProperties.name, "");
@@doc(BlobServiceProperties.properties,
  "The properties of a storage account’s Blob service."
);
@@doc(BlobServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "The properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules."
);
