import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./Extension.tsp";
import "./FarmBeatsExtension.tsp";
import "./FarmBeat.tsp";
import "./AgFoodPlatformPrivateEndpointConnection.tsp";
import "./AgFoodPlatformPrivateLinkResource.tsp";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
@armProviderNamespace
@service({
  title: "Azure AgFoodPlatform RP Service",
})
@versioned(Versions)
@doc("APIs documentation for Azure AgFoodPlatform Resource Provider Service.")
namespace Azure.ResourceManager.AgFoodPlatform;

@doc("The available API versions.")
enum Versions {
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2021_09_01_preview: "2021-09-01-preview",
}
