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
/**
 * The source user image virtual hard disk. The virtual hard disk will be copied before being attached to the virtual machine. If SourceImage is provided, the destination virtual hard drive must not exist.
 */
model Image is TrackedResource<ImageProperties> {
  /**
   * The name of the image.
   */
  @path
  @key("imageName")
  @segment("images")
  name: string;

  /**
   * The extended location of the Image.
   */
  extendedLocation?: ExtendedLocation;
}

@armResourceOperations
interface Images {
  /**
   * Gets an image.
   */
  get is ArmResourceRead<
    Image,
    {
      ...BaseParameters<Image>;

      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;
    }
  >;

  /**
   * Create or update an image.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Image>;

  /**
   * Update an image.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<Image, ImageUpdate>;

  /**
   * Deletes an Image.
   */
  delete is ArmResourceDeleteAsync<Image>;

  /**
   * Gets the list of images under a resource group. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Images_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<Image>;

  /**
   * Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
   */
  list is ArmListBySubscription<Image>;
}

@@projectedName(Images.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(Images.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(Images.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Image operation."
);
@@projectedName(Images.update::parameters.properties, "json", "parameters");
@@extension(Images.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(Images.update::parameters.properties,
  "Parameters supplied to the Update Image operation."
);
