import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./DataManagerForAgriculture.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.AgFoodPlatform;
@doc("A private link resource.")
@parentResource(DataManagerForAgriculture)
model PrivateLinkResource is ProxyResource<PrivateLinkResourceProperties> {
  @doc("Sub resource name.")
  @key("subResourceName")
  @segment("privateLinkResources")
  name: string;
}

@armResourceOperations
interface PrivateLinkResources {
  @doc("Get Private link resource object.")
  get is ArmResourceRead<PrivateLinkResource>;
  @doc("Get list of Private link resources.")
  listByResource is ArmResourceListByParent<PrivateLinkResource>;
}
