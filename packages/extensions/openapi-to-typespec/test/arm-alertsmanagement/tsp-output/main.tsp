import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./AlertProcessingRule.tsp";
import "./Alert.tsp";
import "./SmartGroup.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
@armProviderNamespace
@service({
  title: "AlertsManagementClient",
})
// FIXME: Common type version v2 is not supportted for now.
// @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v2)
@doc("AlertsManagement Client")
namespace Azure.ResourceManager.AlertsManagement;
