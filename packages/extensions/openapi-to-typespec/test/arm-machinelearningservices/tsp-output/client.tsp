import "./main.tsp";
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

@@clientName(ComputeResources.update,
  "ComputeResources.update::parameters.properties",
  "parameters"
);
@@clientName(ComputeResources.updateCustomServices,
  "ComputeResources.updateCustomServices::parameters.body",
  "customServices"
);
@@clientName(ComputeResources.updateIdleShutdownSetting,
  "ComputeResources.updateIdleShutdownSetting::parameters.body",
  "parameters"
);

@@clientName(BatchEndpointTrackedResources.update,
  "BatchEndpointTrackedResources.update::parameters.properties",
  "body"
);

@@clientName(BatchDeploymentTrackedResources.update,
  "BatchDeploymentTrackedResources.update::parameters.properties",
  "body"
);

@@clientName(JobBaseResources.update,
  "JobBaseResources.update::parameters.properties",
  "body"
);

@@clientName(OnlineEndpointTrackedResources.update,
  "OnlineEndpointTrackedResources.update::parameters.properties",
  "body"
);

@@clientName(OnlineDeploymentTrackedResources.update,
  "OnlineDeploymentTrackedResources.update::parameters.properties",
  "body"
);

@@clientName(Registries.update,
  "Registries.update::parameters.properties",
  "body"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Registry.properties);

@@clientName(Workspaces.update,
  "Workspaces.update::parameters.properties",
  "body"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Workspace.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateEndpointConnection.properties);

@@clientName(WorkspaceConnectionPropertiesV2BasicResources.update,
  "WorkspaceConnectionPropertiesV2BasicResources.update::parameters.properties",
  "body"
);
