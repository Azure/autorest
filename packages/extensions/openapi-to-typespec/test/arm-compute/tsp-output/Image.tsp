import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
@doc("The source user image virtual hard disk. The virtual hard disk will be copied before being attached to the virtual machine. If SourceImage is provided, the destination virtual hard drive must not exist.")
model Image is TrackedResource<ImageProperties> {
  @doc("The name of the image.")
  @key("imageName")
  @segment("images")
  name: string;

  @doc("The extended location of the Image.")
  extendedLocation?: ExtendedLocation;
}

@armResourceOperations
interface Images {
  @doc("Gets an image.")
  get is ArmResourceRead<
    Image,
    {
      ...BaseParameters<Image>;

      @doc("The expand expression to apply on the operation.")
      @query("$expand")
      $expand?: string;
    }
  >;

  @doc("Create or update an image.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Image>;

  @doc("Update an image.")
  update is ArmCustomPatchAsync<Image, ImageUpdate>;

  @doc("Deletes an Image.")
  delete is ArmResourceDeleteAsync<Image>;

  @doc("Gets the list of images under a resource group. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.")
  listByResourceGroup is ArmResourceListByParent<Image>;

  @doc("Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.")
  list is ArmListBySubscription<Image>;
}
