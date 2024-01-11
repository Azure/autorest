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
@doc("The replication policy between two storage accounts. Multiple rules can be defined in one policy.")
@parentResource(StorageAccount)
model ObjectReplicationPolicy
  is ProxyResource<ObjectReplicationPolicyProperties> {
  @doc("For the destination account, provide the value 'default'. Configure the policy on the destination account first. For the source account, provide the value of the policy ID that is returned when you download the policy that was defined on the destination account. The policy is downloaded as a JSON file.")
  @minLength(1)
  @path
  @key("objectReplicationPolicyId")
  @segment("objectReplicationPolicies")
  name: string;
}

@armResourceOperations
interface ObjectReplicationPolicies {
  @doc("Get the object replication policy of the storage account by policy ID.")
  get is ArmResourceRead<ObjectReplicationPolicy>;

  @doc("Create or update the object replication policy of the storage account.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<ObjectReplicationPolicy>;

  @doc("Deletes the object replication policy associated with the specified storage account.")
  delete is ArmResourceDeleteSync<ObjectReplicationPolicy>;

  @doc("List the object replication policies associated with the storage account.")
  list is ArmResourceListByParent<ObjectReplicationPolicy>;
}
