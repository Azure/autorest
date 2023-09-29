import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./DeviceGroup.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.AzureSphere;
@doc("An deployment resource belonging to a device group resource.")
@parentResource(DeviceGroup)
model Deployment is ProxyResource<DeploymentProperties> {
  @doc("""
Deployment name. Use .default for deployment creation and to get the current
deployment for the associated device group.
""")
  @path
  @key("deploymentName")
  @segment("deployments")
  deploymentName: string;
}
