import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.MachineLearning;

model Registry is TrackedResource<RegistryProperties> {
  @doc("Name of Azure Machine Learning registry. This is case-insensitive")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{2,32}$")
  @key("registryName")
  @segment("registries")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
  ...Azure.ResourceManager.ResourceKind;
}

@armResourceOperations
interface Registries {
  @doc("Get registry")
  get is ArmResourceRead<Registry>;
  @doc("Create or update registry")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Registry>;
  @doc("Update tags")
  update is ArmCustomPatchSync<Registry, PartialRegistryPartialTrackedResource>;
  @doc("Delete registry")
  delete is ArmResourceDeleteAsync<Registry>;
  @doc("List registries")
  list is ArmResourceListByParent<Registry>;
  @doc("List registries by subscription")
  listBySubscription is ArmListBySubscription<Registry>;
  @doc("Remove regions from registry")
  removeRegions is ArmResourceActionAsync<Registry, Registry, Registry>;
}
