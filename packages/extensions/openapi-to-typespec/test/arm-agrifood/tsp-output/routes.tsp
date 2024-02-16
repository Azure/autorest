import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.AgFoodPlatform;

interface CheckNameAvailabilityOperations {
  /**
   * Checks the name availability of the resource with requested resource name.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.AgFoodPlatform/checkNameAvailability")
  @post
  checkNameAvailability is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the target subscription. The value must be an UUID.
       */
      @path
      subscriptionId: string;

      /**
       * NameAvailabilityRequest object.
       */
      @body
      nameAvailabilityRequest: CheckNameAvailabilityRequest;
    },
    CheckNameAvailabilityResponse
  >;
}

interface OperationResultsOperations {
  /**
   * Get operationResults for a Data Manager For Agriculture resource.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.AgFoodPlatform/locations/{locations}/operationResults/{operationResultsId}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the target subscription. The value must be an UUID.
       */
      @path
      subscriptionId: string;

      /**
       * Location.
       */
      @path
      locations: string;

      /**
       * operationResultsId for a specific location.
       */
      @path
      operationResultsId: string;
    },
    ArmAsyncOperation
  >;
}
