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
@doc("Association Subresource of Traffic Controller")
@parentResource(TrafficController)
model Association is TrackedResource<AssociationProperties> {
  @doc("Name of Association")
  @pattern("^[A-Za-z0-9]([A-Za-z0-9-_.]{0,62}[A-Za-z0-9])?$")
  @key("associationName")
  @segment("associations")
  name: string;
}

@armResourceOperations
@projectedName("client", "AssociationsInterface")
interface Associations_AssociationsInterface {
  @doc("Get a Association")
  get is ArmResourceRead<Association>;

  @doc("Create a Association")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Association>;

  @doc("Update a Association")
  update is ArmCustomPatchSync<Association, AssociationUpdate>;

  @doc("Delete a Association")
  delete is ArmResourceDeleteAsync<Association>;

  @doc("List Association resources by TrafficController")
  listByTrafficController is ArmResourceListByParent<Association>;
}
