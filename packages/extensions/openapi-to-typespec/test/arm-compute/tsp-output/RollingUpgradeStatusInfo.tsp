import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./VirtualMachineScaleSet.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * The status of the latest virtual machine scale set rolling upgrade.
 */
@singleton("latest")
@parentResource(VirtualMachineScaleSet)
model RollingUpgradeStatusInfo
  is Azure.ResourceManager.TrackedResource<RollingUpgradeStatusInfoProperties> {
  ...ResourceNameParameter<
    Resource = RollingUpgradeStatusInfo,
    KeyName = "rollingUpgrade",
    SegmentName = "rollingUpgrades",
    NamePattern = ""
  >;
}

@armResourceOperations
interface RollingUpgradeStatusInfos {
  /**
   * Gets the status of the latest virtual machine scale set rolling upgrade.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineScaleSetRollingUpgrades_GetLatest")
  getLatest is ArmResourceRead<RollingUpgradeStatusInfo>;
}

@@doc(RollingUpgradeStatusInfo.name, "");
@@doc(RollingUpgradeStatusInfo.properties,
  "The status of the latest virtual machine scale set rolling upgrade."
);
