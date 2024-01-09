import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
@doc("disk access resource.")
model DiskAccess is TrackedResource<DiskAccessProperties> {
  @doc("The name of the disk access resource that is being created. The name can't be changed after the disk encryption set is created. Supported characters for the name are a-z, A-Z, 0-9, _ and -. The maximum name length is 80 characters.")
  @key("diskAccessName")
  @segment("diskAccesses")
  name: string;

  @doc("The extended location where the disk access will be created. Extended location cannot be changed.")
  extendedLocation?: ExtendedLocation;
}

@armResourceOperations
interface DiskAccesses {
  @doc("Gets information about a disk access resource.")
  get is ArmResourceRead<DiskAccess>;

  @doc("Creates or updates a disk access resource")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<DiskAccess>;

  @doc("Updates (patches) a disk access resource.")
  update is ArmCustomPatchAsync<DiskAccess, DiskAccessUpdate>;

  @doc("Deletes a disk access resource.")
  delete is ArmResourceDeleteAsync<DiskAccess>;

  @doc("Lists all the disk access resources under a resource group.")
  listByResourceGroup is ArmResourceListByParent<DiskAccess>;

  @doc("Lists all the disk access resources under a subscription.")
  list is ArmListBySubscription<DiskAccess>;

  @doc("Gets the private link resources possible under disk access resource")
  // FIXME: DiskAccesses_GetPrivateLinkResources could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/diskAccesses/{diskAccessName}/privateLinkResources")
  @get
  GetPrivateLinkResources is Azure.Core.Foundations.Operation<
    {
      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the disk access resource that is being created. The name can't be changed after the disk encryption set is created. Supported characters for the name are a-z, A-Z, 0-9, _ and -. The maximum name length is 80 characters.")
      @path
      diskAccessName: string;
    },
    PrivateLinkResourceListResult
  >;
}
