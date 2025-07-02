// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.MachineLearning;

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface UsagesOperationGroup {
  /**
   * Gets the current usage information as well as limits for AML resources for given subscription and location.
   */
  @autoRoute
  @get
  @action("usages")
  list is ArmProviderActionSync<
    Response = ListUsagesResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface VirtualMachineSizesOperationGroup {
  /**
   * Returns supported VM Sizes in a location
   */
  @autoRoute
  @get
  @action("vmSizes")
  list is ArmProviderActionSync<
    Response = VirtualMachineSizeListResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface QuotasOperationGroup {
  /**
   * Update quota for each VM family in workspace.
   */
  @autoRoute
  @action("updateQuotas")
  update is ArmProviderActionSync<
    Request = QuotaUpdateParameters,
    Response = UpdateWorkspaceQuotasResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
  /**
   * Gets the currently assigned Workspace Quotas based on VMFamily.
   */
  @autoRoute
  @get
  @action("quotas")
  list is ArmProviderActionSync<
    Response = ListWorkspaceQuotas,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}
