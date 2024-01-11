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
@doc("Disk resource.")
model Disk is TrackedResource<DiskProperties> {
  @doc("The name of the managed disk that is being created. The name can't be changed after the disk is created. Supported characters for the name are a-z, A-Z, 0-9, _ and -. The maximum name length is 80 characters.")
  @path
  @key("diskName")
  @segment("disks")
  name: string;

  @doc("List of relative URIs containing the IDs of the VMs that have the disk attached. maxShares should be set to a value greater than one for disks to allow attaching them to multiple VMs.")
  @visibility("read")
  managedByExtended?: string[];

  @doc("The Logical zone list for Disk.")
  zones?: string[];

  @doc("The extended location where the disk will be created. Extended location cannot be changed.")
  extendedLocation?: ExtendedLocation;

  ...Azure.ResourceManager.ResourceSku;
  ...Azure.ResourceManager.ManagedBy;
}

@armResourceOperations
interface Disks {
  @doc("Gets information about a disk.")
  get is ArmResourceRead<Disk>;

  @doc("Creates or updates a disk.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Disk>;

  @doc("Updates (patches) a disk.")
  update is ArmCustomPatchAsync<Disk, DiskUpdate>;

  @doc("Deletes a disk.")
  delete is ArmResourceDeleteAsync<Disk>;

  @doc("Lists all the disks under a resource group.")
  listByResourceGroup is ArmResourceListByParent<Disk>;

  @doc("Lists all the disks under a subscription.")
  list is ArmListBySubscription<Disk>;

  @doc("Grants access to a disk.")
  grantAccess is ArmResourceActionAsync<
    Disk,
    GrantAccessData,
    AccessUri,
    BaseParameters<Disk>,
    ArmLroLocationHeader
  >;

  @doc("Revokes access to a disk.")
  revokeAccess is ArmResourceActionAsync<
    Disk,
    void,
    void,
    BaseParameters<Disk>,
    ArmLroLocationHeader
  >;
}
