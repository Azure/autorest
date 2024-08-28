// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.Analysis;

interface ServersOperations {
  /**
   * Lists eligible SKUs for Analysis Services resource provider.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.AnalysisServices/skus")
  @get
  listSkusForNew(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
  ): ArmResponse<SkuEnumerationForNewResourceResult> | ErrorResponse;

  /**
   * Check the name availability in the target location.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.AnalysisServices/locations/{location}/checkNameAvailability")
  @post
  checkNameAvailability(
    ...ApiVersionParameter,
    ...LocationResourceParameter,
    ...SubscriptionIdParameter,

    /**
     * Contains the information used to provision the Analysis Services server.
     */
    @body
    serverParameters: CheckServerNameAvailabilityParameters,
  ): ArmResponse<CheckServerNameAvailabilityResult> | ErrorResponse;
}
