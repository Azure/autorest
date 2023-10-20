import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./CommunityGallery.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
@doc("""
Specifies information about the gallery image definition that you want to
create or update.
""")
@parentResource(CommunityGallery)
@locationResource
model CommunityGalleryImage is ProxyResource<CommunityGalleryImageProperties> {
  @doc("The name of the community gallery image definition.")
  @path
  @key("galleryImageName")
  @segment("images")
  name: string;
}

@armResourceOperations
interface CommunityGalleryImages {
  @doc("Get a community gallery image.")
  get is ArmResourceRead<CommunityGalleryImage>;
  @doc("List community gallery images inside a gallery.")
  list is ArmResourceListByParent<
    CommunityGalleryImage,
    {
      @doc("Resource location.")
      @path
      location: string;
    }
  >;
}
