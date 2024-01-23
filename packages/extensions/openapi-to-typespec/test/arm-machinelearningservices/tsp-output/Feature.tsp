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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(FeaturesetVersion)
@Azure.ResourceManager.Private.armResourceInternal(FeatureProperties)
@includeInapplicableMetadataInPayload(false)
model Feature extends ProxyResourceBase {
  /**
   * Feature Name. This is case-sensitive.
   */
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
  @path
  @key("featureName")
  @segment("features")
  name: string;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: FeatureProperties;
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
