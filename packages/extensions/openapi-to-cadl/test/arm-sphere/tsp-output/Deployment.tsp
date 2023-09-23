import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

@parentResource("DeviceGroup")
model Deployment is ProxyResource<DeploymentProperties> {
  @doc("""
Deployment name. Use .default for deployment creation and to get the current
deployment for the associated device group.
""")
  @key("deploymentName")
  @path
  name: string;
}
