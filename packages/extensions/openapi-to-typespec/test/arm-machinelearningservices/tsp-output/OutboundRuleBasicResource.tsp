import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.MachineLearning;
@doc("Outbound Rule Basic Resource for the managed network of a machine learning workspace.")
@parentResource(Workspace)
model OutboundRuleBasicResource is ProxyResource<OutboundRule> {
  @doc("Name of the workspace managed network outbound rule")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
  @path
  @key("ruleName")
  @segment("outboundRules")
  name: string;
}

@armResourceOperations
interface ManagedNetworkSettingsRule {
  @doc("Gets an outbound rule from the managed network of a machine learning workspace.")
  get is ArmResourceRead<OutboundRuleBasicResource>;
  @doc("Creates or updates an outbound rule in the managed network of a machine learning workspace.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<OutboundRuleBasicResource>;
  @doc("Deletes an outbound rule from the managed network of a machine learning workspace.")
  delete is ArmResourceDeleteAsync<OutboundRuleBasicResource>;
  @doc("Lists the managed network outbound rules for a machine learning workspace.")
  list is ArmResourceListByParent<OutboundRuleBasicResource>;
}
