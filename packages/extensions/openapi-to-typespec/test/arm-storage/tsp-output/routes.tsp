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
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the target subscription.
       */
      @minLength(1)
      @path
      subscriptionId: string;
    },
    StorageSkuListResult
  >;
}

interface UsagesOperations {
  /**
   * Gets the current usage count and the limit for the resources of the location under the subscription.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Storage/locations/{location}/usages")
  @get
  listByLocation is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the target subscription.
       */
      @minLength(1)
      @path
      subscriptionId: string;

      /**
       * The location of the Azure Storage resource.
       */
      @path
      location: string;
    },
    UsageListResult
  >;
}
