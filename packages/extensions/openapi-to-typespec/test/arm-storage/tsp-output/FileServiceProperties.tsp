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
  ...Azure.ResourceManager.ResourceSkuProperty;
}

@armResourceOperations
interface FileServicePropertiesOperationGroup {
  /**
   * Gets the properties of file services in storage accounts, including CORS (Cross-Origin Resource Sharing) rules.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("FileServices_GetServiceProperties")
  getServiceProperties is ArmResourceRead<FileServiceProperties>;

  /**
   * Sets the properties of file services in storage accounts, including CORS (Cross-Origin Resource Sharing) rules.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  @operationId("FileServices_SetServiceProperties")
  setServiceProperties is ArmResourceCreateOrReplaceSync<
    FileServiceProperties,
    Response = ArmResourceUpdatedResponse<FileServiceProperties>
  >;

  /**
   * List all file services in storage accounts
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("FileServices_List")
  list is ArmResourceListByParent<
    FileServiceProperties,
    Response = ArmResponse<FileServiceItems>
  >;
}

@@doc(FileServiceProperties.name, "");
@@doc(FileServiceProperties.properties,
  "The properties of File services in storage account."
);
@@doc(FileServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "The properties of file services in storage accounts, including CORS (Cross-Origin Resource Sharing) rules."
);
