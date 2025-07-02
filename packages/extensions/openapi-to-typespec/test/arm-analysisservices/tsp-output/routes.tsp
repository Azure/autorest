// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.Analysis;

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface ServersOperationGroup {
  /**
   * Lists eligible SKUs for Analysis Services resource provider.
   */
  @autoRoute
  @get
  @action("skus")
  listSkusForNew is ArmProviderActionSync<
    Response = SkuEnumerationForNewResourceResult,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;
  /**
   * Check the name availability in the target location.
   */
  @autoRoute
  checkNameAvailability is ArmProviderActionSync<
    Request = CheckServerNameAvailabilityParameters,
    Response = CheckServerNameAvailabilityResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}
