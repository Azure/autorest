import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.AzurePlaywrightService;
@doc("A quota resource")
@locationResource
model Quota is ProxyResource<QuotaProperties> {
  @doc("The quota name.")
  @key("name")
  @segment("quotas")
  name: QuotaNames;
}

@armResourceOperations
interface Quotas {
  @doc("Get quota by name.")
  get is ArmResourceRead<Quota>;
  @doc("List quotas for a given subscription Id.")
  listBySubscription is ArmResourceListByParent<Quota>;
}
