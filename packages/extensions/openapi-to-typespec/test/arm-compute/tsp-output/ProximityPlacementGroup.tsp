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

  @doc("Specifies the Availability Zone where virtual machine, virtual machine scale set or availability set associated with the  proximity placement group can be created.")
  zones?: string[];
}

@armResourceOperations
interface ProximityPlacementGroups {
  @doc("Retrieves information about a proximity placement group .")
  get is ArmResourceRead<
    ProximityPlacementGroup,
    {
      ...BaseParameters<ProximityPlacementGroup>;

      @doc("includeColocationStatus=true enables fetching the colocation status of all the resources in the proximity placement group.")
      @query("includeColocationStatus")
      includeColocationStatus?: string;
    }
  >;
  @doc("Create or update a proximity placement group.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<ProximityPlacementGroup>;
  @doc("Update a proximity placement group.")
  update is ArmCustomPatchSync<
    ProximityPlacementGroup,
    ProximityPlacementGroupUpdate
  >;
  @doc("Delete a proximity placement group.")
  delete is ArmResourceDeleteSync<ProximityPlacementGroup>;
  @doc("Lists all proximity placement groups in a resource group.")
  listByResourceGroup is ArmResourceListByParent<ProximityPlacementGroup>;
  @doc("Lists all proximity placement groups in a subscription.")
  listBySubscription is ArmListBySubscription<ProximityPlacementGroup>;
}
