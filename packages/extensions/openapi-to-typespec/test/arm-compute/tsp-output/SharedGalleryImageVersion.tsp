import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./SharedGalleryImage.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
@doc("Specifies information about the gallery image version that you want to create or update.")
@parentResource(SharedGalleryImage)
model SharedGalleryImageVersion
  is ProxyResource<SharedGalleryImageVersionProperties> {
  @doc("The name of the gallery image version to be created. Needs to follow semantic version name pattern: The allowed characters are digit and period. Digits must be within the range of a 32-bit integer. Format: <MajorVersion>.<MinorVersion>.<Patch>")
  @key("galleryImageVersionName")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface SharedGalleryImageVersions {
  @doc("Get a shared gallery image version by subscription id or tenant id.")
  get is ArmResourceRead<SharedGalleryImageVersion>;

  @doc("List shared gallery image versions by subscription id or tenant id.")
  list is ArmResourceListByParent<
    SharedGalleryImageVersion,
    {
      ...BaseParameters<SharedGalleryImageVersion>;

      @doc("The query parameter to decide what shared galleries to fetch when doing listing operations.")
      @query("sharedTo")
      sharedTo?: SharedToValues;
    }
  >;
}
