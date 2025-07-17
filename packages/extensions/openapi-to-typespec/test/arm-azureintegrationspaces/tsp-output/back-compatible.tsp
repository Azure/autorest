import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.IntegrationSpaces;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SpaceUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApplicationUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BusinessProcessUpdate.properties);

@@clientName(TrackingProfileDefinition.$schema, "schema");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApplicationResourceUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(InfrastructureResourceUpdate.properties);

@@clientName(Spaces.createOrUpdate, "CreateOrUpdate");
@@clientName(Spaces.listByResourceGroup, "ListByResourceGroup");
@@clientName(Spaces.listBySubscription, "ListBySubscription");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Space.properties);

@@clientName(Applications.createOrUpdate, "CreateOrUpdate");
@@clientName(Applications.listBySpace, "ListBySpace");
@@clientName(Applications.deleteBusinessProcessDevelopmentArtifact,
  "DeleteBusinessProcessDevelopmentArtifact"
);
@@clientName(Applications.getBusinessProcessDevelopmentArtifact,
  "GetBusinessProcessDevelopmentArtifact"
);
@@clientName(Applications.listBusinessProcessDevelopmentArtifacts,
  "ListBusinessProcessDevelopmentArtifacts"
);
@@clientName(Applications.saveBusinessProcessDevelopmentArtifact,
  "SaveBusinessProcessDevelopmentArtifact"
);
@@clientName(Applications.validateBusinessProcessDevelopmentArtifact,
  "ValidateBusinessProcessDevelopmentArtifact"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Application.properties);

@@clientLocation(BusinessProcesses.get, "BusinessProcesses");
@@clientLocation(BusinessProcesses.createOrUpdate, "BusinessProcesses");
@@clientName(BusinessProcesses.createOrUpdate, "CreateOrUpdate");
@@clientLocation(BusinessProcesses.patch, "BusinessProcesses");
@@clientLocation(BusinessProcesses.delete, "BusinessProcesses");
@@clientLocation(BusinessProcesses.listByApplication, "BusinessProcesses");
@@clientName(BusinessProcesses.listByApplication, "ListByApplication");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BusinessProcess.properties);

@@clientLocation(BusinessProcessVersions.get, "BusinessProcessVersions");
@@clientLocation(BusinessProcessVersions.listByBusinessProcess,
  "BusinessProcessVersions"
);
@@clientName(BusinessProcessVersions.listByBusinessProcess,
  "ListByBusinessProcess"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BusinessProcessVersion.properties);

@@clientLocation(ApplicationResources.get, "ApplicationResources");
@@clientLocation(ApplicationResources.createOrUpdate, "ApplicationResources");
@@clientName(ApplicationResources.createOrUpdate, "CreateOrUpdate");
@@clientLocation(ApplicationResources.patch, "ApplicationResources");
@@clientLocation(ApplicationResources.delete, "ApplicationResources");
@@clientLocation(ApplicationResources.listByApplication,
  "ApplicationResources"
);
@@clientName(ApplicationResources.listByApplication, "ListByApplication");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApplicationResource.properties);

@@clientLocation(InfrastructureResources.get, "InfrastructureResources");
@@clientLocation(InfrastructureResources.createOrUpdate,
  "InfrastructureResources"
);
@@clientName(InfrastructureResources.createOrUpdate, "CreateOrUpdate");
@@clientLocation(InfrastructureResources.patch, "InfrastructureResources");
@@clientLocation(InfrastructureResources.delete, "InfrastructureResources");
@@clientLocation(InfrastructureResources.listBySpace,
  "InfrastructureResources"
);
@@clientName(InfrastructureResources.listBySpace, "ListBySpace");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(InfrastructureResource.properties);
