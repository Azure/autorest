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
@doc("The properties of a storage account’s Blob service.")
@parentResource(StorageAccount)
@singleton("BlobServicesName")
model BlobServiceProperty is ProxyResource<BlobServicePropertiesProperties> {
  @key("BlobServicesName")
  @segment("blobServices")
  name: string;
}

@armResourceOperations
interface BlobServiceProperties {
  @doc("""
Gets the properties of a storage account’s Blob service, including properties
for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
""")
  getServiceProperties is ArmResourceRead<BlobServiceProperty>;
  @doc("""
Sets the properties of a storage account’s Blob service, including properties
for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. 
""")
  setServiceProperties is ArmResourceCreateOrUpdateAsync<BlobServiceProperty>;
  @doc("""
List blob services of storage account. It returns a collection of one object
named default.
""")
  listByStorageAccount is ArmResourceListByParent<BlobServiceProperty>;
}
