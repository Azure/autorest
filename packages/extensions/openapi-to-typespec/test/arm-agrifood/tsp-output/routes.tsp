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

namespace Microsoft.AgFoodPlatform;

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface CheckNameAvailabilityOperationGroup {
  /**
   * Checks the name availability of the resource with requested resource name.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("CheckNameAvailability_CheckNameAvailability")
  @autoRoute
  checkNameAvailability is ArmProviderActionSync<
    Request = Azure.ResourceManager.CommonTypes.CheckNameAvailabilityRequest,
    Response = Azure.ResourceManager.CommonTypes.CheckNameAvailabilityResponse,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface OperationResultsOperationGroup {
  /**
   * Get operationResults for a Data Manager For Agriculture resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OperationResults_Get")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.AgFoodPlatform/locations/{locations}/operationResults/{operationResultsId}")
  @get
  get(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,

    /**
     * Location.
     */
    @path
    locations: string,

    /**
     * operationResultsId for a specific location.
     */
    @path
    operationResultsId: string,
  ): ArmResponse<ArmAsyncOperation> | ErrorResponse;
}
