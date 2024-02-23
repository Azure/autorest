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
 * The properties of a storage account’s Table service.
 */
@singleton("default")
@parentResource(StorageAccount)
model TableServiceProperties
  is ProxyResource<TableServicePropertiesProperties> {
  @key("tableService")
  @segment("tableServices")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface TableServicePropertiesOperationGroup {
  /**
   * Gets the properties of a storage account’s Table service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
   */
  getServiceProperties is ArmResourceRead<TableServiceProperties>;

  /**
   * Sets the properties of a storage account’s Table service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
   */
  setServiceProperties is ArmResourceCreateOrReplaceSync<TableServiceProperties>;

  /**
   * List all table services for the storage account.
   */
  list is ArmResourceListByParent<TableServiceProperties>;
}

@@doc(TableServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "The properties of a storage account’s Table service, only properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules can be specified."
);
