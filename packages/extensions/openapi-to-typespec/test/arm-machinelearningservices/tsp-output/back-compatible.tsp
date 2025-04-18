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

@@clientName(ComputeResources.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientName(ComputeResources.update::parameters.properties, "parameters");
@@clientName(ComputeResources.updateCustomServices::parameters.body,
  "customServices"
);
@@clientName(ComputeResources.updateIdleShutdownSetting::parameters.body,
  "parameters"
);

@@clientName(CodeContainerResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientName(CodeContainers.createOrUpdate::parameters.resource, "body");

@@clientName(CodeVersionResources.createOrUpdate::parameters.resource, "body");
@@clientName(CodeVersions.createOrUpdate::parameters.resource, "body");

@@clientName(ComponentContainerResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientName(ComponentContainers.createOrUpdate::parameters.resource, "body");

@@clientName(ComponentVersionResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientName(ComponentVersions.createOrUpdate::parameters.resource, "body");

@@clientName(DataContainerResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientName(DataContainers.createOrUpdate::parameters.resource, "body");

@@clientName(DataVersionBaseResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientName(DataVersions.createOrUpdate::parameters.resource, "body");

@@clientName(EnvironmentContainerResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientName(EnvironmentContainers.createOrUpdate::parameters.resource, "body");

@@clientName(EnvironmentVersionResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientName(EnvironmentVersions.createOrUpdate::parameters.resource, "body");

@@clientName(ModelContainerResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientName(ModelContainers.createOrUpdate::parameters.resource, "body");

@@clientName(ModelVersionResources.createOrUpdate::parameters.resource, "body");
@@clientName(ModelVersions.createOrUpdate::parameters.resource, "body");

@@clientName(BatchEndpointTrackedResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientName(BatchEndpointTrackedResources.update::parameters.properties,
  "body"
);

@@clientName(BatchDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientName(BatchDeploymentTrackedResources.update::parameters.properties,
  "body"
);

@@clientName(DatastoreResources.createOrUpdate::parameters.resource, "body");

@@clientName(FeaturesetContainers.createOrUpdate::parameters.resource, "body");

@@clientName(FeaturesetVersions.createOrUpdate::parameters.resource, "body");

@@clientName(FeaturestoreEntityContainers.createOrUpdate::parameters.resource,
  "body"
);

@@clientName(FeaturestoreEntityVersions.createOrUpdate::parameters.resource,
  "body"
);

@@clientName(JobBaseResources.createOrUpdate::parameters.resource, "body");
@@clientName(JobBaseResources.update::parameters.properties, "body");

@@clientName(LabelingJobs.createOrUpdate::parameters.resource, "body");

@@clientName(OnlineEndpointTrackedResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientName(OnlineEndpointTrackedResources.update::parameters.properties,
  "body"
);

@@clientName(OnlineDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "body"
);
@@clientName(OnlineDeploymentTrackedResources.update::parameters.properties,
  "body"
);

@@clientName(Schedules.createOrUpdate::parameters.resource, "body");

@@clientName(Registries.createOrUpdate::parameters.resource, "body");
@@clientName(Registries.update::parameters.properties, "body");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Registry.properties);

@@clientName(Workspaces.createOrUpdate::parameters.resource, "body");
@@clientName(Workspaces.update::parameters.properties, "body");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Workspace.properties);

@@clientName(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "body"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateEndpointConnection.properties);

@@clientName(WorkspaceConnectionPropertiesV2BasicResources.create::parameters.resource,
  "body"
);
@@clientName(WorkspaceConnectionPropertiesV2BasicResources.update::parameters.properties,
  "body"
);

@@clientName(OutboundRuleBasicResources.createOrUpdate::parameters.resource,
  "body"
);
