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
/**
 * An account resource
 */
model Account is TrackedResource<AccountProperties> {
  /**
   * Name of account
   */
  @maxLength(64)
  @minLength(3)
  @pattern("^[a-zA-Z]{1}[a-zA-Z0-9]{2,63}$")
  @path
  @key("name")
  @segment("accounts")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface Accounts {
  /**
   * Get a Account
   */
  get is ArmResourceRead<Account>;

  /**
   * Create a Account
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Account>;

  /**
   * Update a Account
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<Account, AccountUpdate>;

  /**
   * Delete a Account
   */
  delete is ArmResourceDeleteAsync<Account>;

  /**
   * List Account resources by resource group
   */
  listByResourceGroup is ArmResourceListByParent<Account>;

  /**
   * List Account resources by subscription ID
   */
  listBySubscription is ArmListBySubscription<Account>;
}
