import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./GalleryApplication.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
@doc("Specifies information about the gallery Application Version that you want to create or update.")
@parentResource(GalleryApplication)
model GalleryApplicationVersion
  is TrackedResource<GalleryApplicationVersionProperties> {
  @doc("The name of the gallery Application Version to be retrieved.")
  @path
  @key("galleryApplicationVersionName")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface GalleryApplicationVersions {
  @doc("Retrieves information about a gallery Application Version.")
  get is ArmResourceRead<
    GalleryApplicationVersion,
    {
      ...BaseParameters<GalleryApplicationVersion>;

      @doc("The expand expression to apply on the operation.")
      @query("$expand")
      $expand?: ReplicationStatusTypes;
    }
  >;

  @doc("Create or update a gallery Application Version.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<GalleryApplicationVersion>;

  @doc("Update a gallery Application Version.")
  update is ArmCustomPatchAsync<
    GalleryApplicationVersion,
    GalleryApplicationVersionUpdate
  >;

  @doc("Delete a gallery Application Version.")
  delete is ArmResourceDeleteAsync<GalleryApplicationVersion>;

  @doc("List gallery Application Versions in a gallery Application Definition.")
  listByGalleryApplication is ArmResourceListByParent<GalleryApplicationVersion>;
}
