import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./DeviceGroup.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Sphere;
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
  name: string;
}

@armResourceOperations
interface Deployments {
  @doc("""
Get a Deployment. '.default' and '.unassigned' are system defined values and
cannot be used for product or device group name.
""")
  get is ArmResourceRead<Deployment>;
  @doc("""
Create a Deployment. '.default' and '.unassigned' are system defined values and
cannot be used for product or device group name.
""")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Deployment>;
  @doc("""
Delete a Deployment. '.default' and '.unassigned' are system defined values and
cannot be used for product or device group name.
""")
  delete is ArmResourceDeleteAsync<Deployment>;
  @doc("""
List Deployment resources by DeviceGroup. '.default' and '.unassigned' are
system defined values and cannot be used for product or device group name.
""")
  listByDeviceGroup is ArmResourceListByParent<
    Deployment,
    {
      @doc("Filter the result list using the given expression")
      @query("$filter")
      filter?: string;

      @doc("The number of result items to return.")
      @query("$top")
      top?: int32;

      @doc("The number of result items to skip.")
      @query("$skip")
      skip?: int32;

      @doc("The maximum number of result items per page.")
      @query("$maxpagesize")
      maxpagesize?: int32;
    }
  >;
}
