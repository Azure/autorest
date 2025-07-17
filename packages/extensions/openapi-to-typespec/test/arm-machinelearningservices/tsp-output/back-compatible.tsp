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
@@clientName(ComputeResources.createOrUpdate, "CreateOrUpdate");
@@clientName(ComputeResources.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(ComputeResources.update, "Compute");
@@clientName(ComputeResources.update::parameters.properties, "parameters");
@@clientLocation(ComputeResources.delete, "Compute");
@@clientLocation(ComputeResources.list, "Compute");
@@clientLocation(ComputeResources.updateCustomServices, "Compute");
@@clientName(ComputeResources.updateCustomServices, "UpdateCustomServices");
@@clientName(ComputeResources.updateCustomServices::parameters.body,
  "customServices"
);
@@clientLocation(ComputeResources.listNodes, "Compute");
@@clientName(ComputeResources.listNodes, "ListNodes");
@@clientLocation(ComputeResources.listKeys, "Compute");
@@clientName(ComputeResources.listKeys, "ListKeys");
@@clientLocation(ComputeResources.start, "Compute");
@@clientLocation(ComputeResources.stop, "Compute");
@@clientLocation(ComputeResources.restart, "Compute");
@@clientLocation(ComputeResources.updateIdleShutdownSetting, "Compute");
@@clientName(ComputeResources.updateIdleShutdownSetting,
  "UpdateIdleShutdownSetting"
);
@@clientName(ComputeResources.updateIdleShutdownSetting::parameters.body,
  "parameters"
);

@@clientLocation(CodeContainerResources.get, "RegistryCodeContainers");
@@clientLocation(CodeContainerResources.createOrUpdate,
  "RegistryCodeContainers"
);
@@clientName(CodeContainerResources.createOrUpdate, "CreateOrUpdate");
@@clientName(CodeContainerResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(CodeContainerResources.delete, "RegistryCodeContainers");
@@clientLocation(CodeContainerResources.list, "RegistryCodeContainers");
@@clientLocation(CodeContainers.get, "CodeContainers");
@@clientLocation(CodeContainers.createOrUpdate, "CodeContainers");
@@clientName(CodeContainers.createOrUpdate, "CreateOrUpdate");
@@clientName(CodeContainers.createOrUpdate::parameters.resource, "body");
@@clientLocation(CodeContainers.delete, "CodeContainers");
@@clientLocation(CodeContainers.list, "CodeContainers");

@@clientLocation(CodeVersionResources.get, "RegistryCodeVersions");
@@clientLocation(CodeVersionResources.createOrUpdate, "RegistryCodeVersions");
@@clientName(CodeVersionResources.createOrUpdate, "CreateOrUpdate");
@@clientName(CodeVersionResources.createOrUpdate::parameters.resource, "body");
@@clientLocation(CodeVersionResources.delete, "RegistryCodeVersions");
@@clientLocation(CodeVersionResources.list, "RegistryCodeVersions");
@@clientLocation(CodeVersionResources.createOrGetStartPendingUpload,
  "RegistryCodeVersions"
);
@@clientName(CodeVersionResources.createOrGetStartPendingUpload,
  "CreateOrGetStartPendingUpload"
);
@@clientLocation(CodeVersions.get, "CodeVersions");
@@clientLocation(CodeVersions.createOrUpdate, "CodeVersions");
@@clientName(CodeVersions.createOrUpdate, "CreateOrUpdate");
@@clientName(CodeVersions.createOrUpdate::parameters.resource, "body");
@@clientLocation(CodeVersions.delete, "CodeVersions");
@@clientLocation(CodeVersions.list, "CodeVersions");
@@clientLocation(CodeVersions.createOrGetStartPendingUpload, "CodeVersions");
@@clientName(CodeVersions.createOrGetStartPendingUpload,
  "CreateOrGetStartPendingUpload"
);

@@clientLocation(ComponentContainerResources.get,
  "RegistryComponentContainers"
);
@@clientLocation(ComponentContainerResources.createOrUpdate,
  "RegistryComponentContainers"
);
@@clientName(ComponentContainerResources.createOrUpdate, "CreateOrUpdate");
@@clientName(ComponentContainerResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(ComponentContainerResources.delete,
  "RegistryComponentContainers"
);
@@clientLocation(ComponentContainerResources.list,
  "RegistryComponentContainers"
);
@@clientLocation(ComponentContainers.get, "ComponentContainers");
@@clientLocation(ComponentContainers.createOrUpdate, "ComponentContainers");
@@clientName(ComponentContainers.createOrUpdate, "CreateOrUpdate");
@@clientName(ComponentContainers.createOrUpdate::parameters.resource, "body");
@@clientLocation(ComponentContainers.delete, "ComponentContainers");
@@clientLocation(ComponentContainers.list, "ComponentContainers");

@@clientLocation(ComponentVersionResources.get, "RegistryComponentVersions");
@@clientLocation(ComponentVersionResources.createOrUpdate,
  "RegistryComponentVersions"
);
@@clientName(ComponentVersionResources.createOrUpdate, "CreateOrUpdate");
@@clientName(ComponentVersionResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(ComponentVersionResources.delete, "RegistryComponentVersions");
@@clientLocation(ComponentVersionResources.list, "RegistryComponentVersions");
@@clientLocation(ComponentVersions.get, "ComponentVersions");
@@clientLocation(ComponentVersions.createOrUpdate, "ComponentVersions");
@@clientName(ComponentVersions.createOrUpdate, "CreateOrUpdate");
@@clientName(ComponentVersions.createOrUpdate::parameters.resource, "body");
@@clientLocation(ComponentVersions.delete, "ComponentVersions");
@@clientLocation(ComponentVersions.list, "ComponentVersions");

@@clientLocation(DataContainerResources.get, "RegistryDataContainers");
@@clientLocation(DataContainerResources.createOrUpdate,
  "RegistryDataContainers"
);
@@clientName(DataContainerResources.createOrUpdate, "CreateOrUpdate");
@@clientName(DataContainerResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(DataContainerResources.delete, "RegistryDataContainers");
@@clientLocation(DataContainerResources.list, "RegistryDataContainers");
@@clientLocation(DataContainers.get, "DataContainers");
@@clientLocation(DataContainers.createOrUpdate, "DataContainers");
@@clientName(DataContainers.createOrUpdate, "CreateOrUpdate");
@@clientName(DataContainers.createOrUpdate::parameters.resource, "body");
@@clientLocation(DataContainers.delete, "DataContainers");
@@clientLocation(DataContainers.list, "DataContainers");

@@clientLocation(DataVersionBaseResources.get, "RegistryDataVersions");
@@clientLocation(DataVersionBaseResources.createOrUpdate,
  "RegistryDataVersions"
);
@@clientName(DataVersionBaseResources.createOrUpdate, "CreateOrUpdate");
@@clientName(DataVersionBaseResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(DataVersionBaseResources.delete, "RegistryDataVersions");
@@clientLocation(DataVersionBaseResources.list, "RegistryDataVersions");
@@clientLocation(DataVersionBaseResources.createOrGetStartPendingUpload,
  "RegistryDataVersions"
);
@@clientName(DataVersionBaseResources.createOrGetStartPendingUpload,
  "CreateOrGetStartPendingUpload"
);
@@clientLocation(DataVersions.get, "DataVersions");
@@clientLocation(DataVersions.createOrUpdate, "DataVersions");
@@clientName(DataVersions.createOrUpdate, "CreateOrUpdate");
@@clientName(DataVersions.createOrUpdate::parameters.resource, "body");
@@clientLocation(DataVersions.delete, "DataVersions");
@@clientLocation(DataVersions.list, "DataVersions");

@@clientLocation(EnvironmentContainerResources.get,
  "RegistryEnvironmentContainers"
);
@@clientLocation(EnvironmentContainerResources.createOrUpdate,
  "RegistryEnvironmentContainers"
);
@@clientName(EnvironmentContainerResources.createOrUpdate, "CreateOrUpdate");
@@clientName(EnvironmentContainerResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(EnvironmentContainerResources.delete,
  "RegistryEnvironmentContainers"
);
@@clientLocation(EnvironmentContainerResources.list,
  "RegistryEnvironmentContainers"
);
@@clientLocation(EnvironmentContainers.get, "EnvironmentContainers");
@@clientLocation(EnvironmentContainers.createOrUpdate, "EnvironmentContainers");
@@clientName(EnvironmentContainers.createOrUpdate, "CreateOrUpdate");
@@clientName(EnvironmentContainers.createOrUpdate::parameters.resource, "body");
@@clientLocation(EnvironmentContainers.delete, "EnvironmentContainers");
@@clientLocation(EnvironmentContainers.list, "EnvironmentContainers");

@@clientLocation(EnvironmentVersionResources.get,
  "RegistryEnvironmentVersions"
);
@@clientLocation(EnvironmentVersionResources.createOrUpdate,
  "RegistryEnvironmentVersions"
);
@@clientName(EnvironmentVersionResources.createOrUpdate, "CreateOrUpdate");
@@clientName(EnvironmentVersionResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(EnvironmentVersionResources.delete,
  "RegistryEnvironmentVersions"
);
@@clientLocation(EnvironmentVersionResources.list,
  "RegistryEnvironmentVersions"
);
@@clientLocation(EnvironmentVersions.get, "EnvironmentVersions");
@@clientLocation(EnvironmentVersions.createOrUpdate, "EnvironmentVersions");
@@clientName(EnvironmentVersions.createOrUpdate, "CreateOrUpdate");
@@clientName(EnvironmentVersions.createOrUpdate::parameters.resource, "body");
@@clientLocation(EnvironmentVersions.delete, "EnvironmentVersions");
@@clientLocation(EnvironmentVersions.list, "EnvironmentVersions");

@@clientLocation(ModelContainerResources.get, "RegistryModelContainers");
@@clientLocation(ModelContainerResources.createOrUpdate,
  "RegistryModelContainers"
);
@@clientName(ModelContainerResources.createOrUpdate, "CreateOrUpdate");
@@clientName(ModelContainerResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(ModelContainerResources.delete, "RegistryModelContainers");
@@clientLocation(ModelContainerResources.list, "RegistryModelContainers");
@@clientLocation(ModelContainers.get, "ModelContainers");
@@clientLocation(ModelContainers.createOrUpdate, "ModelContainers");
@@clientName(ModelContainers.createOrUpdate, "CreateOrUpdate");
@@clientName(ModelContainers.createOrUpdate::parameters.resource, "body");
@@clientLocation(ModelContainers.delete, "ModelContainers");
@@clientLocation(ModelContainers.list, "ModelContainers");

@@clientLocation(ModelVersionResources.get, "RegistryModelVersions");
@@clientLocation(ModelVersionResources.createOrUpdate, "RegistryModelVersions");
@@clientName(ModelVersionResources.createOrUpdate, "CreateOrUpdate");
@@clientName(ModelVersionResources.createOrUpdate::parameters.resource, "body");
@@clientLocation(ModelVersionResources.delete, "RegistryModelVersions");
@@clientLocation(ModelVersionResources.list, "RegistryModelVersions");
@@clientLocation(ModelVersionResources.package, "RegistryModelVersions");
@@clientLocation(ModelVersionResources.createOrGetStartPendingUpload,
  "RegistryModelVersions"
);
@@clientName(ModelVersionResources.createOrGetStartPendingUpload,
  "CreateOrGetStartPendingUpload"
);
@@clientLocation(ModelVersions.get, "ModelVersions");
@@clientLocation(ModelVersions.createOrUpdate, "ModelVersions");
@@clientName(ModelVersions.createOrUpdate, "CreateOrUpdate");
@@clientName(ModelVersions.createOrUpdate::parameters.resource, "body");
@@clientLocation(ModelVersions.delete, "ModelVersions");
@@clientLocation(ModelVersions.list, "ModelVersions");
@@clientLocation(ModelVersions.package, "ModelVersions");

@@clientLocation(BatchEndpointTrackedResources.get, "BatchEndpoints");
@@clientLocation(BatchEndpointTrackedResources.createOrUpdate,
  "BatchEndpoints"
);
@@clientName(BatchEndpointTrackedResources.createOrUpdate, "CreateOrUpdate");
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
@@clientName(BatchEndpointTrackedResources.listKeys, "ListKeys");

@@clientLocation(BatchDeploymentTrackedResources.get, "BatchDeployments");
@@clientLocation(BatchDeploymentTrackedResources.createOrUpdate,
  "BatchDeployments"
);
@@clientName(BatchDeploymentTrackedResources.createOrUpdate, "CreateOrUpdate");
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
@@clientName(DatastoreResources.createOrUpdate, "CreateOrUpdate");
@@clientName(DatastoreResources.createOrUpdate::parameters.resource, "body");
@@clientLocation(DatastoreResources.delete, "Datastores");
@@clientLocation(DatastoreResources.list, "Datastores");
@@clientLocation(DatastoreResources.listSecrets, "Datastores");
@@clientName(DatastoreResources.listSecrets, "ListSecrets");

@@clientLocation(FeaturesetContainers.getEntity, "FeaturesetContainers");
@@clientName(FeaturesetContainers.getEntity, "GetEntity");
@@clientLocation(FeaturesetContainers.createOrUpdate, "FeaturesetContainers");
@@clientName(FeaturesetContainers.createOrUpdate, "CreateOrUpdate");
@@clientName(FeaturesetContainers.createOrUpdate::parameters.resource, "body");
@@clientLocation(FeaturesetContainers.delete, "FeaturesetContainers");
@@clientLocation(FeaturesetContainers.list, "FeaturesetContainers");

@@clientLocation(FeaturesetVersions.get, "FeaturesetVersions");
@@clientLocation(FeaturesetVersions.createOrUpdate, "FeaturesetVersions");
@@clientName(FeaturesetVersions.createOrUpdate, "CreateOrUpdate");
@@clientName(FeaturesetVersions.createOrUpdate::parameters.resource, "body");
@@clientLocation(FeaturesetVersions.delete, "FeaturesetVersions");
@@clientLocation(FeaturesetVersions.list, "FeaturesetVersions");
@@clientLocation(FeaturesetVersions.backfill, "FeaturesetVersions");
@@clientLocation(FeaturesetVersions.listMaterializationJobs,
  "FeaturesetVersions"
);
@@clientName(FeaturesetVersions.listMaterializationJobs,
  "ListMaterializationJobs"
);

@@clientLocation(FeaturestoreEntityContainers.getEntity,
  "FeaturestoreEntityContainers"
);
@@clientName(FeaturestoreEntityContainers.getEntity, "GetEntity");
@@clientLocation(FeaturestoreEntityContainers.createOrUpdate,
  "FeaturestoreEntityContainers"
);
@@clientName(FeaturestoreEntityContainers.createOrUpdate, "CreateOrUpdate");
@@clientName(FeaturestoreEntityContainers.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(FeaturestoreEntityContainers.delete,
  "FeaturestoreEntityContainers"
);
@@clientLocation(FeaturestoreEntityContainers.list,
  "FeaturestoreEntityContainers"
);

@@clientLocation(FeaturestoreEntityVersions.get, "FeaturestoreEntityVersions");
@@clientLocation(FeaturestoreEntityVersions.createOrUpdate,
  "FeaturestoreEntityVersions"
);
@@clientName(FeaturestoreEntityVersions.createOrUpdate, "CreateOrUpdate");
@@clientName(FeaturestoreEntityVersions.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(FeaturestoreEntityVersions.delete,
  "FeaturestoreEntityVersions"
);
@@clientLocation(FeaturestoreEntityVersions.list, "FeaturestoreEntityVersions");

@@clientLocation(JobBaseResources.get, "Jobs");
@@clientLocation(JobBaseResources.createOrUpdate, "Jobs");
@@clientName(JobBaseResources.createOrUpdate, "CreateOrUpdate");
@@clientName(JobBaseResources.createOrUpdate::parameters.resource, "body");
@@clientLocation(JobBaseResources.update, "Jobs");
@@clientName(JobBaseResources.update::parameters.properties, "body");
@@clientLocation(JobBaseResources.delete, "Jobs");
@@clientLocation(JobBaseResources.list, "Jobs");
@@clientLocation(JobBaseResources.cancel, "Jobs");

@@clientLocation(LabelingJobs.get, "LabelingJobs");
@@clientLocation(LabelingJobs.createOrUpdate, "LabelingJobs");
@@clientName(LabelingJobs.createOrUpdate, "CreateOrUpdate");
@@clientName(LabelingJobs.createOrUpdate::parameters.resource, "body");
@@clientLocation(LabelingJobs.delete, "LabelingJobs");
@@clientLocation(LabelingJobs.list, "LabelingJobs");
@@clientLocation(LabelingJobs.exportLabels, "LabelingJobs");
@@clientName(LabelingJobs.exportLabels, "ExportLabels");
@@clientLocation(LabelingJobs.pause, "LabelingJobs");
@@clientLocation(LabelingJobs.resume, "LabelingJobs");

@@clientLocation(OnlineEndpointTrackedResources.get, "OnlineEndpoints");
@@clientLocation(OnlineEndpointTrackedResources.createOrUpdate,
  "OnlineEndpoints"
);
@@clientName(OnlineEndpointTrackedResources.createOrUpdate, "CreateOrUpdate");
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
@@clientName(OnlineEndpointTrackedResources.listKeys, "ListKeys");
@@clientLocation(OnlineEndpointTrackedResources.regenerateKeys,
  "OnlineEndpoints"
);
@@clientName(OnlineEndpointTrackedResources.regenerateKeys, "RegenerateKeys");
@@clientLocation(OnlineEndpointTrackedResources.getToken, "OnlineEndpoints");
@@clientName(OnlineEndpointTrackedResources.getToken, "GetToken");

@@clientLocation(OnlineDeploymentTrackedResources.get, "OnlineDeployments");
@@clientLocation(OnlineDeploymentTrackedResources.createOrUpdate,
  "OnlineDeployments"
);
@@clientName(OnlineDeploymentTrackedResources.createOrUpdate, "CreateOrUpdate");
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
@@clientName(OnlineDeploymentTrackedResources.getLogs, "GetLogs");
@@clientLocation(OnlineDeploymentTrackedResources.listSkus,
  "OnlineDeployments"
);
@@clientName(OnlineDeploymentTrackedResources.listSkus, "ListSkus");

@@clientName(Schedules.createOrUpdate, "CreateOrUpdate");
@@clientName(Schedules.createOrUpdate::parameters.resource, "body");

@@clientName(Registries.createOrUpdate, "CreateOrUpdate");
@@clientName(Registries.createOrUpdate::parameters.resource, "body");
@@clientName(Registries.update::parameters.properties, "body");
@@clientName(Registries.listBySubscription, "ListBySubscription");
@@clientName(Registries.removeRegions, "RemoveRegions");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Registry.properties);

@@clientName(Workspaces.createOrUpdate, "CreateOrUpdate");
@@clientName(Workspaces.createOrUpdate::parameters.resource, "body");
@@clientName(Workspaces.update::parameters.properties, "body");
@@clientName(Workspaces.listByResourceGroup, "ListByResourceGroup");
@@clientName(Workspaces.listBySubscription, "ListBySubscription");
@@clientLocation(Workspaces.list, "WorkspaceFeatures");
@@clientName(Workspaces.listKeys, "ListKeys");
@@clientName(Workspaces.listNotebookAccessToken, "ListNotebookAccessToken");
@@clientName(Workspaces.listNotebookKeys, "ListNotebookKeys");
@@clientName(Workspaces.listStorageAccountKeys, "ListStorageAccountKeys");
@@clientName(Workspaces.listOutboundNetworkDependenciesEndpoints,
  "ListOutboundNetworkDependenciesEndpoints"
);
@@clientName(Workspaces.prepareNotebook, "PrepareNotebook");
@@clientName(Workspaces.resyncKeys, "ResyncKeys");
@@clientLocation(Workspaces.privateLinkResourcesList, "PrivateLinkResources");
@@clientName(Workspaces.privateLinkResourcesList, "List");
@@clientLocation(Workspaces.provisionManagedNetwork,
  "ManagedNetworkProvisions"
);
@@clientName(Workspaces.provisionManagedNetwork, "ProvisionManagedNetwork");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Workspace.properties);

@@clientLocation(PrivateEndpointConnections.get, "PrivateEndpointConnections");
@@clientLocation(PrivateEndpointConnections.createOrUpdate,
  "PrivateEndpointConnections"
);
@@clientName(PrivateEndpointConnections.createOrUpdate, "CreateOrUpdate");
@@clientName(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "body"
);
@@clientLocation(PrivateEndpointConnections.delete,
  "PrivateEndpointConnections"
);
@@clientLocation(PrivateEndpointConnections.list, "PrivateEndpointConnections");
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
@@clientName(WorkspaceConnectionPropertiesV2BasicResources.listSecrets,
  "ListSecrets"
);

@@clientLocation(OutboundRuleBasicResources.get, "ManagedNetworkSettingsRule");
@@clientLocation(OutboundRuleBasicResources.createOrUpdate,
  "ManagedNetworkSettingsRule"
);
@@clientName(OutboundRuleBasicResources.createOrUpdate, "CreateOrUpdate");
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
