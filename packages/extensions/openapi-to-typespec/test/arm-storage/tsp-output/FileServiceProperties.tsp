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
  @visibility("read")
  name: string;

  ...Azure.ResourceManager.ResourceSku;
}

@armResourceOperations
interface FileServicePropertiesOperationGroup {
  /**
   * Gets the properties of file services in storage accounts, including CORS (Cross-Origin Resource Sharing) rules.
   */
  getServiceProperties is ArmResourceRead<FileServiceProperties>;

  /**
   * Sets the properties of file services in storage accounts, including CORS (Cross-Origin Resource Sharing) rules.
   */
  setServiceProperties is ArmResourceCreateOrReplaceSync<FileServiceProperties>;

  /**
   * List all file services in storage accounts
   */
  list is ArmResourceListByParent<FileServiceProperties>;
}

@@doc(FileServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "The properties of file services in storage accounts, including CORS (Cross-Origin Resource Sharing) rules."
);
