import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.NetworkAnalytics;
@doc("The data catalog resource.")
@singleton("default")
model DataProductsCatalog is ProxyResource<DataProductsCatalogProperties> {
  @key("default")
  @segment("dataProductsCatalogs")
  name: string;
}

@armResourceOperations
interface DataProductsCatalogs {
  @doc("Retrieve data type resource.")
  get is ArmResourceRead<DataProductsCatalog>;
  @doc("List data catalog by subscription.")
  listBySubscription is ArmListBySubscription<DataProductsCatalog>;
  @doc("List data catalog by resource group.")
  listByResourceGroup is ArmResourceListByParent<DataProductsCatalog>;
}
