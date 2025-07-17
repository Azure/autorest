import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.ResourceManager.AlertsManagement;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PatchObject.properties);

@@clientLocation(AlertProcessingRules.getByName, "AlertProcessingRules");
@@clientName(AlertProcessingRules.getByName, "GetByName");
@@clientLocation(AlertProcessingRules.createOrUpdate, "AlertProcessingRules");
@@clientName(AlertProcessingRules.createOrUpdate, "CreateOrUpdate");
@@clientName(AlertProcessingRules.createOrUpdate::parameters.resource,
  "alertProcessingRule"
);
@@clientLocation(AlertProcessingRules.update, "AlertProcessingRules");
@@clientName(AlertProcessingRules.update::parameters.properties,
  "alertProcessingRulePatch"
);
@@clientLocation(AlertProcessingRules.delete, "AlertProcessingRules");
@@clientLocation(AlertProcessingRules.listByResourceGroup,
  "AlertProcessingRules"
);
@@clientName(AlertProcessingRules.listByResourceGroup, "ListByResourceGroup");
@@clientLocation(AlertProcessingRules.listBySubscription,
  "AlertProcessingRules"
);
@@clientName(AlertProcessingRules.listBySubscription, "ListBySubscription");

@@clientName(Alerts.getById, "GetById");
@@clientName(Alerts.getAll, "GetAll");
@@clientName(Alerts.changeState, "ChangeState");
@@clientName(Alerts.getHistory, "GetHistory");

@@clientLocation(SmartGroups.getById, "SmartGroups");
@@clientName(SmartGroups.getById, "GetById");
@@clientLocation(SmartGroups.getAll, "SmartGroups");
@@clientName(SmartGroups.getAll, "GetAll");
@@clientLocation(SmartGroups.changeState, "SmartGroups");
@@clientName(SmartGroups.changeState, "ChangeState");
@@clientLocation(SmartGroups.getHistory, "SmartGroups");
@@clientName(SmartGroups.getHistory, "GetHistory");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SmartGroup.properties);

@@clientLocation(AlertsOperationGroup.metaData, "Alerts");
@@clientName(AlertsOperationGroup.metaData, "MetaData");
@@clientLocation(AlertsOperationGroup.getSummary, "Alerts");
@@clientName(AlertsOperationGroup.getSummary, "GetSummary");
