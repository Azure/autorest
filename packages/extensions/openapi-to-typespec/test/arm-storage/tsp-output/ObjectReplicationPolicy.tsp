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
@parentResource(StorageAccount)
model ObjectReplicationPolicy
  is Azure.ResourceManager.ProxyResource<ObjectReplicationPolicyProperties> {
  ...ResourceNameParameter<
    Resource = ObjectReplicationPolicy,
    KeyName = "objectReplicationPolicyId",
    SegmentName = "objectReplicationPolicies",
    NamePattern = ""
  >;
}

@armResourceOperations
interface ObjectReplicationPolicyOperationGroup {
  /**
   * Get the object replication policy of the storage account by policy ID.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ObjectReplicationPolicies_Get")
  get is ArmResourceRead<ObjectReplicationPolicy>;

  /**
   * Create or update the object replication policy of the storage account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  @operationId("ObjectReplicationPolicies_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ObjectReplicationPolicy,
    Response = ArmResourceUpdatedResponse<ObjectReplicationPolicy>
  >;

  /**
   * Deletes the object replication policy associated with the specified storage account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ObjectReplicationPolicies_Delete")
  delete is ArmResourceDeleteSync<ObjectReplicationPolicy>;

  /**
   * List the object replication policies associated with the storage account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ObjectReplicationPolicies_List")
  list is ArmResourceListByParent<
    ObjectReplicationPolicy,
    Response = ArmResponse<ObjectReplicationPolicies>
  >;
}

@@minLength(ObjectReplicationPolicy.name, 1);
@@doc(ObjectReplicationPolicy.name,
  "For the destination account, provide the value 'default'. Configure the policy on the destination account first. For the source account, provide the value of the policy ID that is returned when you download the policy that was defined on the destination account. The policy is downloaded as a JSON file."
);
@@doc(ObjectReplicationPolicy.properties,
  "Returns the Storage Account Object Replication Policy."
);
@@doc(ObjectReplicationPolicyOperationGroup.createOrUpdate::parameters.resource,
  "The object replication policy set to a storage account. A unique policy ID will be created if absent."
);
