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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  AlertProcessingRuleProperties
)
model AlertProcessingRule extends Foundations.TrackedResource {
  ...ResourceNameParameter<
    Resource = AlertProcessingRule,
    KeyName = "alertProcessingRuleName",
    SegmentName = "actionRules",
    NamePattern = ""
  >;

  /**
   * Alert processing rule properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: AlertProcessingRuleProperties;
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("AlertProcessingRules_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<AlertProcessingRule>;

  /**
   * List all alert processing rules in a subscription.
   */
  listBySubscription is ArmListBySubscription<AlertProcessingRule>;
}

@@doc(AlertProcessingRule.name,
  "The name of the alert processing rule that needs to be fetched."
);
@@encodedName(AlertProcessingRules.createOrUpdate::parameters.resource,
  "application/json",
  "alertProcessingRule"
);
@@extension(AlertProcessingRules.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "alertProcessingRule"
);
@@doc(AlertProcessingRules.createOrUpdate::parameters.resource,
  "Alert processing rule to be created/updated."
);
@@encodedName(AlertProcessingRules.update::parameters.properties,
  "application/json",
  "alertProcessingRulePatch"
);
@@extension(AlertProcessingRules.update::parameters.properties,
  "x-ms-client-name",
  "alertProcessingRulePatch"
);
@@doc(AlertProcessingRules.update::parameters.properties,
  "Parameters supplied to the operation."
);
