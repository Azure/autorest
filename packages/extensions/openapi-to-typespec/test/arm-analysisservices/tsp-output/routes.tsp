// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.Analysis;

@armResourceOperations
interface ServersOperations {
  /**
   * Lists eligible SKUs for Analysis Services resource provider.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Servers_ListSkusForNew")
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Servers_CheckNameAvailability")
  @post
  checkNameAvailability is ArmProviderActionSync<
    Response = CheckServerNameAvailabilityResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter,
    Request = CheckServerNameAvailabilityParameters
  >;
}
