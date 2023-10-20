import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
@doc("Disk resource.")
model Disk is TrackedResource<DiskProperties> {
  @doc("""
The name of the managed disk that is being created. The name can't be changed
after the disk is created. Supported characters for the name are a-z, A-Z, 0-9,
_ and -. The maximum name length is 80 characters.
""")
  @path
  @key("diskName")
  @segment("disks")
  name: string;
}

@armResourceOperations
interface Disks {
  @doc("Gets information about a disk.")
  get is ArmResourceRead<Disk>;
  @doc("Creates or updates a disk.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Disk>;
  @doc("Updates (patches) a disk.")
  update is ArmResourcePatchAsync<Disk, DiskUpdateProperties>;
  @doc("Deletes a disk.")
  delete is ArmResourceDeleteAsync<Disk>;
  @doc("Lists all the disks under a resource group.")
  listByResourceGroup is ArmResourceListByParent<Disk>;
  @doc("Lists all the disks under a subscription.")
  list is ArmListBySubscription<Disk>;
  @doc("Grants access to a disk.")
  grantAccess is ArmResourceActionAsync<Disk, GrantAccessData, AccessUri>;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("Revokes access to a disk.")
  revokeAccess is ArmResourceActionAsync<Disk, {}, {}>;
}
