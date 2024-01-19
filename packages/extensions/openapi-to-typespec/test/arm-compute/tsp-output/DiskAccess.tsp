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
 * disk access resource.
 */
model DiskAccess is TrackedResource<DiskAccessProperties> {
  /**
   * The name of the disk access resource that is being created. The name can't be changed after the disk encryption set is created. Supported characters for the name are a-z, A-Z, 0-9, _ and -. The maximum name length is 80 characters.
   */
  @path
  @key("diskAccessName")
  @segment("diskAccesses")
  name: string;

  /**
   * The extended location where the disk access will be created. Extended location cannot be changed.
   */
  extendedLocation?: ExtendedLocation;
}

@armResourceOperations
interface DiskAccesses {
  /**
   * Gets information about a disk access resource.
   */
  get is ArmResourceRead<DiskAccess>;

  /**
   * Creates or updates a disk access resource
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<DiskAccess>;

  /**
   * Updates (patches) a disk access resource.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<DiskAccess, DiskAccessUpdate>;

  /**
   * Deletes a disk access resource.
   */
  delete is ArmResourceDeleteAsync<DiskAccess>;

  /**
   * Lists all the disk access resources under a resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DiskAccesses_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<DiskAccess>;

  /**
   * Lists all the disk access resources under a subscription.
   */
  list is ArmListBySubscription<DiskAccess>;

  /**
   * Gets the private link resources possible under disk access resource
   */
  // FIXME: DiskAccesses_GetPrivateLinkResources could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/diskAccesses/{diskAccessName}/privateLinkResources")
  @get
  getPrivateLinkResources is Azure.Core.Foundations.Operation<
    {
      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the disk access resource that is being created. The name can't be changed after the disk encryption set is created. Supported characters for the name are a-z, A-Z, 0-9, _ and -. The maximum name length is 80 characters.
       */
      @path
      diskAccessName: string;
    },
    PrivateLinkResourceListResult
  >;
}

@@projectedName(DiskAccesses.createOrUpdate::parameters.resource,
  "json",
  "diskAccess"
);
@@extension(DiskAccesses.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "diskAccess"
);
@@doc(DiskAccesses.createOrUpdate::parameters.resource,
  "disk access object supplied in the body of the Put disk access operation."
);
@@projectedName(DiskAccesses.update::parameters.properties,
  "json",
  "diskAccess"
);
@@extension(DiskAccesses.update::parameters.properties,
  "x-ms-client-name",
  "diskAccess"
);
@@doc(DiskAccesses.update::parameters.properties,
  "disk access object supplied in the body of the Patch disk access operation."
);
