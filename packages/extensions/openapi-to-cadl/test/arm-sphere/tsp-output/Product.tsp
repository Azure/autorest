import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

@doc("An product resource belonging to a catalog resource.")
@parentResource("Catalog")
model Product is ProxyResource<ProductProperties> {
  @doc("Name of product.")
  @pattern("^[\\w][\\w\\s]{1,48}[\\w]$|^\\.default$|^\\.unassigned$")
  @key("productName")
  @path
  @segment("products")
  name: string;
}

@armResourceOperations
interface Products
  extends Azure.ResourceManager.ProxyResourceOperations<
      Product,
      ProductProperties
    > {
  @autoroute
  @doc("""
Counts devices in product. '.default' and '.unassigned' are system defined
values and cannot be used for product name.
""")
  @armResourceLocation(Product)
  @post
  countDevices(
    ...ResourceInstanceParameters<Product>
  ): ArmResponse<CountDeviceResponse> | ErrorResponse;
  @autoroute
  @doc("""
Generates default device groups for the product. '.default' and '.unassigned'
are system defined values and cannot be used for product name.
""")
  @armResourceLocation(Product)
  @post
  generateDefaultDeviceGroups(
    ...ResourceInstanceParameters<Product>,
    ...ListQueryParameters
  ): ArmResponse<ResourceListResult<DeviceGroupListResult>> | ErrorResponse;
}
