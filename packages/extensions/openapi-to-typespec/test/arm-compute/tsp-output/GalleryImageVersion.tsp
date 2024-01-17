import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./GalleryImage.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
@doc("Specifies information about the gallery image version that you want to create or update.")
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
  get is ArmResourceRead<
    GalleryImageVersion,
    {
      ...BaseParameters<GalleryImageVersion>;

      @doc("The expand expression to apply on the operation.")
      @query("$expand")
      $expand?: ReplicationStatusTypes;
    }
  >;

  @doc("Create or update a gallery image version.")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<GalleryImageVersion>;

  @doc("Update a gallery image version.")
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<GalleryImageVersion, GalleryImageVersionUpdate>;

  @doc("Delete a gallery image version.")
  delete is ArmResourceDeleteAsync<GalleryImageVersion>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List gallery image versions in a gallery image definition.")
  @operationId("GalleryImageVersions_ListByGalleryImage")
  listByGalleryImage is ArmResourceListByParent<GalleryImageVersion>;
}

@@projectedName(GalleryImageVersions.createOrUpdate::parameters.resource,
  "json",
  "galleryImageVersion"
);
@@extension(GalleryImageVersions.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "galleryImageVersion"
);
@@doc(GalleryImageVersions.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update gallery image version operation."
);
@@projectedName(GalleryImageVersions.update::parameters.properties,
  "json",
  "galleryImageVersion"
);
@@extension(GalleryImageVersions.update::parameters.properties,
  "x-ms-client-name",
  "galleryImageVersion"
);
@@doc(GalleryImageVersions.update::parameters.properties,
  "Parameters supplied to the update gallery image version operation."
);
