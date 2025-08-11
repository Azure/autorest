import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Catalog.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AzureSphere;
/**
 * An product resource belonging to a catalog resource.
 */
@parentResource(Catalog)
model Product is Azure.ResourceManager.ProxyResource<ProductProperties> {
  ...ResourceNameParameter<
    Resource = Product,
    KeyName = "productName",
    SegmentName = "products",
    NamePattern = "^[\\w][\\w\\s]{1,48}[\\w]$|^\\.default$|^\\.unassigned$"
  >;
}

@armResourceOperations
interface Products {
  /**
   * Get a Product. '.default' and '.unassigned' are system defined values and cannot be used for product name.
   */
  get is ArmResourceRead<Product>;

  /**
   * Create a Product. '.default' and '.unassigned' are system defined values and cannot be used for product name.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Product>;

  /**
   * Update a Product. '.default' and '.unassigned' are system defined values and cannot be used for product name.
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<Product, PatchModel = ProductUpdate>;

  /**
   * Delete a Product. '.default' and '.unassigned' are system defined values and cannot be used for product name'
   */
  delete is ArmResourceDeleteWithoutOkAsync<
    Product,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List Product resources by Catalog
   */
  listByCatalog is ArmResourceListByParent<Product>;

  /**
   * Counts devices in product. '.default' and '.unassigned' are system defined values and cannot be used for product name.
   */
  countDevices is ArmResourceActionSync<
    Product,
    void,
    ArmResponse<CountDeviceResponse>
  >;

  /**
   * Generates default device groups for the product. '.default' and '.unassigned' are system defined values and cannot be used for product name.
   */
  @list
  generateDefaultDeviceGroups is ArmResourceActionSync<
    Product,
    void,
    ArmResponse<ResourceListResult<DeviceGroup>>
  >;
}

@@doc(Product.name, "Name of product.");
@@doc(Product.properties,
  "The resource-specific properties for this resource."
);
