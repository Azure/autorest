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
/** The properties of a storage account’s Blob service. */
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

  /** Sku name and tier. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @visibility(Lifecycle.Read)
  sku?: Sku;
}

@armResourceOperations
interface BlobServices {
  /** Gets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. */
  getServiceProperties is ArmResourceRead<BlobServiceProperties>;

  /** Sets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  setServiceProperties is ArmResourceCreateOrReplaceSync<
    BlobServiceProperties,
    Response = ArmResourceUpdatedResponse<BlobServiceProperties>
  >;

  /** List blob services of storage account. It returns a collection of one object named default. */
  list is ArmResourceListByParent<
    BlobServiceProperties,
    Response = ArmResponse<BlobServiceItems>
  >;
}

@@doc(BlobServiceProperties.name, "");
@@doc(BlobServiceProperties.properties,
  "The properties of a storage account’s Blob service."
);
@@doc(BlobServices.setServiceProperties::parameters.resource,
  "The properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules."
);
