import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.ResourceManager.AlertsManagement;

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PatchObject.properties);

@@clientName(AlertProcessingRules.createOrUpdate::parameters.resource,
  "alertProcessingRule"
);
@@clientName(AlertProcessingRules.update::parameters.properties,
  "alertProcessingRulePatch"
);

@@clientName(Alerts.changeState::parameters.body, "comment");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(SmartGroup.properties);

@@clientLocation(AlertsOperationGroup.metaData, Alerts);
@@clientLocation(AlertsOperationGroup.getSummary, Alerts);
