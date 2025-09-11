import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.ResourceManager.Authorization;

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ClassicAdministrator.properties);

@@clientName(Principal.type, "principalType");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ProviderOperation.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RoleAssignmentCreateParameters.properties);

@@clientName(RoleDefinitionProperties.type, "roleType");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ExpandedProperties.scope);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ExpandedProperties.roleDefinition);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ExpandedProperties.principal);

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

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RoleAssignmentScheduleRequestProperties.scheduleInfo);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RoleAssignmentScheduleRequestPropertiesScheduleInfo.expiration
);

@@clientName(RoleAssignmentScheduleRequestPropertiesScheduleInfoExpiration.type,
  "expirationType"
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RoleEligibilityScheduleRequestProperties.scheduleInfo);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RoleEligibilityScheduleRequestPropertiesScheduleInfo.expiration
);

@@clientName(RoleEligibilityScheduleRequestPropertiesScheduleInfoExpiration.type,
  "expirationType"
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PolicyProperties.scope);

@@clientName(PolicyPropertiesScope.id, "scopeId");
@@clientName(PolicyPropertiesScope.displayName, "scopeDisplayName");
@@clientName(PolicyPropertiesScope.type, "scopeType");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PolicyAssignmentProperties.scope);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PolicyAssignmentProperties.roleDefinition);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PolicyAssignmentProperties.policy);

@@clientName(PolicyAssignmentPropertiesScope.id, "scopeId");
@@clientName(PolicyAssignmentPropertiesScope.displayName, "scopeDisplayName");
@@clientName(PolicyAssignmentPropertiesScope.type, "scopeType");

@@clientName(PolicyAssignmentPropertiesRoleDefinition.id, "roleDefinitionId");
@@clientName(PolicyAssignmentPropertiesRoleDefinition.displayName,
  "roleDefinitionDisplayName"
);
@@clientName(PolicyAssignmentPropertiesRoleDefinition.type, "roleType");

@@clientName(PolicyAssignmentPropertiesPolicy.id, "policyId");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(DenyAssignment.properties);

@@clientLocation(ProviderOperationsMetadataOperationGroup.get,
  "ProviderOperationsMetadata"
);
@@clientLocation(ProviderOperationsMetadataOperationGroup.list,
  "ProviderOperationsMetadata"
);

@@clientName(RoleAssignments.create::parameters.resource, "parameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RoleAssignment.properties);

@@clientName(RoleDefinitions.createOrUpdate::parameters.resource,
  "roleDefinition"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RoleDefinition.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RoleAssignmentSchedule.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RoleAssignmentScheduleInstance.properties);

@@clientName(RoleAssignmentScheduleRequests.create::parameters.resource,
  "parameters"
);
@@clientName(RoleAssignmentScheduleRequests.validate::parameters.body,
  "parameters"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RoleAssignmentScheduleRequest.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RoleEligibilitySchedule.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RoleEligibilityScheduleInstance.properties);

@@clientName(RoleEligibilityScheduleRequests.create::parameters.resource,
  "parameters"
);
@@clientName(RoleEligibilityScheduleRequests.validate::parameters.body,
  "parameters"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RoleEligibilityScheduleRequest.properties);

@@clientName(RoleManagementPolicies.update::parameters.properties,
  "parameters"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RoleManagementPolicy.properties);

@@clientName(RoleManagementPolicyAssignments.create::parameters.resource,
  "parameters"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RoleManagementPolicyAssignment.properties);

@@clientLocation(ClassicAdministratorsOperationGroup.list,
  "ClassicAdministrators"
);

@@clientLocation(GlobalAdministratorOperationGroup.elevateAccess,
  "GlobalAdministrator"
);

@@clientLocation(AzurePermissionsForResourceGroupOperationGroup.list,
  "AzurePermissionsForResourceGroup"
);

@@clientLocation(AzurePermissionsForResourceOperationGroup.list,
  "AzurePermissionsForResource"
);

@@clientLocation(EligibleChildResourcesOperationGroup.get,
  "EligibleChildResources"
);
