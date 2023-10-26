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
@parentResource(StorageAccount)
@singleton("default")
model QueueServiceProperty is ProxyResource<QueueServicePropertiesProperties> {
  @key("queueServiceName")
  @segment("queueServices")
  name: string;
}

@armResourceOperations
interface QueueServices {
  @doc("""
Gets the properties of a storage account’s Queue service, including properties
for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
""")
  getServiceProperties is ArmResourceRead<
    QueueServiceProperty,
    {
      ...BaseParameters<QueueServiceProperty>;

      @doc("""
The name of the Queue Service within the specified storage account. Queue
Service Name must be 'default'
""")
      @path
      queueServiceName: "default";
    }
  >;
  @doc("""
Sets the properties of a storage account’s Queue service, including properties
for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. 
""")
  setServiceProperties is ArmResourceCreateOrUpdateAsync<
    QueueServiceProperty,
    {
      ...BaseParameters<QueueServiceProperty>;

      @doc("""
The name of the Queue Service within the specified storage account. Queue
Service Name must be 'default'
""")
      @path
      queueServiceName: "default";
    }
  >;
  @doc("List all queue services for the storage account")
  listByStorageAccount is ArmResourceListByParent<QueueServiceProperty>;
}
