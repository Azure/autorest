import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.AlertsManagement;
/**
 * Alert processing rule object containing target scopes, conditions and scheduling logic.
 */
model AlertProcessingRule
  is Azure.ResourceManager.TrackedResource<AlertProcessingRuleProperties> {
  ...ResourceNameParameter<
    Resource = AlertProcessingRule,
    KeyName = "alertProcessingRuleName",
    SegmentName = "actionRules",
    NamePattern = ""
  >;
}

@armResourceOperations
interface AlertProcessingRules {
  /**
   * Get an alert processing rule by name.
   */
  getByName is ArmResourceRead<AlertProcessingRule>;

  /**
   * Create or update an alert processing rule.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<AlertProcessingRule>;

  /**
   * Enable, disable, or update tags for an alert processing rule.
   */
  @parameterVisibility
  update is ArmCustomPatchSync<AlertProcessingRule, PatchObject>;

  /**
   * Delete an alert processing rule.
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<AlertProcessingRule>;

  /**
   * List all alert processing rules in a resource group.
   */
  listByResourceGroup is ArmResourceListByParent<
    AlertProcessingRule,
    Response = AlertProcessingRulesList
  >;

  /**
   * List all alert processing rules in a subscription.
   */
  listBySubscription is ArmListBySubscription<
    AlertProcessingRule,
    Response = AlertProcessingRulesList
  >;
}

@@doc(AlertProcessingRule.name,
  "The name of the alert processing rule that needs to be fetched."
);
@@doc(AlertProcessingRule.properties, "Alert processing rule properties.");
@@doc(AlertProcessingRules.createOrUpdate::parameters.resource,
  "Alert processing rule to be created/updated."
);
@@doc(AlertProcessingRules.update::parameters.properties,
  "Parameters supplied to the operation."
);
