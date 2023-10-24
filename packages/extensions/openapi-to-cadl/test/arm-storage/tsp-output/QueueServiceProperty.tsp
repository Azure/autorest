import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./StorageAccount.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Storage;
@doc("The properties of a storage account’s Queue service.")
@parentResource(StorageAccount)
@singleton("queueServiceName")
model QueueServiceProperty is ProxyResource<QueueServicePropertiesProperties> {
  @key("queueServiceName")
  @segment("queueServices")
  name: string;
}

@armResourceOperations
interface QueueServiceProperties {
  @doc("""
Gets the properties of a storage account’s Queue service, including properties
for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
""")
  getServiceProperties is ArmResourceRead<QueueServiceProperty>;
  @doc("""
Sets the properties of a storage account’s Queue service, including properties
for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. 
""")
  setServiceProperties is ArmResourceCreateOrUpdateAsync<QueueServiceProperty>;
  @doc("List all queue services for the storage account")
  listByStorageAccount is ArmResourceListByParent<QueueServiceProperty>;
}
