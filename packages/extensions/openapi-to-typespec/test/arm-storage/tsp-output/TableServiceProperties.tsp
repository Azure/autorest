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
@singleton("default")
@parentResource(StorageAccount)
model TableServiceProperties
  is ProxyResource<TableServicePropertiesProperties> {
  @key("tableService")
  @segment("tableServices")
  name: string;
}

@armResourceOperations
@projectedName("client", "TableServices")
interface TableServiceProperties_TableServices {
  @doc("Gets the properties of a storage account’s Table service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.")
  getServiceProperties is ArmResourceRead<
    TableServiceProperties,
    {
      ...BaseParameters<TableServiceProperties>;

      @doc("The name of the Table Service within the specified storage account. Table Service Name must be 'default'")
      @path
      tableServiceName: "default";
    }
  >;

  @doc("Sets the properties of a storage account’s Table service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. ")
  setServiceProperties is ArmResourceCreateOrReplaceSync<
    TableServiceProperties,
    {
      ...BaseParameters<TableServiceProperties>;

      @doc("The name of the Table Service within the specified storage account. Table Service Name must be 'default'")
      @path
      tableServiceName: "default";
    }
  >;

  @doc("List all table services for the storage account.")
  list is ArmResourceListByParent<TableServiceProperties>;
}
