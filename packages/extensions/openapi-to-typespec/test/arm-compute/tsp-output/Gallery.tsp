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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Update sharing profile of a gallery.")
  @operationId("GallerySharingProfile_Update")
  update is ArmResourceActionAsync<Gallery, SharingUpdate, SharingUpdate>;
}

@@projectedName(Galleries.createOrUpdate::parameters.resource,
  "json",
  "gallery"
);
@@extension(Galleries.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "gallery"
);
@@doc(Galleries.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update Shared Image Gallery operation."
);
@@projectedName(Galleries.update::parameters.properties, "json", "gallery");
@@extension(Galleries.update::parameters.properties,
  "x-ms-client-name",
  "gallery"
);
@@doc(Galleries.update::parameters.properties,
  "Parameters supplied to the update Shared Image Gallery operation."
);
@@projectedName(Galleries.update::parameters.body, "json", "sharingUpdate");
@@extension(Galleries.update::parameters.body,
  "x-ms-client-name",
  "sharingUpdate"
);
@@doc(Galleries.update::parameters.body,
  "Parameters supplied to the update gallery sharing profile."
);
