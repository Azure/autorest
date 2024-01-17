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
  @parameterVisibility("read")
  update is ArmCustomPatchSync<AlertProcessingRule, PatchObject>;

  @doc("Delete an alert processing rule.")
  delete is ArmResourceDeleteSync<AlertProcessingRule>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List all alert processing rules in a resource group.")
  @operationId("AlertProcessingRules_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<AlertProcessingRule>;

  @doc("List all alert processing rules in a subscription.")
  listBySubscription is ArmListBySubscription<AlertProcessingRule>;
}

@@projectedName(AlertProcessingRules.createOrUpdate::parameters.resource,
  "json",
  "alertProcessingRule"
);
@@extension(AlertProcessingRules.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "alertProcessingRule"
);
@@doc(AlertProcessingRules.createOrUpdate::parameters.resource,
  "Alert processing rule to be created/updated."
);
@@projectedName(AlertProcessingRules.update::parameters.properties,
  "json",
  "alertProcessingRulePatch"
);
@@extension(AlertProcessingRules.update::parameters.properties,
  "x-ms-client-name",
  "alertProcessingRulePatch"
);
@@doc(AlertProcessingRules.update::parameters.properties,
  "Parameters supplied to the operation."
);
