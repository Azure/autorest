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
 * The replication policy between two storage accounts. Multiple rules can be defined in one policy.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(StorageAccount)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  ObjectReplicationPolicyProperties
)
model ObjectReplicationPolicy extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = ObjectReplicationPolicy,
    KeyName = "objectReplicationPolicyId",
    SegmentName = "objectReplicationPolicies",
    NamePattern = ""
  >;

  /**
   * Returns the Storage Account Object Replication Policy.
   */
  @extension("x-ms-client-flatten", true)
  properties?: ObjectReplicationPolicyProperties;
}

@armResourceOperations
interface ObjectReplicationPolicies {
  /**
   * Get the object replication policy of the storage account by policy ID.
   */
  get is ArmResourceRead<ObjectReplicationPolicy>;

  /**
   * Create or update the object replication policy of the storage account.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<ObjectReplicationPolicy>;

  /**
   * Deletes the object replication policy associated with the specified storage account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<ObjectReplicationPolicy>;

  /**
   * List the object replication policies associated with the storage account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ObjectReplicationPolicies_List")
  list is ArmResourceListByParent<ObjectReplicationPolicy>;
}

@@minLength(ObjectReplicationPolicy.name, 1);
@@doc(ObjectReplicationPolicy.name,
  "For the destination account, provide the value 'default'. Configure the policy on the destination account first. For the source account, provide the value of the policy ID that is returned when you download the policy that was defined on the destination account. The policy is downloaded as a JSON file."
);
@@encodedName(ObjectReplicationPolicies.createOrUpdate::parameters.resource,
  "application/json",
  "properties"
);
@@extension(ObjectReplicationPolicies.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "properties"
);
@@doc(ObjectReplicationPolicies.createOrUpdate::parameters.resource,
  "The object replication policy set to a storage account. A unique policy ID will be created if absent."
);
