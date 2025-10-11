// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Microsoft.GuestConfiguration;

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface GuestConfigurationAssignmentsOperationGroup {
  /** List all guest configuration assignments for a resource group. */
  @autoRoute
  @get
  @action("guestConfigurationAssignments")
  rGList is ArmProviderActionSync<
    Response = GuestConfigurationAssignmentList,
    Scope = Extension.ResourceGroup
  >;
}
