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
@doc("The properties of File services in storage account.")
@parentResource(StorageAccount)
@singleton("FileServicesName")
model FileServiceProperty is ProxyResource<FileServicePropertiesProperties> {
  @key("FileServicesName")
  @segment("fileServices")
  name: string;
}

@armResourceOperations
interface FileServiceProperties {
  @doc("""
Gets the properties of file services in storage accounts, including CORS
(Cross-Origin Resource Sharing) rules.
""")
  getServiceProperties is ArmResourceRead<FileServiceProperty>;
  @doc("""
Sets the properties of file services in storage accounts, including CORS
(Cross-Origin Resource Sharing) rules. 
""")
  setServiceProperties is ArmResourceCreateOrUpdateAsync<FileServiceProperty>;
  @doc("List all file services in storage accounts")
  listByStorageAccount is ArmResourceListByParent<FileServiceProperty>;
}
