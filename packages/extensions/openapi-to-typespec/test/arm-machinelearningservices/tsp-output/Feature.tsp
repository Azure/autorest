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
@doc("Azure Resource Manager resource envelope.")
@parentResource(FeaturesetVersion)
model Feature is ProxyResource<FeatureProperties> {
  @doc("Feature Name. This is case-sensitive.")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
  @path
  @key("featureName")
  @segment("features")
  name: string;
}

@armResourceOperations
interface Features {
  @doc("Get feature.")
  get is ArmResourceRead<Feature>;

  @doc("List Features.")
  list is ArmResourceListByParent<
    Feature,
    {
      ...BaseParameters<Feature>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2")
      @query("tags")
      tags?: string;

      @doc("Description of the featureset.")
      @query("description")
      description?: string;
    }
  >;
}
