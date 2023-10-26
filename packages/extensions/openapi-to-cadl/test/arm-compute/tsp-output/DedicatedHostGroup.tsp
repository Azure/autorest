import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
@doc("""
Specifies information about the dedicated host group that the dedicated hosts
should be assigned to. Currently, a dedicated host can only be added to a
dedicated host group at creation time. An existing dedicated host cannot be
added to another dedicated host group.
""")
model DedicatedHostGroup is TrackedResource<DedicatedHostGroupProperties> {
  @doc("The name of the dedicated host group.")
  @path
  @key("hostGroupName")
  @segment("hostGroups")
  name: string;

  @doc("""
Availability Zone to use for this host group. Only single zone is supported.
The zone can be assigned only during creation. If not provided, the group
supports all zones in the region. If provided, enforces each host in the group
to be in the same zone.
""")
  zones?: string[];
}

@armResourceOperations
interface DedicatedHostGroups {
  @doc("Retrieves information about a dedicated host group.")
  get is ArmResourceRead<
    DedicatedHostGroup,
    {
      ...BaseParameters<DedicatedHostGroup>;

      @doc("""
The expand expression to apply on the operation. 'InstanceView' will retrieve
the list of instance views of the dedicated hosts under the dedicated host
group. 'UserData' is not supported for dedicated host group.
""")
      @query("$expand")
      $expand?: InstanceViewTypes;
    }
  >;
  @doc("""
Create or update a dedicated host group. For details of Dedicated Host and
Dedicated Host Groups please see [Dedicated Host Documentation]
(https://go.microsoft.com/fwlink/?linkid=2082596)
""")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<DedicatedHostGroup>;
  @doc("Update an dedicated host group.")
  update is ArmResourcePatchSync<
    DedicatedHostGroup,
    DedicatedHostGroupProperties
  >;
  @doc("Delete a dedicated host group.")
  delete is ArmResourceDeleteAsync<DedicatedHostGroup>;
  @doc("""
Lists all of the dedicated host groups in the specified resource group. Use the
nextLink property in the response to get the next page of dedicated host
groups.
""")
  listByResourceGroup is ArmResourceListByParent<DedicatedHostGroup>;
  @doc("""
Lists all of the dedicated host groups in the subscription. Use the nextLink
property in the response to get the next page of dedicated host groups.
""")
  listBySubscription is ArmListBySubscription<DedicatedHostGroup>;
}
