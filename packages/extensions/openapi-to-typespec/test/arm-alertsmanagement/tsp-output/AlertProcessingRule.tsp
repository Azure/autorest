import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.AlertsManagement;
@doc("Alert processing rule object containing target scopes, conditions and scheduling logic.")
model AlertProcessingRule is TrackedResource<AlertProcessingRuleProperties> {
  @doc("The name of the alert processing rule that needs to be fetched.")
  @path
  @key("alertProcessingRuleName")
  @segment("actionRules")
  name: string;
}

@armResourceOperations
interface AlertProcessingRules {
  @doc("Get an alert processing rule by name.")
  getByName is ArmResourceRead<AlertProcessingRule>;

  @doc("Create or update an alert processing rule.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<AlertProcessingRule>;

  @doc("Enable, disable, or update tags for an alert processing rule.")
  update is ArmCustomPatchSync<AlertProcessingRule, PatchObject>;

  @doc("Delete an alert processing rule.")
  delete is ArmResourceDeleteSync<AlertProcessingRule>;

  @doc("List all alert processing rules in a resource group.")
  listByResourceGroup is ArmResourceListByParent<AlertProcessingRule>;

  @doc("List all alert processing rules in a subscription.")
  listBySubscription is ArmListBySubscription<AlertProcessingRule>;
}
