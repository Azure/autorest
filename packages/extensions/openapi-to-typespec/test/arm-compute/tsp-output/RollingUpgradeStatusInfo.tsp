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
@doc("The status of the latest virtual machine scale set rolling upgrade.")
@singleton("latest")
@parentResource(VirtualMachineScaleSet)
model RollingUpgradeStatusInfo
  is TrackedResource<RollingUpgradeStatusInfoProperties> {
  @key("rollingUpgrade")
  @segment("rollingUpgrades")
  name: string;
}

@armResourceOperations
interface RollingUpgradeStatusInfos {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the status of the latest virtual machine scale set rolling upgrade.")
  @operationId("VirtualMachineScaleSetRollingUpgrades_GetLatest")
  getLatest is ArmResourceRead<
    RollingUpgradeStatusInfo,
    {
      ...BaseParameters<RollingUpgradeStatusInfo>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;
}
