import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./StorageAccount.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;
@doc("The storage account blob inventory policy.")
@singleton("default")
@parentResource(StorageAccount)
model BlobInventoryPolicy is ProxyResource<BlobInventoryPolicyProperties> {
  @key("inventoryPolicy")
  @segment("inventoryPolicies")
  name: string;
}

@armResourceOperations
interface BlobInventoryPolicies {
  @doc("Gets the blob inventory policy associated with the specified storage account.")
  get is ArmResourceRead<BlobInventoryPolicy>;

  @doc("Sets the blob inventory policy to the specified storage account.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<BlobInventoryPolicy>;

  @doc("Deletes the blob inventory policy associated with the specified storage account.")
  delete is ArmResourceDeleteSync<BlobInventoryPolicy>;

  @doc("Gets the blob inventory policy associated with the specified storage account.")
  list is ArmResourceListByParent<BlobInventoryPolicy>;
}
