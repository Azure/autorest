import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./ComputeResource.tsp";
import "./CodeContainerResource.tsp";
import "./CodeContainerResource.tsp";
import "./CodeVersionResource.tsp";
import "./CodeVersionResource.tsp";
import "./ComponentContainerResource.tsp";
import "./ComponentContainerResource.tsp";
import "./ComponentVersionResource.tsp";
import "./ComponentVersionResource.tsp";
import "./DataContainerResource.tsp";
import "./DataContainerResource.tsp";
import "./DataVersionBaseResource.tsp";
import "./DataVersionBaseResource.tsp";
import "./EnvironmentContainerResource.tsp";
import "./EnvironmentContainerResource.tsp";
import "./EnvironmentVersionResource.tsp";
import "./EnvironmentVersionResource.tsp";
import "./ModelContainerResource.tsp";
import "./ModelContainerResource.tsp";
import "./ModelVersionResource.tsp";
import "./ModelVersionResource.tsp";
import "./BatchEndpointTrackedResource.tsp";
import "./BatchDeploymentTrackedResource.tsp";
import "./DatastoreResource.tsp";
import "./FeaturesetContainer.tsp";
import "./Feature.tsp";
import "./FeaturesetVersion.tsp";
import "./FeaturestoreEntityContainer.tsp";
import "./FeaturestoreEntityVersion.tsp";
import "./JobBaseResource.tsp";
import "./LabelingJob.tsp";
import "./OnlineEndpointTrackedResource.tsp";
import "./OnlineDeploymentTrackedResource.tsp";
import "./Schedule.tsp";
import "./Registry.tsp";
import "./Workspace.tsp";
import "./WorkspaceConnectionPropertiesV2BasicResource.tsp";
import "./OutboundRuleBasicResource.tsp";
import "./PrivateEndpointConnection.tsp";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
@armProviderNamespace
@service({
  title: "Azure Machine Learning Services",
})
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v3)
@doc("These APIs allow end users to operate on Azure Machine Learning Workspace resources.")
namespace Azure.ResourceManager.MachineLearning;

@doc("The available API versions.")
enum Versions {
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  @doc("The 2023-06-01-preview API version.")
  v2023_06_01_preview: "2023-06-01-preview",
}
