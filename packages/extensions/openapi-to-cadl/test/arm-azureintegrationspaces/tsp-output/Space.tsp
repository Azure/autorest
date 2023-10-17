import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Integration.Spaces;
@doc("An integration space.")
model Space is TrackedResource<SpaceResourceProperties> {
  @doc("The name of the space")
  @pattern("[a-zA-Z0-9_.()-]{0,79}$")
  @path
  @key("spaceName")
  @segment("spaces")
  name: string;
}

@armResourceOperations
interface Spaces {
  @doc("List Space resources by subscription ID")
  listBySubscription is ArmListBySubscription<Space>;
  @doc("List Space resources by resource group")
  listByResourceGroup is ArmResourceListByParent<Space>;
  @doc("Get a Space")
  get is ArmResourceRead<Space>;
  @doc("Create a Space")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Space>;
  @doc("Update a Space")
  patch is ArmCustomPatchSync<Space, SpaceUpdate>;
  @doc("Delete a Space")
  delete is ArmResourceDeleteAsync<Space>;
}
