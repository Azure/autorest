import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./DedicatedHostGroup.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
@doc("Specifies information about the Dedicated host.")
@parentResource(DedicatedHostGroup)
model DedicatedHost is TrackedResource<DedicatedHostProperties> {
  @doc("The name of the dedicated host.")
  @key("hostName")
  @segment("hosts")
  name: string;

  ...Azure.ResourceManager.ResourceSku;
}

@armResourceOperations
interface DedicatedHosts {
  @doc("Retrieves information about a dedicated host.")
  get is ArmResourceRead<
    DedicatedHost,
    {
      ...BaseParameters<DedicatedHost>;

      @doc("The expand expression to apply on the operation. 'InstanceView' will retrieve the list of instance views of the dedicated host. 'UserData' is not supported for dedicated host.")
      @query("$expand")
      $expand?: InstanceViewTypes;
    }
  >;

  @doc("Create or update a dedicated host .")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<DedicatedHost>;

  @doc("Update a dedicated host .")
  update is ArmCustomPatchAsync<DedicatedHost, DedicatedHostUpdate>;

  @doc("Delete a dedicated host.")
  delete is ArmResourceDeleteAsync<DedicatedHost>;

  @doc("Lists all of the dedicated hosts in the specified dedicated host group. Use the nextLink property in the response to get the next page of dedicated hosts.")
  listByHostGroup is ArmResourceListByParent<DedicatedHost>;

  @doc("Restart the dedicated host. The operation will complete successfully once the dedicated host has restarted and is running. To determine the health of VMs deployed on the dedicated host after the restart check the Resource Health Center in the Azure Portal. Please refer to https://docs.microsoft.com/azure/service-health/resource-health-overview for more details.")
  restart is ArmResourceActionAsync<DedicatedHost, void, void>;

  @doc("Lists all available dedicated host sizes to which the specified dedicated host can be resized. NOTE: The dedicated host sizes provided can be used to only scale up the existing dedicated host.")
  // FIXME: DedicatedHosts_ListAvailableSizes could not be converted to a resource operation
  ListAvailableSizes is Azure.Core.ResourceList<string>;
}
