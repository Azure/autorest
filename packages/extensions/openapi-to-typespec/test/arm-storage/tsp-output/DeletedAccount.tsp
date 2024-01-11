import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;
@doc("Deleted storage account")
@locationResource
model DeletedAccount is ProxyResource<DeletedAccountProperties> {
  @doc("Name of the deleted storage account.")
  @maxLength(24)
  @minLength(3)
  @path
  @key("deletedAccountName")
  @segment("deletedAccounts")
  name: string;
}

@armResourceOperations
interface DeletedAccounts {
  @doc("Get properties of specified deleted account resource.")
  get is ArmResourceRead<DeletedAccount>;

  @doc("Lists deleted accounts under the subscription.")
  list is ArmListBySubscription<DeletedAccount>;
}
