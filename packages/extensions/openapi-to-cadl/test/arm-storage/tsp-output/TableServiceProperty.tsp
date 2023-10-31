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
@doc("The properties of a storage account’s Table service.")
@parentResource(StorageAccount)
@singleton("default")
model TableServiceProperty is ProxyResource<TableServicePropertiesProperties> {
  @key("tableServiceName")
  @segment("tableServices")
  name: string;
}

@armResourceOperations
interface TableServiceProperties {
  @doc("Gets the properties of a storage account’s Table service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.")
  getServiceProperties is ArmResourceRead<
    TableServiceProperty,
    {
      ...BaseParameters<TableServiceProperty>;

      @doc("The name of the Table Service within the specified storage account. Table Service Name must be 'default'")
      @path
      tableServiceName: "default";
    }
  >;
  @doc("Sets the properties of a storage account’s Table service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. ")
  setServiceProperties is ArmResourceCreateOrReplaceSync<
    TableServiceProperty,
    {
      ...BaseParameters<TableServiceProperty>;

      @doc("The name of the Table Service within the specified storage account. Table Service Name must be 'default'")
      @path
      tableServiceName: "default";
    }
  >;
  @doc("List all table services for the storage account.")
  listByStorageAccount is ArmResourceListByParent<TableServiceProperty>;
}
