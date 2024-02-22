import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DedicatedHostGroup.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Specifies information about the Dedicated host.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(DedicatedHostGroup)
@includeInapplicableMetadataInPayload(false)
model DedicatedHost extends Resource {
  /**
   * The name of the dedicated host.
   */
  @path
  @key("hostName")
  @segment("hosts")
  @visibility("read")
  name: string;

  /**
   * SKU of the dedicated host for Hardware Generation and VM family. Only name is required to be set. List Microsoft.Compute SKUs for a list of possible values.
   */
  sku: Sku;

  /**
   * Properties of the dedicated host.
   */
  @extension("x-ms-client-flatten", true)
  properties?: DedicatedHostProperties;
}

@armResourceOperations
interface DedicatedHosts {
  /**
   * Retrieves information about a dedicated host.
   */
  get is ArmResourceRead<
    DedicatedHost,
    {
      ...BaseParameters<DedicatedHost>;

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
  createOrUpdate is ArmResourceCreateOrReplaceAsync<DedicatedHost>;

  /**
   * Update a dedicated host .
   */
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<DedicatedHost, DedicatedHostUpdate>;

  /**
   * Delete a dedicated host.
   */
  delete is ArmResourceDeleteAsync<DedicatedHost>;

  /**
   * Lists all of the dedicated hosts in the specified dedicated host group. Use the nextLink property in the response to get the next page of dedicated hosts.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DedicatedHosts_ListByHostGroup")
  listByHostGroup is ArmResourceListByParent<DedicatedHost>;

  /**
   * Restart the dedicated host. The operation will complete successfully once the dedicated host has restarted and is running. To determine the health of VMs deployed on the dedicated host after the restart check the Resource Health Center in the Azure Portal. Please refer to https://docs.microsoft.com/azure/service-health/resource-health-overview for more details.
   */
  restart is ArmResourceActionAsync<DedicatedHost, void, void>;

  /**
   * Lists all available dedicated host sizes to which the specified dedicated host can be resized. NOTE: The dedicated host sizes provided can be used to only scale up the existing dedicated host.
   */
  // FIXME: DedicatedHosts_ListAvailableSizes could not be converted to a resource operation
  listAvailableSizes is Azure.Core.ResourceList<string>;
}

@@encodedName(DedicatedHosts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(DedicatedHosts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(DedicatedHosts.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Dedicated Host."
);
@@encodedName(DedicatedHosts.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(DedicatedHosts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(DedicatedHosts.update::parameters.properties,
  "Parameters supplied to the Update Dedicated Host operation."
);
