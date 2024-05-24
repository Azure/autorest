import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DataProduct.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.NetworkAnalytics;
/**
 * The data type resource.
 */
@parentResource(DataProduct)
model DataType is Azure.ResourceManager.ProxyResource<DataTypeProperties> {
  ...ResourceNameParameter<
    Resource = DataType,
    KeyName = "dataTypeName",
    SegmentName = "dataTypes",
    NamePattern = "^[a-z][a-z0-9-]*$"
  >;
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
  create is ArmResourceCreateOrReplaceAsync<DataType>;

  /**
   * Update data type resource.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<DataType, DataTypeUpdate>;

  /**
   * Delete data type resource.
   */
  delete is ArmResourceDeleteWithoutOkAsync<DataType>;

  /**
   * List data type by parent resource.
   */
  listByDataProduct is ArmResourceListByParent<DataType>;

  /**
   * Delete data for data type.
   */
  deleteData is ArmResourceActionNoResponseContentAsync<
    DataType,
    Record<unknown>
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

@@maxLength(DataType.name, 63);
@@minLength(DataType.name, 3);
@@doc(DataType.name, "The data type name.");
