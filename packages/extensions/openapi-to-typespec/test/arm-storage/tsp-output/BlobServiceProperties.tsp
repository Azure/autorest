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
@doc("The properties of a storage account’s Blob service.")
@singleton("default")
@parentResource(StorageAccount)
model BlobServiceProperties is ProxyResource<BlobServicePropertiesProperties> {
  @key("blobService")
  @segment("blobServices")
  name: string;

  ...Azure.ResourceManager.ResourceSku;
}

@armResourceOperations
@projectedName("client", "BlobServiceProperties")
interface BlobServicePropertiesOperationGroup {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.")
  @operationId("BlobServices_GetServiceProperties")
  getServiceProperties is ArmResourceRead<BlobServiceProperties>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Sets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. ")
  @operationId("BlobServices_SetServiceProperties")
  setServiceProperties is ArmResourceCreateOrReplaceSync<BlobServiceProperties>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List blob services of storage account. It returns a collection of one object named default.")
  @operationId("BlobServices_List")
  list is ArmResourceListByParent<BlobServiceProperties>;
}
