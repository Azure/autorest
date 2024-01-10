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
@projectedName("client", "QueueServiceProperties")
interface QueueServicePropertiesOperationGroup {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the properties of a storage account’s Queue service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.")
  @operationId("QueueServices_GetServiceProperties")
  getServiceProperties is ArmResourceRead<QueueServiceProperties>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Sets the properties of a storage account’s Queue service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. ")
  @operationId("QueueServices_SetServiceProperties")
  setServiceProperties is ArmResourceCreateOrReplaceSync<QueueServiceProperties>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List all queue services for the storage account")
  @operationId("QueueServices_List")
  list is ArmResourceListByParent<QueueServiceProperties>;
}
