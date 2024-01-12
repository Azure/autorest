import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DataProduct.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.NetworkAnalytics;
@doc("The data type resource.")
@parentResource(DataProduct)
model DataType is ProxyResource<DataTypeProperties> {
  @doc("The data type name.")
  @maxLength(63)
  @minLength(3)
  @pattern("^[a-z][a-z0-9-]*$")
  @path
  @key("dataTypeName")
  @segment("dataTypes")
  name: string;
}

@armResourceOperations
interface DataTypes {
  @doc("Retrieve data type resource.")
  get is ArmResourceRead<DataType>;

  @doc("Create data type resource.")
  create is ArmResourceCreateOrReplaceAsync<
    DataType,
    BaseParameters<DataType>,
    ArmAsyncOperationHeader
  >;

  @doc("Update data type resource.")
  update is ArmCustomPatchAsync<
    DataType,
    DataTypeUpdate,
    BaseParameters<DataType>,
    ArmLroLocationHeader
  >;

  @doc("Delete data type resource.")
  delete is ArmResourceDeleteWithoutOkAsync<
    DataType,
    BaseParameters<DataType>,
    ArmLroLocationHeader
  >;

  @doc("List data type by parent resource.")
  listByDataProduct is ArmResourceListByParent<DataType>;

  @doc("Delete data for data type.")
  deleteData is ArmResourceActionNoResponseContentAsync<
    DataType,
    AnyObject,
    BaseParameters<DataType>,
    ArmLroLocationHeader
  >;

  @doc("Generate sas token for storage container.")
  generateStorageContainerSasToken is ArmResourceActionSync<
    DataType,
    ContainerSaS,
    ContainerSasToken
  >;
}
