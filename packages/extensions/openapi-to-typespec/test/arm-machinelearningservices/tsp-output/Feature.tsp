import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./FeaturesetVersion.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
@parentResource(FeaturesetVersion)
model Feature is ProxyResource<FeatureProperties> {
  /**
   * Feature Name. This is case-sensitive.
   */
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
  @path
  @key("featureName")
  @segment("features")
  name: string;
}

@armResourceOperations
interface Features {
  /**
   * Get feature.
   */
  get is ArmResourceRead<Feature>;

  /**
   * List Features.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Features_List")
  list is ArmResourceListByParent<
    Feature,
    {
      ...BaseParameters<Feature>;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2
       */
      @query("tags")
      tags?: string;

      /**
       * Description of the featureset.
       */
      @query("description")
      description?: string;
    }
  >;
}
