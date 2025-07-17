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

@@clientLocation(DenyAssignments.get, "DenyAssignments");
@@clientLocation(DenyAssignments.listForResource, "DenyAssignments");
@@clientName(DenyAssignments.listForResource, "ListForResource");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DenyAssignment.properties);

@@clientLocation(ProviderOperationsMetadataOperationGroup.get,
  "ProviderOperationsMetadata"
);
@@clientLocation(ProviderOperationsMetadataOperationGroup.list,
  "ProviderOperationsMetadata"
);

@@clientLocation(RoleAssignments.get, "RoleAssignments");
@@clientLocation(RoleAssignments.create, "RoleAssignments");
@@clientName(RoleAssignments.create::parameters.resource, "parameters");
@@clientLocation(RoleAssignments.delete, "RoleAssignments");
@@clientLocation(RoleAssignments.listForScope, "RoleAssignments");
@@clientName(RoleAssignments.listForScope, "ListForScope");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignment.properties);

@@clientLocation(RoleDefinitions.get, "RoleDefinitions");
@@clientLocation(RoleDefinitions.createOrUpdate, "RoleDefinitions");
@@clientName(RoleDefinitions.createOrUpdate, "CreateOrUpdate");
@@clientName(RoleDefinitions.createOrUpdate::parameters.resource,
  "roleDefinition"
);
@@clientLocation(RoleDefinitions.delete, "RoleDefinitions");
@@clientLocation(RoleDefinitions.list, "RoleDefinitions");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleDefinition.properties);

@@clientLocation(RoleAssignmentSchedules.get, "RoleAssignmentSchedules");
@@clientLocation(RoleAssignmentSchedules.listForScope,
  "RoleAssignmentSchedules"
);
@@clientName(RoleAssignmentSchedules.listForScope, "ListForScope");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignmentSchedule.properties);

@@clientLocation(RoleAssignmentScheduleInstances.get,
  "RoleAssignmentScheduleInstances"
);
@@clientLocation(RoleAssignmentScheduleInstances.listForScope,
  "RoleAssignmentScheduleInstances"
);
@@clientName(RoleAssignmentScheduleInstances.listForScope, "ListForScope");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignmentScheduleInstance.properties);

@@clientLocation(RoleAssignmentScheduleRequests.get,
  "RoleAssignmentScheduleRequests"
);
@@clientLocation(RoleAssignmentScheduleRequests.create,
  "RoleAssignmentScheduleRequests"
);
@@clientName(RoleAssignmentScheduleRequests.create::parameters.resource,
  "parameters"
);
@@clientLocation(RoleAssignmentScheduleRequests.listForScope,
  "RoleAssignmentScheduleRequests"
);
@@clientName(RoleAssignmentScheduleRequests.listForScope, "ListForScope");
@@clientLocation(RoleAssignmentScheduleRequests.cancel,
  "RoleAssignmentScheduleRequests"
);
@@clientLocation(RoleAssignmentScheduleRequests.validate,
  "RoleAssignmentScheduleRequests"
);
@@clientName(RoleAssignmentScheduleRequests.validate::parameters.body,
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignmentScheduleRequest.properties);

@@clientLocation(RoleEligibilitySchedules.get, "RoleEligibilitySchedules");
@@clientLocation(RoleEligibilitySchedules.listForScope,
  "RoleEligibilitySchedules"
);
@@clientName(RoleEligibilitySchedules.listForScope, "ListForScope");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleEligibilitySchedule.properties);

@@clientLocation(RoleEligibilityScheduleInstances.get,
  "RoleEligibilityScheduleInstances"
);
@@clientLocation(RoleEligibilityScheduleInstances.listForScope,
  "RoleEligibilityScheduleInstances"
);
@@clientName(RoleEligibilityScheduleInstances.listForScope, "ListForScope");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleEligibilityScheduleInstance.properties);

@@clientLocation(RoleEligibilityScheduleRequests.get,
  "RoleEligibilityScheduleRequests"
);
@@clientLocation(RoleEligibilityScheduleRequests.create,
  "RoleEligibilityScheduleRequests"
);
@@clientName(RoleEligibilityScheduleRequests.create::parameters.resource,
  "parameters"
);
@@clientLocation(RoleEligibilityScheduleRequests.listForScope,
  "RoleEligibilityScheduleRequests"
);
@@clientName(RoleEligibilityScheduleRequests.listForScope, "ListForScope");
@@clientLocation(RoleEligibilityScheduleRequests.cancel,
  "RoleEligibilityScheduleRequests"
);
@@clientLocation(RoleEligibilityScheduleRequests.validate,
  "RoleEligibilityScheduleRequests"
);
@@clientName(RoleEligibilityScheduleRequests.validate::parameters.body,
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleEligibilityScheduleRequest.properties);

@@clientLocation(RoleManagementPolicies.get, "RoleManagementPolicies");
@@clientLocation(RoleManagementPolicies.update, "RoleManagementPolicies");
@@clientName(RoleManagementPolicies.update::parameters.properties,
  "parameters"
);
@@clientLocation(RoleManagementPolicies.listForScope, "RoleManagementPolicies");
@@clientName(RoleManagementPolicies.listForScope, "ListForScope");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleManagementPolicy.properties);

@@clientLocation(RoleManagementPolicyAssignments.get,
  "RoleManagementPolicyAssignments"
);
@@clientLocation(RoleManagementPolicyAssignments.create,
  "RoleManagementPolicyAssignments"
);
@@clientName(RoleManagementPolicyAssignments.create::parameters.resource,
  "parameters"
);
@@clientLocation(RoleManagementPolicyAssignments.listForScope,
  "RoleManagementPolicyAssignments"
);
@@clientName(RoleManagementPolicyAssignments.listForScope, "ListForScope");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleManagementPolicyAssignment.properties);

@@clientLocation(ClassicAdministratorsOperationGroup.list,
  "ClassicAdministrators"
);

@@clientLocation(GlobalAdministratorOperationGroup.elevateAccess,
  "GlobalAdministrator"
);
@@clientName(GlobalAdministratorOperationGroup.elevateAccess, "ElevateAccess");

@@clientLocation(AzurePermissionsForResourceGroupOperationGroup.list,
  "AzurePermissionsForResourceGroup"
);

@@clientLocation(AzurePermissionsForResourceOperationGroup.list,
  "AzurePermissionsForResource"
);

@@clientLocation(EligibleChildResourcesOperationGroup.get,
  "EligibleChildResources"
);
