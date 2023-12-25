import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./TrafficController.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.ServiceNetworking;
@doc("Frontend Subresource of Traffic Controller.")
@parentResource(TrafficController)
model Frontend is TrackedResource<FrontendProperties> {
  @doc("Frontends")
  @pattern("^[A-Za-z0-9]([A-Za-z0-9-_.]{0,62}[A-Za-z0-9])?$")
  @path
  @key("frontendName")
  @segment("frontends")
  name: string;
}

@armResourceOperations
interface FrontendsInterface {
  @doc("Get a Frontend")
  get is ArmResourceRead<Frontend>;
  @doc("Create a Frontend")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Frontend>;
  @doc("Update a Frontend")
  update is ArmCustomPatchSync<Frontend, FrontendUpdate>;
  @doc("Delete a Frontend")
  delete is ArmResourceDeleteAsync<Frontend>;
  @doc("List Frontend resources by TrafficController")
  listByTrafficController is ArmResourceListByParent<Frontend>;
}
