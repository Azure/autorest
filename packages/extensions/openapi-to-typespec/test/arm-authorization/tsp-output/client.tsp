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

@@clientName(ProviderOperationsMetadataOperationGroup,
  "ProviderOperationsMetadata"
);
