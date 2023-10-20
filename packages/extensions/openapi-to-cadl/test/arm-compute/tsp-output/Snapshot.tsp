import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
@doc("Snapshot resource.")
model Snapshot is TrackedResource<SnapshotProperties> {
  @doc("""
The name of the snapshot that is being created. The name can't be changed after
the snapshot is created. Supported characters for the name are a-z, A-Z, 0-9, _
and -. The max name length is 80 characters.
""")
  @path
  @key("snapshotName")
  @segment("snapshots")
  name: string;
}

@armResourceOperations
interface Snapshots {
  @doc("Gets information about a snapshot.")
  get is ArmResourceRead<Snapshot>;
  @doc("Creates or updates a snapshot.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Snapshot>;
  @doc("Updates (patches) a snapshot.")
  update is ArmResourcePatchAsync<Snapshot, SnapshotUpdateProperties>;
  @doc("Deletes a snapshot.")
  delete is ArmResourceDeleteAsync<Snapshot>;
  @doc("Lists snapshots under a resource group.")
  listByResourceGroup is ArmResourceListByParent<Snapshot>;
  @doc("Lists snapshots under a subscription.")
  list is ArmListBySubscription<Snapshot>;
  @doc("Grants access to a snapshot.")
  grantAccess is ArmResourceActionAsync<Snapshot, GrantAccessData, AccessUri>;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("Revokes access to a snapshot.")
  revokeAccess is ArmResourceActionAsync<Snapshot, {}, {}>;
}
