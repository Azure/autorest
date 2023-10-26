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
@doc("The properties of File services in storage account.")
@parentResource(StorageAccount)
@singleton("default")
model FileServiceProperty is ProxyResource<FileServicePropertiesProperties> {
  @key("FileServicesName")
  @segment("fileServices")
  name: string;
}

@armResourceOperations
interface FileServices {
  @doc("""
Gets the properties of file services in storage accounts, including CORS
(Cross-Origin Resource Sharing) rules.
""")
  getServiceProperties is ArmResourceRead<
    FileServiceProperty,
    {
      ...BaseParameters<FileServiceProperty>;

      @doc("""
The name of the file Service within the specified storage account. File Service
Name must be \"default\"
""")
      @path
      FileServicesName: "default";
    }
  >;
  @doc("""
Sets the properties of file services in storage accounts, including CORS
(Cross-Origin Resource Sharing) rules. 
""")
  setServiceProperties is ArmResourceCreateOrUpdateAsync<
    FileServiceProperty,
    {
      ...BaseParameters<FileServiceProperty>;

      @doc("""
The name of the file Service within the specified storage account. File Service
Name must be \"default\"
""")
      @path
      FileServicesName: "default";
    }
  >;
  @doc("List all file services in storage accounts")
  listByStorageAccount is ArmResourceListByParent<FileServiceProperty>;
}
