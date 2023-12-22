import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
// FIXME: CommunityGallery has no properties property
@doc("Specifies information about the Community Gallery that you want to create or update.")
@locationResource
model CommunityGallery is ProxyResource<{}> {
  @doc("The public name of the community gallery.")
  @path
  @key("publicGalleryName")
  @segment("communityGalleries")
  name: string;
}

@armResourceOperations
interface CommunityGalleries {
  @doc("Get a community gallery by gallery public name.")
  get is ArmResourceRead<CommunityGallery>;
}