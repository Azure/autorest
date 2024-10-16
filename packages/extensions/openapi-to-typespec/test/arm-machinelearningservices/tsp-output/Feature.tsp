import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
@parentResource(Workspace)
model Feature is Azure.ResourceManager.ProxyResource<FeatureProperties, false> {
  ...ResourceNameParameter<
    Resource = Feature,
    KeyName = "featureName",
    SegmentName = "features",
    NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$"
  >;
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
  list is ArmResourceListByParent<
    Feature,
    Parameters = {
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
    },
    Response = FeatureResourceArmPaginatedResult
  >;
}

@@doc(Feature.name, "Feature Name. This is case-sensitive.");
@@doc(Feature.properties, "[Required] Additional attributes of the entity.");
