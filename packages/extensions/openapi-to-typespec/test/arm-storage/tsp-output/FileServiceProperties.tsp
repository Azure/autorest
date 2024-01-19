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
 * The properties of File services in storage account.
 */
@singleton("default")
@parentResource(StorageAccount)
model FileServiceProperties is ProxyResource<FileServicePropertiesProperties> {
  @key("fileService")
  @segment("fileServices")
  name: string;

  ...Azure.ResourceManager.ResourceSku;
}

@armResourceOperations
@projectedName("client", "FileServiceProperties")
interface FileServicePropertiesOperationGroup {
  /**
   * Gets the properties of file services in storage accounts, including CORS (Cross-Origin Resource Sharing) rules.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FileServices_GetServiceProperties")
  getServiceProperties is ArmResourceRead<FileServiceProperties>;

  /**
   * Sets the properties of file services in storage accounts, including CORS (Cross-Origin Resource Sharing) rules.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FileServices_SetServiceProperties")
  setServiceProperties is ArmResourceCreateOrReplaceSync<FileServiceProperties>;

  /**
   * List all file services in storage accounts
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FileServices_List")
  list is ArmResourceListByParent<FileServiceProperties>;
}

@@projectedName(FileServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "json",
  "parameters"
);
@@extension(FileServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(FileServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "The properties of file services in storage accounts, including CORS (Cross-Origin Resource Sharing) rules."
);
