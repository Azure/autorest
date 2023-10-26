import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Gallery.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
@doc("""
Specifies information about the gallery Application Definition that you want to
create or update.
""")
@parentResource(Gallery)
model GalleryApplication is TrackedResource<GalleryApplicationProperties> {
  @doc("The name of the gallery Application Definition to be retrieved.")
  @path
  @key("galleryApplicationName")
  @segment("applications")
  name: string;
}

@armResourceOperations
interface Applications {
  @doc("Retrieves information about a gallery Application Definition.")
  get is ArmResourceRead<GalleryApplication>;
  @doc("Create or update a gallery Application Definition.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<GalleryApplication>;
  @doc("Update a gallery Application Definition.")
  update is ArmResourcePatchAsync<
    GalleryApplication,
    GalleryApplicationProperties
  >;
  @doc("Delete a gallery Application.")
  delete is ArmResourceDeleteAsync<GalleryApplication>;
  @doc("List gallery Application Definitions in a gallery.")
  listByGallery is ArmResourceListByParent<GalleryApplication>;
}
