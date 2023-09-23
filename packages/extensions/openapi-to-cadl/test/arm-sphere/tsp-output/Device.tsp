import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

@parentResource("DeviceGroup")
model Device is ProxyResource<DeviceProperties> {
  @doc("Device name")
  @key("deviceName")
  @pattern("^[a-zA-Z0-9-]{128}$")
  @path
  name: string;
}
