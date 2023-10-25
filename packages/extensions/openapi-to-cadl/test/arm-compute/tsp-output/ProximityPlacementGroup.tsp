import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
@doc("Specifies information about the proximity placement group.")
model ProximityPlacementGroup
  is TrackedResource<ProximityPlacementGroupProperties> {
  @doc("The name of the proximity placement group.")
  @path
  @key("proximityPlacementGroupName")
  @segment("proximityPlacementGroups")
  name: string;
}

@armResourceOperations
interface ProximityPlacementGroups {
  @doc("Retrieves information about a proximity placement group .")
  get is ArmResourceRead<
    ProximityPlacementGroup,
    {
      ...BaseParameters<ProximityPlacementGroup>;

      @doc("""
includeColocationStatus=true enables fetching the colocation status of all the
resources in the proximity placement group.
""")
      @query("includeColocationStatus")
      includeColocationStatus?: string;
    }
  >;
  @doc("Create or update a proximity placement group.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ProximityPlacementGroup>;
  // FIXME: (ArmResourcePatch): ArmResourcePatchSync/ArmResourcePatchAsync should have a body parameter with either properties property or tag property
  @doc("Update a proximity placement group.")
  update is ArmCustomPatchSync<
    ProximityPlacementGroup,
    ProximityPlacementGroupUpdate
  >;
  @doc("Delete a proximity placement group.")
  delete is ArmResourceDeleteAsync<ProximityPlacementGroup>;
  @doc("Lists all proximity placement groups in a resource group.")
  listByResourceGroup is ArmResourceListByParent<ProximityPlacementGroup>;
  @doc("Lists all proximity placement groups in a subscription.")
  listBySubscription is ArmListBySubscription<ProximityPlacementGroup>;
}
