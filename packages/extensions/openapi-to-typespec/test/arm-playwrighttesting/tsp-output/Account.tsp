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

namespace Microsoft.AzurePlaywrightService;
@doc("An account resource")
model Account is TrackedResource<AccountProperties> {
  @doc("Name of account")
  @maxLength(64)
  @minLength(3)
  @pattern("^[a-zA-Z]{1}[a-zA-Z0-9]{2,63}$")
  @path
  @key("name")
  @segment("accounts")
  name: string;
}

@armResourceOperations
interface Accounts {
  @doc("Get a Account")
  get is ArmResourceRead<Account>;

  @doc("Create a Account")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    Account,
    BaseParameters<Account>,
    ArmAsyncOperationHeader
  >;

  @doc("Update a Account")
  @parameterVisibility("read")
  update is ArmCustomPatchSync<Account, AccountUpdate>;

  @doc("Delete a Account")
  delete is ArmResourceDeleteAsync<
    Account,
    BaseParameters<Account>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List Account resources by resource group")
  @operationId("Accounts_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<Account>;

  @doc("List Account resources by subscription ID")
  listBySubscription is ArmListBySubscription<Account>;
}
