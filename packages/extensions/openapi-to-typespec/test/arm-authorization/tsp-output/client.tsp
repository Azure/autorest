import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.ResourceManager.Authorization;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ClassicAdministrator.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ProviderOperation.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignmentCreateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ExpandedProperties.scope);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ExpandedProperties.roleDefinition);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ExpandedProperties.principal);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignmentScheduleRequestProperties.scheduleInfo);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignmentScheduleRequestPropertiesScheduleInfo.expiration
);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleEligibilityScheduleRequestProperties.scheduleInfo);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleEligibilityScheduleRequestPropertiesScheduleInfo.expiration
);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PolicyProperties.scope);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PolicyAssignmentProperties.scope);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PolicyAssignmentProperties.roleDefinition);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PolicyAssignmentProperties.policy);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DenyAssignment.properties);

@@clientName(ProviderOperationsMetadataOperationGroup,
  "ProviderOperationsMetadata"
);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignment.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleDefinition.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignmentSchedule.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignmentScheduleInstance.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleAssignmentScheduleRequest.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleEligibilitySchedule.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleEligibilityScheduleInstance.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleEligibilityScheduleRequest.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleManagementPolicy.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleManagementPolicyAssignment.properties);
