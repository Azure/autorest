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
/**
 * The data type resource.
 */
@parentResource(DataProduct)
model DataType is ProxyResource<DataTypeProperties> {
  /**
   * The data type name.
   */
  @maxLength(63)
  @minLength(3)
  @pattern("^[a-z][a-z0-9-]*$")
  @path
  @key("dataTypeName")
  @segment("dataTypes")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface DataTypes {
  /**
   * Retrieve data type resource.
   */
  get is ArmResourceRead<DataType>;

  /**
   * Create data type resource.
   */
  create is ArmResourceCreateOrReplaceAsync<
    DataType,
    BaseParameters<DataType>,
    ArmAsyncOperationHeader
  >;

  /**
   * Update data type resource.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<
    DataType,
    DataTypeUpdate,
    BaseParameters<DataType>,
    ArmLroLocationHeader
  >;

  /**
   * Delete data type resource.
   */
  delete is ArmResourceDeleteWithoutOkAsync<
    DataType,
    BaseParameters<DataType>,
    ArmLroLocationHeader
  >;

  /**
   * List data type by parent resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DataTypes_ListByDataProduct")
  listByDataProduct is ArmResourceListByParent<DataType>;

  /**
   * Delete data for data type.
   */
  deleteData is ArmResourceActionNoResponseContentAsync<
    DataType,
    AnyObject,
    BaseParameters<DataType>,
    ArmLroLocationHeader
  >;

  /**
   * Generate sas token for storage container.
   */
  generateStorageContainerSasToken is ArmResourceActionSync<
    DataType,
    ContainerSaS,
    ContainerSasToken
  >;
}
