import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.AgFoodPlatform;

interface CheckNameAvailabilityOperations {
  @doc("Checks the name availability of the resource with requested resource name.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.AgFoodPlatform/checkNameAvailability")
  @post
  checkNameAvailability is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription. The value must be an UUID.")
      @path
      subscriptionId: string;

      @doc("NameAvailabilityRequest object.")
      @body
      nameAvailabilityRequest: CheckNameAvailabilityRequest;
    },
    CheckNameAvailabilityResponse
  >;
}

interface OperationResultsOperations {
  @doc("Get operationResults for a Data Manager For Agriculture resource.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.AgFoodPlatform/locations/{locations}/operationResults/{operationResultsId}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription. The value must be an UUID.")
      @path
      subscriptionId: string;

      @doc("Location.")
      @path
      locations: string;

      @doc("operationResultsId for a specific location.")
      @path
      operationResultsId: string;
    },
    ArmAsyncOperation
  >;
}
