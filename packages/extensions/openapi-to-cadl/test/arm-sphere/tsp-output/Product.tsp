import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Catalog.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.AzureSphere;
@doc("An product resource belonging to a catalog resource.")
@parentResource(Catalog)
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
  extends Azure.ResourceManager.ProxyResourceOperations<Product> {
  @autoRoute
  @doc("""
Counts devices in product. '.default' and '.unassigned' are system defined
values and cannot be used for product name.
""")
  @armResourceAction(Product)
  @post
  countDevices(
    ...ResourceInstanceParameters<Product>
  ): ArmResponse<CountDeviceResponse> | ErrorResponse;
  @autoRoute
  @doc("""
Generates default device groups for the product. '.default' and '.unassigned'
are system defined values and cannot be used for product name.
""")
  @armResourceAction(Product)
  @post
  generateDefaultDeviceGroups(
    ...ResourceInstanceParameters<Product>
  ): ArmResponse<ResourceListResult<DeviceGroup>> | ErrorResponse;
}
