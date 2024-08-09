import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AzurePlaywrightService;
/**
 * A quota resource
 */
@subscriptionResource
@parentResource(SubscriptionLocationResource)
model Quota is Azure.ResourceManager.ProxyResource<QuotaProperties> {
  ...ResourceNameParameter<
    Resource = Quota,
    KeyName = "name",
    SegmentName = "quotas",
    NamePattern = "",
    Type = QuotaNames
  >;
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
  listBySubscription is ArmResourceListByParent<Quota>;
}

@@doc(Quota.name, "The quota name.");
