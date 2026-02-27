import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AzurePlaywrightService;
/** An account resource */
model Account is Azure.ResourceManager.TrackedResource<AccountProperties> {
  ...ResourceNameParameter<
    Resource = Account,
    KeyName = "name",
    SegmentName = "accounts",
    NamePattern = "^[a-zA-Z]{1}[a-zA-Z0-9]{2,63}$"
  >;
}

@armResourceOperations
interface Accounts {
  /** Get a Account */
  get is ArmResourceRead<Account>;

  /** Create a Account */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Account>;

  /** Update a Account */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<Account, PatchModel = AccountUpdate>;

  /** Delete a Account */
  delete is ArmResourceDeleteWithoutOkAsync<
    Account,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /** List Account resources by resource group */
  listByResourceGroup is ArmResourceListByParent<Account>;

  /** List Account resources by subscription ID */
  listBySubscription is ArmListBySubscription<Account>;
}

@@maxLength(Account.name, 64);
@@minLength(Account.name, 3);
@@doc(Account.name, "Name of account");
@@doc(Account.properties,
  "The resource-specific properties for this resource."
);
