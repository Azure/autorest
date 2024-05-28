import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;
/**
 * Deleted storage account
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@subscriptionResource
@parentResource(SubscriptionLocationResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(DeletedAccountProperties)
model DeletedAccount extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = DeletedAccount,
    KeyName = "deletedAccountName",
    SegmentName = "deletedAccounts",
    NamePattern = ""
  >;

  /**
   * Properties of the deleted account.
   */
  @extension("x-ms-client-flatten", true)
  properties?: DeletedAccountProperties;
}

@armResourceOperations
interface DeletedAccounts {
  /**
   * Get properties of specified deleted account resource.
   */
  get is ArmResourceRead<DeletedAccount>;

  /**
   * Lists deleted accounts under the subscription.
   */
  list is ArmListBySubscription<DeletedAccount>;
}

@@maxLength(DeletedAccount.name, 24);
@@minLength(DeletedAccount.name, 3);
@@doc(DeletedAccount.name, "Name of the deleted storage account.");
