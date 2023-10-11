import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./SphereCatalog.tsp";
import "./SphereCertificate.tsp";
import "./SphereImage.tsp";
import "./SphereProduct.tsp";
import "./SphereDeviceGroup.tsp";
import "./SphereDeployment.tsp";
import "./SphereDevice.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
@armProviderNamespace
@service({
  title: "Azure Sphere resource management API.",
  version: "2022-09-01-preview",
})
@doc("Azure Sphere resource management API.")
@useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
@useDependency(Azure.Core.Versions.v1_0_Preview_1)
namespace Microsoft.AzureSphere;
