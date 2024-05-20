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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@singleton("default")
@parentResource(StorageAccount)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  BlobServicePropertiesProperties
)
model BlobServiceProperties extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = BlobServiceProperties,
    KeyName = "blobService",
    SegmentName = "blobServices",
    NamePattern = ""
  >;

  /**
   * The properties of a storage account’s Blob service.
   */
  @extension("x-ms-client-flatten", true)
  properties?: BlobServicePropertiesProperties;

  ...Azure.ResourceManager.ResourceSkuProperty;
}

@armResourceOperations
interface BlobServicePropertiesOperationGroup {
  /**
   * Gets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BlobServices_GetServiceProperties")
  getServiceProperties is ArmResourceRead<BlobServiceProperties>;

  /**
   * Sets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BlobServices_SetServiceProperties")
  setServiceProperties is ArmResourceCreateOrReplaceSync<BlobServiceProperties>;

  /**
   * List blob services of storage account. It returns a collection of one object named default.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BlobServices_List")
  list is ArmResourceListByParent<BlobServiceProperties>;
}

@@doc(BlobServiceProperties.name, "");
@@encodedName(BlobServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(BlobServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(BlobServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "The properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules."
);
