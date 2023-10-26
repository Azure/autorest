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
@doc("The properties of a storage account’s Blob service.")
@parentResource(StorageAccount)
@singleton("BlobServicesName")
model BlobServiceProperty is ProxyResource<BlobServicePropertiesProperties> {
  @key("BlobServicesName")
  @segment("blobServices")
  name: string;
}

@armResourceOperations
interface BlobServices {
  @doc("""
Gets the properties of a storage account’s Blob service, including properties
for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
""")
  getServiceProperties is ArmResourceRead<
    BlobServiceProperty,
    {
      ...BaseParameters<BlobServiceProperty>;

      @doc("""
The name of the blob Service within the specified storage account. Blob Service
Name must be 'default'
""")
      @path
      BlobServicesName: "default";
    }
  >;
  @doc("""
Sets the properties of a storage account’s Blob service, including properties
for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. 
""")
  setServiceProperties is ArmResourceCreateOrUpdateAsync<
    BlobServiceProperty,
    {
      ...BaseParameters<BlobServiceProperty>;

      @doc("""
The name of the blob Service within the specified storage account. Blob Service
Name must be 'default'
""")
      @path
      BlobServicesName: "default";
    }
  >;
  @doc("""
List blob services of storage account. It returns a collection of one object
named default.
""")
  listByStorageAccount is ArmResourceListByParent<BlobServiceProperty>;
}
