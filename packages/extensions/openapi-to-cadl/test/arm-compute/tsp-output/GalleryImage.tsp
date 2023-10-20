import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Gallery.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
@doc("""
Specifies information about the gallery image definition that you want to
create or update.
""")
@parentResource(Gallery)
model GalleryImage is TrackedResource<GalleryImageProperties> {
  @doc("The name of the gallery image definition to be retrieved.")
  @path
  @key("galleryImageName")
  @segment("images")
  name: string;
}

@armResourceOperations
interface GalleryImages {
  @doc("Retrieves information about a gallery image definition.")
  get is ArmResourceRead<GalleryImage>;
  @doc("Create or update a gallery image definition.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<GalleryImage>;
  @doc("Update a gallery image definition.")
  update is ArmResourcePatchAsync<GalleryImage, GalleryImageProperties>;
  @doc("Delete a gallery image.")
  delete is ArmResourceDeleteAsync<GalleryImage>;
  @doc("List gallery image definitions in a gallery.")
  listByGallery is ArmResourceListByParent<GalleryImage>;
}
