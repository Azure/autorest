// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Microsoft.Storage;

interface SkusOperations {
  /**
   * Lists the available SKUs supported by Microsoft.Storage for given subscription.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Storage/skus")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
  ): ArmResponse<StorageSkuListResult> | ErrorResponse;
}

interface UsagesOperations {
  /**
   * Gets the current usage count and the limit for the resources of the location under the subscription.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Storage/locations/{location}/usages")
  @get
  listByLocation(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...LocationResourceParameter,
  ): ArmResponse<UsageListResult> | ErrorResponse;
}
