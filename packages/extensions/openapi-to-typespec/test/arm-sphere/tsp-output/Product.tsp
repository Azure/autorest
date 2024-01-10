import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Catalog.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AzureSphere;
@doc("An product resource belonging to a catalog resource.")
@parentResource(Catalog)
model Product is ProxyResource<ProductProperties> {
  @doc("Name of product.")
  @pattern("^[\\w][\\w\\s]{1,48}[\\w]$|^\\.default$|^\\.unassigned$")
  @path
  @key("productName")
  @segment("products")
  name: string;
}

@armResourceOperations
interface Products {
  @doc("Get a Product. '.default' and '.unassigned' are system defined values and cannot be used for product name.")
  get is ArmResourceRead<Product>;

  @doc("Create a Product. '.default' and '.unassigned' are system defined values and cannot be used for product name.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<
    Product,
    BaseParameters<Product>,
    ArmAsyncOperationHeader
  >;

  @doc("Update a Product. '.default' and '.unassigned' are system defined values and cannot be used for product name.")
  update is ArmCustomPatchAsync<
    Product,
    ProductUpdate,
    BaseParameters<Product>,
    ArmLroLocationHeader
  >;

  @doc("Delete a Product. '.default' and '.unassigned' are system defined values and cannot be used for product name'")
  delete is ArmResourceDeleteAsync<
    Product,
    BaseParameters<Product>,
    ArmLroLocationHeader
  >;

  @doc("List Product resources by Catalog")
  listByCatalog is ArmResourceListByParent<Product>;

  @doc("Counts devices in product. '.default' and '.unassigned' are system defined values and cannot be used for product name.")
  countDevices is ArmResourceActionSync<Product, void, CountDeviceResponse>;

  @doc("Generates default device groups for the product. '.default' and '.unassigned' are system defined values and cannot be used for product name.")
  generateDefaultDeviceGroups is ArmResourceActionSync<
    Product,
    void,
    ResourceListResult<DeviceGroup>
  >;
}
