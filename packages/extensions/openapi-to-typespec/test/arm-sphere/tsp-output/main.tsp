import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./Catalog.tsp";
import "./Certificate.tsp";
import "./Image.tsp";
import "./Product.tsp";
import "./DeviceGroup.tsp";
import "./Deployment.tsp";
import "./Device.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
@armProviderNamespace
@service({
  title: "Azure Sphere resource management API.",
})
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v3)
@doc("Azure Sphere resource management API.")
namespace Microsoft.AzureSphere;

@doc("The available API versions.")
enum Versions {
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2022_09_01_preview: "2022-09-01-preview",
}
