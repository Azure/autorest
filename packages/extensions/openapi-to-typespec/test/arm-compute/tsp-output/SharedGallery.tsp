import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
// FIXME: SharedGallery has no properties property
@doc("Specifies information about the Shared Gallery that you want to create or update.")
@locationResource
model SharedGallery is ProxyResource<{}> {
  @doc("The unique name of the Shared Gallery.")
  @path
  @key("galleryUniqueName")
  @segment("sharedGalleries")
  name: string;
}

@armResourceOperations
interface SharedGalleries {
  @doc("Get a shared gallery by subscription id or tenant id.")
  get is ArmResourceRead<SharedGallery>;

  @doc("List shared galleries by subscription id or tenant id.")
  list is ArmResourceListByParent<
    SharedGallery,
    {
      ...BaseParameters<SharedGallery>;

      @doc("The query parameter to decide what shared galleries to fetch when doing listing operations.")
      @query("sharedTo")
      sharedTo?: SharedToValues;
    }
  >;
}
