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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@singleton("default")
@parentResource(StorageAccount)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(ManagementPolicyProperties)
model ManagementPolicy extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = ManagementPolicy,
    KeyName = "managementPolicy",
    SegmentName = "managementPolicies",
    NamePattern = ""
  >;

  /**
   * Returns the Storage Account Data Policies Rules.
   */
  @extension("x-ms-client-flatten", true)
  properties?: ManagementPolicyProperties;
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
  createOrUpdate is ArmResourceCreateOrReplaceSync<ManagementPolicy>;

  /**
   * Deletes the managementpolicy associated with the specified storage account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<ManagementPolicy>;
}

@@doc(ManagementPolicy.name, "");
@@encodedName(ManagementPolicies.createOrUpdate::parameters.resource,
  "application/json",
  "properties"
);
@@extension(ManagementPolicies.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "properties"
);
@@doc(ManagementPolicies.createOrUpdate::parameters.resource,
  "The ManagementPolicy set to a storage account."
);
