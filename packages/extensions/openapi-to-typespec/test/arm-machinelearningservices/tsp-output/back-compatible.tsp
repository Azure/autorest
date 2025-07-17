import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.ResourceManager.MachineLearning;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ClusterUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RegistryPrivateEndpointConnection.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SharedPrivateLinkResource.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(WorkspaceUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateLinkResource.properties);

@@clientLocation(ComputeResources.get, "Compute");
@@clientLocation(ComputeResources.createOrUpdate, "Compute");
@@clientName(ComputeResources.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(ComputeResources.update, "Compute");
@@clientName(ComputeResources.update::parameters.properties, "parameters");
@@clientLocation(ComputeResources.delete, "Compute");
@@clientLocation(ComputeResources.list, "Compute");
@@clientLocation(ComputeResources.updateCustomServices, "Compute");
@@clientName(ComputeResources.updateCustomServices::parameters.body,
  "customServices"
);
@@clientLocation(ComputeResources.listNodes, "Compute");
@@clientLocation(ComputeResources.listKeys, "Compute");
@@clientLocation(ComputeResources.start, "Compute");
@@clientLocation(ComputeResources.stop, "Compute");
@@clientLocation(ComputeResources.restart, "Compute");
@@clientLocation(ComputeResources.updateIdleShutdownSetting, "Compute");
@@clientName(ComputeResources.updateIdleShutdownSetting::parameters.body,
  "parameters"
);

@@clientLocation(CodeContainerResources.get, "RegistryCodeContainers");
@@clientLocation(CodeContainerResources.createOrUpdate,
  "RegistryCodeContainers"
);
@@clientName(CodeContainerResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(CodeContainerResources.delete, "RegistryCodeContainers");
@@clientLocation(CodeContainerResources.list, "RegistryCodeContainers");
@@clientName(CodeContainers.createOrUpdate::parameters.resource, "body");

@@clientLocation(CodeVersionResources.get, "RegistryCodeVersions");
@@clientLocation(CodeVersionResources.createOrUpdate, "RegistryCodeVersions");
@@clientName(CodeVersionResources.createOrUpdate::parameters.resource, "body");
@@clientLocation(CodeVersionResources.delete, "RegistryCodeVersions");
@@clientLocation(CodeVersionResources.list, "RegistryCodeVersions");
@@clientLocation(CodeVersionResources.createOrGetStartPendingUpload,
  "RegistryCodeVersions"
);
@@clientName(CodeVersions.createOrUpdate::parameters.resource, "body");

@@clientLocation(ComponentContainerResources.get,
  "RegistryComponentContainers"
);
@@clientLocation(ComponentContainerResources.createOrUpdate,
  "RegistryComponentContainers"
);
@@clientName(ComponentContainerResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(ComponentContainerResources.delete,
  "RegistryComponentContainers"
);
@@clientLocation(ComponentContainerResources.list,
  "RegistryComponentContainers"
);
@@clientName(ComponentContainers.createOrUpdate::parameters.resource, "body");

@@clientLocation(ComponentVersionResources.get, "RegistryComponentVersions");
@@clientLocation(ComponentVersionResources.createOrUpdate,
  "RegistryComponentVersions"
);
@@clientName(ComponentVersionResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(ComponentVersionResources.delete, "RegistryComponentVersions");
@@clientLocation(ComponentVersionResources.list, "RegistryComponentVersions");
@@clientName(ComponentVersions.createOrUpdate::parameters.resource, "body");

@@clientLocation(DataContainerResources.get, "RegistryDataContainers");
@@clientLocation(DataContainerResources.createOrUpdate,
  "RegistryDataContainers"
);
@@clientName(DataContainerResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(DataContainerResources.delete, "RegistryDataContainers");
@@clientLocation(DataContainerResources.list, "RegistryDataContainers");
@@clientName(DataContainers.createOrUpdate::parameters.resource, "body");

@@clientLocation(DataVersionBaseResources.get, "RegistryDataVersions");
@@clientLocation(DataVersionBaseResources.createOrUpdate,
  "RegistryDataVersions"
);
@@clientName(DataVersionBaseResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(DataVersionBaseResources.delete, "RegistryDataVersions");
@@clientLocation(DataVersionBaseResources.list, "RegistryDataVersions");
@@clientLocation(DataVersionBaseResources.createOrGetStartPendingUpload,
  "RegistryDataVersions"
);
@@clientName(DataVersions.createOrUpdate::parameters.resource, "body");

@@clientLocation(EnvironmentContainerResources.get,
  "RegistryEnvironmentContainers"
);
@@clientLocation(EnvironmentContainerResources.createOrUpdate,
  "RegistryEnvironmentContainers"
);
@@clientName(EnvironmentContainerResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(EnvironmentContainerResources.delete,
  "RegistryEnvironmentContainers"
);
@@clientLocation(EnvironmentContainerResources.list,
  "RegistryEnvironmentContainers"
);
@@clientName(EnvironmentContainers.createOrUpdate::parameters.resource, "body");

@@clientLocation(EnvironmentVersionResources.get,
  "RegistryEnvironmentVersions"
);
@@clientLocation(EnvironmentVersionResources.createOrUpdate,
  "RegistryEnvironmentVersions"
);
@@clientName(EnvironmentVersionResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(EnvironmentVersionResources.delete,
  "RegistryEnvironmentVersions"
);
@@clientLocation(EnvironmentVersionResources.list,
  "RegistryEnvironmentVersions"
);
@@clientName(EnvironmentVersions.createOrUpdate::parameters.resource, "body");

@@clientLocation(ModelContainerResources.get, "RegistryModelContainers");
@@clientLocation(ModelContainerResources.createOrUpdate,
  "RegistryModelContainers"
);
@@clientName(ModelContainerResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(ModelContainerResources.delete, "RegistryModelContainers");
@@clientLocation(ModelContainerResources.list, "RegistryModelContainers");
@@clientName(ModelContainers.createOrUpdate::parameters.resource, "body");

@@clientLocation(ModelVersionResources.get, "RegistryModelVersions");
@@clientLocation(ModelVersionResources.createOrUpdate, "RegistryModelVersions");
@@clientName(ModelVersionResources.createOrUpdate::parameters.resource, "body");
@@clientLocation(ModelVersionResources.delete, "RegistryModelVersions");
@@clientLocation(ModelVersionResources.list, "RegistryModelVersions");
@@clientLocation(ModelVersionResources.package, "RegistryModelVersions");
@@clientLocation(ModelVersionResources.createOrGetStartPendingUpload,
  "RegistryModelVersions"
);
@@clientName(ModelVersions.createOrUpdate::parameters.resource, "body");

@@clientLocation(BatchEndpointTrackedResources.get, "BatchEndpoints");
@@clientLocation(BatchEndpointTrackedResources.createOrUpdate,
  "BatchEndpoints"
);
@@clientName(BatchEndpointTrackedResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(BatchEndpointTrackedResources.update, "BatchEndpoints");
@@clientName(BatchEndpointTrackedResources.update::parameters.properties,
  "body"
);
@@clientLocation(BatchEndpointTrackedResources.delete, "BatchEndpoints");
@@clientLocation(BatchEndpointTrackedResources.list, "BatchEndpoints");
@@clientLocation(BatchEndpointTrackedResources.listKeys, "BatchEndpoints");

@@clientLocation(BatchDeploymentTrackedResources.get, "BatchDeployments");
@@clientLocation(BatchDeploymentTrackedResources.createOrUpdate,
  "BatchDeployments"
);
@@clientName(BatchDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(BatchDeploymentTrackedResources.update, "BatchDeployments");
@@clientName(BatchDeploymentTrackedResources.update::parameters.properties,
  "body"
);
@@clientLocation(BatchDeploymentTrackedResources.delete, "BatchDeployments");
@@clientLocation(BatchDeploymentTrackedResources.list, "BatchDeployments");

@@clientLocation(DatastoreResources.get, "Datastores");
@@clientLocation(DatastoreResources.createOrUpdate, "Datastores");
@@clientName(DatastoreResources.createOrUpdate::parameters.resource, "body");
@@clientLocation(DatastoreResources.delete, "Datastores");
@@clientLocation(DatastoreResources.list, "Datastores");
@@clientLocation(DatastoreResources.listSecrets, "Datastores");

@@clientName(FeaturesetContainers.createOrUpdate::parameters.resource, "body");

@@clientName(FeaturesetVersions.createOrUpdate::parameters.resource, "body");

@@clientName(FeaturestoreEntityContainers.createOrUpdate::parameters.resource,
  "body"
);

@@clientName(FeaturestoreEntityVersions.createOrUpdate::parameters.resource,
  "body"
);

@@clientLocation(JobBaseResources.get, "Jobs");
@@clientLocation(JobBaseResources.createOrUpdate, "Jobs");
@@clientName(JobBaseResources.createOrUpdate::parameters.resource, "body");
@@clientLocation(JobBaseResources.update, "Jobs");
@@clientName(JobBaseResources.update::parameters.properties, "body");
@@clientLocation(JobBaseResources.delete, "Jobs");
@@clientLocation(JobBaseResources.list, "Jobs");
@@clientLocation(JobBaseResources.cancel, "Jobs");

@@clientName(LabelingJobs.createOrUpdate::parameters.resource, "body");

@@clientLocation(OnlineEndpointTrackedResources.get, "OnlineEndpoints");
@@clientLocation(OnlineEndpointTrackedResources.createOrUpdate,
  "OnlineEndpoints"
);
@@clientName(OnlineEndpointTrackedResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(OnlineEndpointTrackedResources.update, "OnlineEndpoints");
@@clientName(OnlineEndpointTrackedResources.update::parameters.properties,
  "body"
);
@@clientLocation(OnlineEndpointTrackedResources.delete, "OnlineEndpoints");
@@clientLocation(OnlineEndpointTrackedResources.list, "OnlineEndpoints");
@@clientLocation(OnlineEndpointTrackedResources.listKeys, "OnlineEndpoints");
@@clientLocation(OnlineEndpointTrackedResources.regenerateKeys,
  "OnlineEndpoints"
);
@@clientLocation(OnlineEndpointTrackedResources.getToken, "OnlineEndpoints");

@@clientLocation(OnlineDeploymentTrackedResources.get, "OnlineDeployments");
@@clientLocation(OnlineDeploymentTrackedResources.createOrUpdate,
  "OnlineDeployments"
);
@@clientName(OnlineDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(OnlineDeploymentTrackedResources.update, "OnlineDeployments");
@@clientName(OnlineDeploymentTrackedResources.update::parameters.properties,
  "body"
);
@@clientLocation(OnlineDeploymentTrackedResources.delete, "OnlineDeployments");
@@clientLocation(OnlineDeploymentTrackedResources.list, "OnlineDeployments");
@@clientLocation(OnlineDeploymentTrackedResources.getLogs, "OnlineDeployments");
@@clientLocation(OnlineDeploymentTrackedResources.listSkus,
  "OnlineDeployments"
);

@@clientName(Schedules.createOrUpdate::parameters.resource, "body");

@@clientName(Registries.createOrUpdate::parameters.resource, "body");
@@clientName(Registries.update::parameters.properties, "body");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Registry.properties);

@@clientName(Workspaces.createOrUpdate::parameters.resource, "body");
@@clientName(Workspaces.update::parameters.properties, "body");
@@clientLocation(Workspaces.list, "WorkspaceFeatures");
@@clientLocation(Workspaces.privateLinkResourcesList, "PrivateLinkResources");
@@clientName(Workspaces.privateLinkResourcesList, "List");
@@clientLocation(Workspaces.provisionManagedNetwork,
  "ManagedNetworkProvisions"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Workspace.properties);

@@clientName(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "body"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateEndpointConnection.properties);

@@clientLocation(WorkspaceConnectionPropertiesV2BasicResources.get,
  "WorkspaceConnections"
);
@@clientLocation(WorkspaceConnectionPropertiesV2BasicResources.create,
  "WorkspaceConnections"
);
@@clientName(WorkspaceConnectionPropertiesV2BasicResources.create::parameters.resource,
  "body"
);
@@clientLocation(WorkspaceConnectionPropertiesV2BasicResources.update,
  "WorkspaceConnections"
);
@@clientName(WorkspaceConnectionPropertiesV2BasicResources.update::parameters.properties,
  "body"
);
@@clientLocation(WorkspaceConnectionPropertiesV2BasicResources.delete,
  "WorkspaceConnections"
);
@@clientLocation(WorkspaceConnectionPropertiesV2BasicResources.list,
  "WorkspaceConnections"
);
@@clientLocation(WorkspaceConnectionPropertiesV2BasicResources.listSecrets,
  "WorkspaceConnections"
);

@@clientLocation(OutboundRuleBasicResources.get, "ManagedNetworkSettingsRule");
@@clientLocation(OutboundRuleBasicResources.createOrUpdate,
  "ManagedNetworkSettingsRule"
);
@@clientName(OutboundRuleBasicResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(OutboundRuleBasicResources.delete,
  "ManagedNetworkSettingsRule"
);
@@clientLocation(OutboundRuleBasicResources.list, "ManagedNetworkSettingsRule");

@@clientLocation(UsagesOperationGroup.list, "Usages");

@@clientLocation(VirtualMachineSizesOperationGroup.list, "VirtualMachineSizes");

@@clientLocation(QuotasOperationGroup.update, "Quotas");
@@clientLocation(QuotasOperationGroup.list, "Quotas");
