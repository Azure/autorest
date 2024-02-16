import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./VirtualMachineScaleSet.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * The status of the latest virtual machine scale set rolling upgrade.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@singleton("latest")
@parentResource(VirtualMachineScaleSet)
@includeInapplicableMetadataInPayload(false)
model RollingUpgradeStatusInfo extends Resource {
  @key("rollingUpgrade")
  @segment("rollingUpgrades")
  @visibility("read")
  name: string;

  /**
   * The status of the latest virtual machine scale set rolling upgrade.
   */
  @extension("x-ms-client-flatten", true)
  properties?: RollingUpgradeStatusInfoProperties;
}

@armResourceOperations
interface RollingUpgradeStatusInfos {
  /**
   * Gets the status of the latest virtual machine scale set rolling upgrade.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineScaleSetRollingUpgrades_GetLatest")
  getLatest is ArmResourceRead<
    RollingUpgradeStatusInfo,
    {
      ...BaseParameters<RollingUpgradeStatusInfo>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;
    }
  >;
}
