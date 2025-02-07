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
 * The properties of File services in storage account.
 */
@singleton("default")
@parentResource(StorageAccount)
model FileServiceProperties
  is Azure.ResourceManager.ProxyResource<FileServicePropertiesProperties> {
  ...ResourceNameParameter<
    Resource = FileServiceProperties,
    KeyName = "fileService",
    SegmentName = "fileServices",
    NamePattern = ""
  >;

  /**
   * Sku name and tier.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @visibility("read")
  sku?: Sku;
}

@armResourceOperations
interface FileServices {
  /**
   * Gets the properties of file services in storage accounts, including CORS (Cross-Origin Resource Sharing) rules.
   */
  getServiceProperties is ArmResourceRead<FileServiceProperties>;

  /**
   * Sets the properties of file services in storage accounts, including CORS (Cross-Origin Resource Sharing) rules.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  setServiceProperties is ArmResourceCreateOrReplaceSync<
    FileServiceProperties,
    Response = ArmResourceUpdatedResponse<FileServiceProperties>
  >;

  /**
   * List all file services in storage accounts
   */
  list is ArmResourceListByParent<
    FileServiceProperties,
    Response = ArmResponse<FileServiceItems>
  >;
}

@@doc(FileServiceProperties.name, "");
@@doc(FileServiceProperties.properties,
  "The properties of File services in storage account."
);
@@doc(FileServices.setServiceProperties::parameters.resource,
  "The properties of file services in storage accounts, including CORS (Cross-Origin Resource Sharing) rules."
);
