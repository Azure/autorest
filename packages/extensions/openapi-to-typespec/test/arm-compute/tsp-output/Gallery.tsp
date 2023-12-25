import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
@doc("Specifies information about the Shared Image Gallery that you want to create or update.")
model Gallery is TrackedResource<GalleryProperties> {
  @doc("The name of the Shared Image Gallery.")
  @path
  @key("galleryName")
  @segment("galleries")
  name: string;
}

@armResourceOperations
interface Galleries {
  @doc("Retrieves information about a Shared Image Gallery.")
  get is ArmResourceRead<
    Gallery,
    {
      ...BaseParameters<Gallery>;

      @doc("The select expression to apply on the operation.")
      @query("$select")
      $select?: SelectPermissions;

      @doc("The expand query option to apply on the operation.")
      @query("$expand")
      $expand?: GalleryExpandParams;
    }
  >;
  @doc("Create or update a Shared Image Gallery.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Gallery>;
  @doc("Update a Shared Image Gallery.")
  update is ArmCustomPatchAsync<Gallery, GalleryUpdate>;
  @doc("Delete a Shared Image Gallery.")
  delete is ArmResourceDeleteAsync<Gallery>;
  @doc("List galleries under a resource group.")
  listByResourceGroup is ArmResourceListByParent<Gallery>;
  @doc("List galleries under a subscription.")
  list is ArmListBySubscription<Gallery>;
}

@armResourceOperations
interface GallerySharingProfile {
  @doc("Update sharing profile of a gallery.")
  update is ArmResourceActionAsync<Gallery, SharingUpdate, SharingUpdate>;
}
