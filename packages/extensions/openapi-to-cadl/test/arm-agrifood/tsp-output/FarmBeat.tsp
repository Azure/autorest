import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.AgFoodPlatform;
@doc("FarmBeats ARM Resource.")
model FarmBeat is TrackedResource<FarmBeatsProperties> {
  @doc("FarmBeats resource name.")
  @path
  @key("farmBeatsResourceName")
  @segment("farmBeats")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
}

@armResourceOperations
interface FarmBeats {
  @doc("Get FarmBeats resource.")
  get is ArmResourceRead<FarmBeat>;
  @doc("Create or update FarmBeats resource.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<FarmBeat>;
  @doc("Update a FarmBeats resource.")
  update is ArmResourcePatchAsync<FarmBeat, FarmBeatsProperties>;
  @doc("Delete a FarmBeats resource.")
  delete is ArmResourceDeleteSync<FarmBeat>;
  @doc("Lists the FarmBeats instances for a resource group.")
  listByResourceGroup is ArmResourceListByParent<
    FarmBeat,
    {
      ...BaseParameters<FarmBeat>;

      @doc("""
Maximum number of items needed (inclusive).
Minimum = 10, Maximum = 1000, Default value = 50.
""")
      @maxValue(1000)
      @minValue(10)
      @query("$maxPageSize")
      $maxPageSize?: int32 = 50;

      @doc("Continuation token for getting next set of results.")
      @query("$skipToken")
      $skipToken?: string;
    }
  >;
  @doc("Lists the FarmBeats instances for a subscription.")
  listBySubscription is ArmListBySubscription<FarmBeat>;
  @doc("Get operationResults for a FarmBeats resource.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AgFoodPlatform/farmBeats/{farmBeatsResourceName}/operationResults/{operationResultsId}")
  @get
  GetOperationResult is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @minLength(1)
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      @doc("FarmBeats resource name.")
      @path
      farmBeatsResourceName: string;

      @doc("The operation results id.")
      @pattern("^[A-Za-z0-9]+(-[A-Za-z0-9]+)*$")
      @path
      operationResultsId: string;
    },
    ArmAsyncOperation
  >;
}
