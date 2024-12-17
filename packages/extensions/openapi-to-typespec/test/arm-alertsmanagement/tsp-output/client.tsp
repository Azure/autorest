import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.ResourceManager.AlertsManagement;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PatchObject.properties);

@@clientName(AlertProcessingRules.createOrUpdate::parameters.resource,
  "alertProcessingRule"
);
@@clientName(AlertProcessingRules.update::parameters.properties,
  "alertProcessingRulePatch"
);

@@clientName(Alerts.changeState::parameters.body, "comment");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SmartGroup.properties);
