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
@doc("An device resource belonging to a device group resource.")
@parentResource(DeviceGroup)
model Device is ProxyResource<DeviceProperties> {
  @doc("Device name")
  @pattern("^[a-zA-Z0-9-]{128}$")
  @path
  @key("deviceName")
  @segment("devices")
  deviceName: string;
}
