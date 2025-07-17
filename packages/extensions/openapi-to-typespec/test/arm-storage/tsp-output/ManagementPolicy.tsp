import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./StorageAccount.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;
/**
 * The Get Storage Account ManagementPolicies operation response.
 */
@parentResource(StorageAccount)
model ManagementPolicy
  is Azure.ResourceManager.ProxyResource<ManagementPolicyProperties> {
  ...ResourceNameParameter<
    Resource = ManagementPolicy,
    KeyName = "managementPolicyName",
    SegmentName = "managementPolicies",
    NamePattern = "",
    Type = ManagementPolicyName
  >;
}

@armResourceOperations
interface ManagementPolicies {
  /**
   * Gets the managementpolicy associated with the specified storage account.
   */
  get is ArmResourceRead<ManagementPolicy>;

  /**
   * Sets the managementpolicy to the specified storage account.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ManagementPolicy,
    Response = ArmResourceUpdatedResponse<ManagementPolicy>
  >;

  /**
   * Deletes the managementpolicy associated with the specified storage account.
   */
  delete is ArmResourceDeleteSync<ManagementPolicy>;
}

@@doc(ManagementPolicy.name,
  "The name of the Storage Account Management Policy. It should always be 'default'"
);
@@doc(ManagementPolicy.properties,
  "Returns the Storage Account Data Policies Rules."
);
@@doc(ManagementPolicies.createOrUpdate::parameters.resource,
  "The ManagementPolicy set to a storage account."
);
