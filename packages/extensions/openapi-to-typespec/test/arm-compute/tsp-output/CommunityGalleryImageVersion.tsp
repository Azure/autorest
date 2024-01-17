import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./CommunityGalleryImage.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
@doc("Specifies information about the gallery image version that you want to create or update.")
@parentResource(CommunityGalleryImage)
model CommunityGalleryImageVersion
  is ProxyResource<CommunityGalleryImageVersionProperties> {
  @doc("The name of the community gallery image version. Needs to follow semantic version name pattern: The allowed characters are digit and period. Digits must be within the range of a 32-bit integer. Format: <MajorVersion>.<MinorVersion>.<Patch>")
  @path
  @key("galleryImageVersionName")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface CommunityGalleryImageVersions {
  @doc("Get a community gallery image version.")
  get is ArmResourceRead<CommunityGalleryImageVersion>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List community gallery image versions inside an image.")
  @operationId("CommunityGalleryImageVersions_List")
  list is ArmResourceListByParent<CommunityGalleryImageVersion>;
}
