import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DedicatedHostGroup.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Specifies information about the Dedicated host.
 */
@parentResource(DedicatedHostGroup)
model DedicatedHost
  is Azure.ResourceManager.TrackedResource<DedicatedHostProperties> {
  ...ResourceNameParameter<
    Resource = DedicatedHost,
    KeyName = "hostName",
    SegmentName = "hosts",
    NamePattern = ""
  >;

  /**
   * SKU of the dedicated host for Hardware Generation and VM family. Only name is required to be set. List Microsoft.Compute SKUs for a list of possible values.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  sku: Sku;
}

@armResourceOperations
interface DedicatedHosts {
  /**
   * Retrieves information about a dedicated host.
   */
  get is ArmResourceRead<
    DedicatedHost,
    Parameters = {
      /**
       * The expand expression to apply on the operation. 'InstanceView' will retrieve the list of instance views of the dedicated host. 'UserData' is not supported for dedicated host.
       */
      @query("$expand")
      $expand?: InstanceViewTypes;
    }
  >;

  /**
   * Create or update a dedicated host .
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    DedicatedHost,
    LroHeaders = ArmLroLocationHeader<FinalResult = DedicatedHost> &
      Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * Update a dedicated host .
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    DedicatedHost,
    PatchModel = DedicatedHostUpdate,
    Response = ArmResponse<DedicatedHost>
  >;

  /**
   * Delete a dedicated host.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    DedicatedHost,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * Lists all of the dedicated hosts in the specified dedicated host group. Use the nextLink property in the response to get the next page of dedicated hosts.
   */
  listByHostGroup is ArmResourceListByParent<DedicatedHost>;

  /**
   * Restart the dedicated host. The operation will complete successfully once the dedicated host has restarted and is running. To determine the health of VMs deployed on the dedicated host after the restart check the Resource Health Center in the Azure Portal. Please refer to https://docs.microsoft.com/azure/service-health/resource-health-overview for more details.
   */
  restart is ArmResourceActionAsyncBase<
    DedicatedHost,
    void,
    OkResponse,
    BaseParameters = Azure.ResourceManager.Foundations.DefaultBaseParameters<DedicatedHost>
  >;

  /**
   * Lists all available dedicated host sizes to which the specified dedicated host can be resized. NOTE: The dedicated host sizes provided can be used to only scale up the existing dedicated host.
   */
  @list
  @get
  @action("hostSizes")
  listAvailableSizes is ArmResourceActionSync<
    DedicatedHost,
    void,
    ArmResponse<DedicatedHostSizeListResult>
  >;
}

@@doc(DedicatedHost.name, "The name of the dedicated host.");
@@doc(DedicatedHost.properties, "Properties of the dedicated host.");
@@doc(DedicatedHosts.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Dedicated Host."
);
@@doc(DedicatedHosts.update::parameters.properties,
  "Parameters supplied to the Update Dedicated Host operation."
);
