import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./Space.tsp";
import "./Application.tsp";
import "./BusinessProcess.tsp";
import "./BusinessProcessVersion.tsp";
import "./InfrastructureResource.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
@armProviderNamespace
@service({
  title: "Azure Integration Spaces resource management API.",
  version: "2023-11-14-preview",
})
@doc("The azure integration spaces resource provider.")
@useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
@useDependency(Azure.Core.Versions.v1_0_Preview_1)
namespace Azure.ResourceManager.Integration.Spaces;
