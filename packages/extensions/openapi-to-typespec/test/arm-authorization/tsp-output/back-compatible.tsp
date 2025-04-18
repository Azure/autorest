import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.ResourceManager.Authorization;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ClassicAdministrator.properties);

@@clientName(Principal.type, "principalType");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ProviderOperation.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignmentCreateParameters.properties);

@@clientName(RoleDefinitionProperties.type, "roleType");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ExpandedProperties.scope);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ExpandedProperties.roleDefinition);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ExpandedProperties.principal);

@@clientName(ExpandedPropertiesScope.id, "scopeId");
@@clientName(ExpandedPropertiesScope.displayName, "scopeDisplayName");
@@clientName(ExpandedPropertiesScope.type, "scopeType");

@@clientName(ExpandedPropertiesRoleDefinition.id, "roleDefinitionId");
@@clientName(ExpandedPropertiesRoleDefinition.displayName,
  "roleDefinitionDisplayName"
);
@@clientName(ExpandedPropertiesRoleDefinition.type, "roleType");

@@clientName(ExpandedPropertiesPrincipal.id, "principalId");
@@clientName(ExpandedPropertiesPrincipal.displayName, "principalDisplayName");
@@clientName(ExpandedPropertiesPrincipal.type, "principalType");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignmentScheduleRequestProperties.scheduleInfo);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignmentScheduleRequestPropertiesScheduleInfo.expiration
);

@@clientName(RoleAssignmentScheduleRequestPropertiesScheduleInfoExpiration.type,
  "expirationType"
);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleEligibilityScheduleRequestProperties.scheduleInfo);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleEligibilityScheduleRequestPropertiesScheduleInfo.expiration
);

@@clientName(RoleEligibilityScheduleRequestPropertiesScheduleInfoExpiration.type,
  "expirationType"
);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PolicyProperties.scope);

@@clientName(PolicyPropertiesScope.id, "scopeId");
@@clientName(PolicyPropertiesScope.displayName, "scopeDisplayName");
@@clientName(PolicyPropertiesScope.type, "scopeType");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PolicyAssignmentProperties.scope);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PolicyAssignmentProperties.roleDefinition);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PolicyAssignmentProperties.policy);

@@clientName(PolicyAssignmentPropertiesScope.id, "scopeId");
@@clientName(PolicyAssignmentPropertiesScope.displayName, "scopeDisplayName");
@@clientName(PolicyAssignmentPropertiesScope.type, "scopeType");

@@clientName(PolicyAssignmentPropertiesRoleDefinition.id, "roleDefinitionId");
@@clientName(PolicyAssignmentPropertiesRoleDefinition.displayName,
  "roleDefinitionDisplayName"
);
@@clientName(PolicyAssignmentPropertiesRoleDefinition.type, "roleType");

@@clientName(PolicyAssignmentPropertiesPolicy.id, "policyId");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DenyAssignment.properties);

@@clientName(RoleAssignments.create::parameters.resource, "parameters");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignment.properties);

@@clientName(RoleDefinitions.createOrUpdate::parameters.resource,
  "roleDefinition"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleDefinition.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignmentSchedule.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignmentScheduleInstance.properties);

@@clientName(RoleAssignmentScheduleRequests.create::parameters.resource,
  "parameters"
);
@@clientName(RoleAssignmentScheduleRequests.validate::parameters.body,
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignmentScheduleRequest.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleEligibilitySchedule.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleEligibilityScheduleInstance.properties);

@@clientName(RoleEligibilityScheduleRequests.create::parameters.resource,
  "parameters"
);
@@clientName(RoleEligibilityScheduleRequests.validate::parameters.body,
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleEligibilityScheduleRequest.properties);

@@clientName(RoleManagementPolicies.update::parameters.properties,
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleManagementPolicy.properties);

@@clientName(RoleManagementPolicyAssignments.create::parameters.resource,
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleManagementPolicyAssignment.properties);
