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
 * The properties of a storage account’s Queue service.
 */
@singleton("default")
@parentResource(StorageAccount)
model QueueServiceProperties
  is ProxyResource<QueueServicePropertiesProperties> {
  @key("queueService")
  @segment("queueServices")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface QueueServicePropertiesOperationGroup {
  /**
   * Gets the properties of a storage account’s Queue service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
   */
  getServiceProperties is ArmResourceRead<QueueServiceProperties>;

  /**
   * Sets the properties of a storage account’s Queue service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
   */
  setServiceProperties is ArmResourceCreateOrReplaceSync<QueueServiceProperties>;

  /**
   * List all queue services for the storage account
   */
  list is ArmResourceListByParent<QueueServiceProperties>;
}

@@doc(QueueServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "The properties of a storage account’s Queue service, only properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules can be specified."
);
