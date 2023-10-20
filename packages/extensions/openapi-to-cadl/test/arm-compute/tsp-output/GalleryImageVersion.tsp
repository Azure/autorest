import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./GalleryImage.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
@doc("""
Specifies information about the gallery image version that you want to create
or update.
""")
@parentResource(GalleryImage)
model GalleryImageVersion is TrackedResource<GalleryImageVersionProperties> {
  @doc("The name of the gallery image version to be retrieved.")
  @path
  @key("galleryImageVersionName")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface GalleryImageVersions {
  @doc("Retrieves information about a gallery image version.")
  get is ArmResourceRead<GalleryImageVersion>;
  @doc("Create or update a gallery image version.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<GalleryImageVersion>;
  @doc("Update a gallery image version.")
  update is ArmResourcePatchAsync<
    GalleryImageVersion,
    GalleryImageVersionProperties
  >;
  @doc("Delete a gallery image version.")
  delete is ArmResourceDeleteAsync<GalleryImageVersion>;
  @doc("List gallery image versions in a gallery image definition.")
  listByGalleryImage is ArmResourceListByParent<GalleryImageVersion>;
}
