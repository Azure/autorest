import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./StorageAccount.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Storage;
@doc("The properties of a storage account’s Queue service.")
@singleton("default")
@parentResource(StorageAccount)
model QueueServiceProperties
  is ProxyResource<QueueServicePropertiesProperties> {
  @key("queueService")
  @segment("queueServices")
  name: string;
}

@armResourceOperations
@projectedName("client", "QueueServices")
interface QueueServiceProperties_QueueServices {
  @doc("Gets the properties of a storage account’s Queue service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.")
  getServiceProperties is ArmResourceRead<QueueServiceProperties>;

  @doc("Sets the properties of a storage account’s Queue service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. ")
  setServiceProperties is ArmResourceCreateOrReplaceSync<QueueServiceProperties>;

  @doc("List all queue services for the storage account")
  list is ArmResourceListByParent<QueueServiceProperties>;
}
