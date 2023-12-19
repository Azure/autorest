import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./FarmBeat.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.AgFoodPlatform;
@doc("A private link resource")
@parentResource(FarmBeat)
model AgFoodPlatformPrivateLinkResource
  is ProxyResource<PrivateLinkResourceProperties> {
  @doc("Sub resource name.")
  @path
  @key("subResourceName")
  @segment("privateLinkResources")
  name: string;
}

@armResourceOperations
interface AgFoodPlatformPrivateLinkResources {
  @doc("Get Private link resource object.")
  get is ArmResourceRead<AgFoodPlatformPrivateLinkResource>;
  @doc("Get list of Private link resources.")
  listByResource is ArmResourceListByParent<AgFoodPlatformPrivateLinkResource>;
}
