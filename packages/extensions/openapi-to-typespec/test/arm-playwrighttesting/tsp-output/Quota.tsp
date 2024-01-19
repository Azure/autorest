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

namespace Microsoft.AzurePlaywrightService;
/**
 * A quota resource
 */
@locationResource
model Quota is ProxyResource<QuotaProperties> {
  /**
   * The quota name.
   */
  @path
  @key("name")
  @segment("quotas")
  name: QuotaNames;
}

@armResourceOperations
interface Quotas {
  /**
   * Get quota by name.
   */
  get is ArmResourceRead<Quota>;

  /**
   * List quotas for a given subscription Id.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Quotas_ListBySubscription")
  listBySubscription is ArmResourceListByParent<Quota>;
}
