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
@doc("The properties of a storage account’s Table service.")
@singleton("default")
@parentResource(StorageAccount)
model TableServiceProperties
  is ProxyResource<TableServicePropertiesProperties> {
  @key("tableService")
  @segment("tableServices")
  name: string;
}

@armResourceOperations
@projectedName("client", "TableServiceProperties")
interface TableServicePropertiesOperationGroup {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the properties of a storage account’s Table service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.")
  @operationId("TableServices_GetServiceProperties")
  getServiceProperties is ArmResourceRead<TableServiceProperties>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Sets the properties of a storage account’s Table service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. ")
  @operationId("TableServices_SetServiceProperties")
  setServiceProperties is ArmResourceCreateOrReplaceSync<TableServiceProperties>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List all table services for the storage account.")
  @operationId("TableServices_List")
  list is ArmResourceListByParent<TableServiceProperties>;
}
