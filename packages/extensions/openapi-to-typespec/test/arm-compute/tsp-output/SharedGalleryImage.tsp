import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./SharedGallery.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
@doc("Specifies information about the gallery image definition that you want to create or update.")
@parentResource(SharedGallery)
model SharedGalleryImage is ProxyResource<SharedGalleryImageProperties> {
  @doc("The name of the Shared Gallery Image Definition from which the Image Versions are to be listed.")
  @path
  @key("galleryImageName")
  @segment("images")
  name: string;
}

@armResourceOperations
interface SharedGalleryImages {
  @doc("Get a shared gallery image by subscription id or tenant id.")
  get is ArmResourceRead<SharedGalleryImage>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List shared gallery images by subscription id or tenant id.")
  @operationId("SharedGalleryImages_List")
  list is ArmResourceListByParent<
    SharedGalleryImage,
    {
      ...BaseParameters<SharedGalleryImage>;

      @doc("The query parameter to decide what shared galleries to fetch when doing listing operations.")
      @query("sharedTo")
      sharedTo?: SharedToValues;
    }
  >;
}
