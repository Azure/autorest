import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.DataFactory;

@@clientName(LinkedIntegrationRuntimeRequest.factoryName, "linkedFactoryName");

@@clientName(SynapseSparkJobActivityTypeProperties.args, "arguments");

@@clientName(SalesforceV2Source.SOQLQuery, "soqlQuery");

@@clientName(SalesforceServiceCloudV2Source.SOQLQuery, "soqlQuery");

@@clientLocation(Factories.getFeatureValueByFactory, "ExposureControl");
@@clientLocation(Factories.queryFeatureValuesByFactory, "ExposureControl");
@@clientLocation(Factories.queryByFactory, "PipelineRuns");
@@clientLocation(Factories.pipelineRunsGet, "PipelineRuns");
@@clientName(Factories.pipelineRunsGet, "Get");
@@clientLocation(Factories.cancel, "PipelineRuns");
@@clientLocation(Factories.queryByPipelineRun, "ActivityRuns");
@@clientLocation(Factories.triggersQueryByFactory, "Triggers");
@@clientName(Factories.triggersQueryByFactory, "QueryByFactory");
@@clientLocation(Factories.triggerRunsQueryByFactory, "TriggerRuns");
@@clientName(Factories.triggerRunsQueryByFactory, "QueryByFactory");
@@clientLocation(Factories.create, "DataFlowDebugSession");
@@clientLocation(Factories.dataFlowDebugSessionQueryByFactory,
  "DataFlowDebugSession"
);
@@clientName(Factories.dataFlowDebugSessionQueryByFactory, "QueryByFactory");
@@clientLocation(Factories.addDataFlow, "DataFlowDebugSession");
@@clientLocation(Factories.dataFlowDebugSessionDelete, "DataFlowDebugSession");
@@clientName(Factories.dataFlowDebugSessionDelete, "Delete");
@@clientLocation(Factories.executeCommand, "DataFlowDebugSession");
@@clientLocation(Factories.privateLinkResourcesGet, "privateLinkResources");
@@clientName(Factories.privateLinkResourcesGet, "Get");

@@clientLocation(IntegrationRuntimeResources.get, "IntegrationRuntimes");
@@clientLocation(IntegrationRuntimeResources.createOrUpdate,
  "IntegrationRuntimes"
);
@@clientLocation(IntegrationRuntimeResources.update, "IntegrationRuntimes");
@@clientLocation(IntegrationRuntimeResources.delete, "IntegrationRuntimes");
@@clientLocation(IntegrationRuntimeResources.listByFactory,
  "IntegrationRuntimes"
);
@@clientLocation(IntegrationRuntimeResources.getStatus, "IntegrationRuntimes");
@@clientLocation(IntegrationRuntimeResources.listOutboundNetworkDependenciesEndpoints,
  "IntegrationRuntimes"
);
@@clientLocation(IntegrationRuntimeResources.getConnectionInfo,
  "IntegrationRuntimes"
);
@@clientLocation(IntegrationRuntimeResources.regenerateAuthKey,
  "IntegrationRuntimes"
);
@@clientLocation(IntegrationRuntimeResources.listAuthKeys,
  "IntegrationRuntimes"
);
@@clientLocation(IntegrationRuntimeResources.start, "IntegrationRuntimes");
@@clientLocation(IntegrationRuntimeResources.stop, "IntegrationRuntimes");
@@clientLocation(IntegrationRuntimeResources.syncCredentials,
  "IntegrationRuntimes"
);
@@clientLocation(IntegrationRuntimeResources.getMonitoringData,
  "IntegrationRuntimes"
);
@@clientLocation(IntegrationRuntimeResources.upgrade, "IntegrationRuntimes");
@@clientLocation(IntegrationRuntimeResources.removeLinks,
  "IntegrationRuntimes"
);
@@clientLocation(IntegrationRuntimeResources.createLinkedIntegrationRuntime,
  "IntegrationRuntimes"
);
@@clientLocation(IntegrationRuntimeResources.refresh,
  "IntegrationRuntimeObjectMetadata"
);
@@clientLocation(IntegrationRuntimeResources.integrationRuntimeObjectMetadataGet,
  "IntegrationRuntimeObjectMetadata"
);
@@clientName(IntegrationRuntimeResources.integrationRuntimeObjectMetadataGet,
  "Get"
);
@@clientLocation(IntegrationRuntimeResources.integrationRuntimeNodesGet,
  "IntegrationRuntimeNodes"
);
@@clientName(IntegrationRuntimeResources.integrationRuntimeNodesGet, "Get");
@@clientLocation(IntegrationRuntimeResources.integrationRuntimeNodesDelete,
  "IntegrationRuntimeNodes"
);
@@clientName(IntegrationRuntimeResources.integrationRuntimeNodesDelete,
  "Delete"
);
@@clientLocation(IntegrationRuntimeResources.integrationRuntimeNodesUpdate,
  "IntegrationRuntimeNodes"
);
@@clientName(IntegrationRuntimeResources.integrationRuntimeNodesUpdate,
  "Update"
);
@@clientLocation(IntegrationRuntimeResources.getIpAddress,
  "IntegrationRuntimeNodes"
);
@@clientLocation(IntegrationRuntimeResources.enableInteractiveQuery,
  "IntegrationRuntime"
);
@@clientLocation(IntegrationRuntimeResources.disableInteractiveQuery,
  "IntegrationRuntime"
);

@@clientLocation(LinkedServiceResources.get, "LinkedServices");
@@clientLocation(LinkedServiceResources.createOrUpdate, "LinkedServices");
@@clientLocation(LinkedServiceResources.delete, "LinkedServices");
@@clientLocation(LinkedServiceResources.listByFactory, "LinkedServices");

@@clientLocation(DatasetResources.get, "Datasets");
@@clientLocation(DatasetResources.createOrUpdate, "Datasets");
@@clientLocation(DatasetResources.delete, "Datasets");
@@clientLocation(DatasetResources.listByFactory, "Datasets");

@@clientLocation(PipelineResources.get, "Pipelines");
@@clientLocation(PipelineResources.createOrUpdate, "Pipelines");
@@clientLocation(PipelineResources.delete, "Pipelines");
@@clientLocation(PipelineResources.listByFactory, "Pipelines");
@@clientLocation(PipelineResources.createRun, "Pipelines");

@@clientLocation(TriggerResources.get, "Triggers");
@@clientLocation(TriggerResources.createOrUpdate, "Triggers");
@@clientLocation(TriggerResources.delete, "Triggers");
@@clientLocation(TriggerResources.listByFactory, "Triggers");
@@clientLocation(TriggerResources.subscribeToEvents, "Triggers");
@@clientLocation(TriggerResources.getEventSubscriptionStatus, "Triggers");
@@clientLocation(TriggerResources.unsubscribeFromEvents, "Triggers");
@@clientLocation(TriggerResources.start, "Triggers");
@@clientLocation(TriggerResources.stop, "Triggers");
@@clientLocation(TriggerResources.rerun, "TriggerRuns");
@@clientLocation(TriggerResources.cancel, "TriggerRuns");

@@clientLocation(DataFlowResources.get, "DataFlows");
@@clientLocation(DataFlowResources.createOrUpdate, "DataFlows");
@@clientLocation(DataFlowResources.delete, "DataFlows");
@@clientLocation(DataFlowResources.listByFactory, "DataFlows");

@@clientLocation(ManagedVirtualNetworkResources.get, "ManagedVirtualNetworks");
@@clientLocation(ManagedVirtualNetworkResources.createOrUpdate,
  "ManagedVirtualNetworks"
);
@@clientLocation(ManagedVirtualNetworkResources.listByFactory,
  "ManagedVirtualNetworks"
);

@@clientLocation(ManagedPrivateEndpointResources.get,
  "ManagedPrivateEndpoints"
);
@@clientLocation(ManagedPrivateEndpointResources.createOrUpdate,
  "ManagedPrivateEndpoints"
);
@@clientLocation(ManagedPrivateEndpointResources.delete,
  "ManagedPrivateEndpoints"
);
@@clientLocation(ManagedPrivateEndpointResources.listByFactory,
  "ManagedPrivateEndpoints"
);

@@clientLocation(CredentialResources.get, "CredentialOperations");
@@clientLocation(CredentialResources.createOrUpdate, "CredentialOperations");
@@clientLocation(CredentialResources.delete, "CredentialOperations");
@@clientLocation(CredentialResources.listByFactory, "CredentialOperations");

@@clientLocation(PrivateEndpointConnectionResources.get,
  "PrivateEndpointConnection"
);
@@clientLocation(PrivateEndpointConnectionResources.createOrUpdate,
  "PrivateEndpointConnection"
);
@@clientLocation(PrivateEndpointConnectionResources.delete,
  "PrivateEndpointConnection"
);
@@clientLocation(PrivateEndpointConnectionResources.listByFactory,
  "privateEndPointConnections"
);

@@clientLocation(GlobalParameterResources.get, "GlobalParameters");
@@clientLocation(GlobalParameterResources.createOrUpdate, "GlobalParameters");
@@clientLocation(GlobalParameterResources.delete, "GlobalParameters");
@@clientLocation(GlobalParameterResources.listByFactory, "GlobalParameters");

@@clientLocation(ChangeDataCaptureResources.get, "ChangeDataCapture");
@@clientLocation(ChangeDataCaptureResources.createOrUpdate,
  "ChangeDataCapture"
);
@@clientLocation(ChangeDataCaptureResources.delete, "ChangeDataCapture");
@@clientLocation(ChangeDataCaptureResources.listByFactory, "ChangeDataCapture");
@@clientLocation(ChangeDataCaptureResources.start, "ChangeDataCapture");
@@clientLocation(ChangeDataCaptureResources.stop, "ChangeDataCapture");
@@clientLocation(ChangeDataCaptureResources.status, "ChangeDataCapture");

@@clientLocation(FactoriesOperationGroup.configureFactoryRepo, Factories);

@@clientLocation(ExposureControlOperationGroup.getFeatureValue,
  "ExposureControl"
);
