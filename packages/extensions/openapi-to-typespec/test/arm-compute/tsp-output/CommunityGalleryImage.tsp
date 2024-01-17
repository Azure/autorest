import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./CommunityGallery.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
@doc("Specifies information about the gallery image definition that you want to create or update.")
@parentResource(CommunityGallery)
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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List community gallery images inside a gallery.")
  @operationId("CommunityGalleryImages_List")
  list is ArmResourceListByParent<CommunityGalleryImage>;
}
