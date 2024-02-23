import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.NetworkAnalytics;
/**
 * The data catalog resource.
 */
@singleton("default")
model DataProductsCatalog is ProxyResource<DataProductsCatalogProperties> {
  @key("dataProductsCatalog")
  @segment("dataProductsCatalogs")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface DataProductsCatalogs {
  /**
   * Retrieve data type resource.
   */
  get is ArmResourceRead<DataProductsCatalog>;

  /**
   * List data catalog by subscription.
   */
  listBySubscription is ArmListBySubscription<DataProductsCatalog>;

  /**
   * List data catalog by resource group.
   */
  listByResourceGroup is ArmResourceListByParent<DataProductsCatalog>;
}
