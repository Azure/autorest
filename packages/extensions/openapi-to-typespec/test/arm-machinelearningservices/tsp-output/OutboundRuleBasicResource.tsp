import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

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
interface OutboundRuleBasicResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets an outbound rule from the managed network of a machine learning workspace.")
  @operationId("ManagedNetworkSettingsRule_Get")
  get is ArmResourceRead<OutboundRuleBasicResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates or updates an outbound rule in the managed network of a machine learning workspace.")
  @operationId("ManagedNetworkSettingsRule_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<
    OutboundRuleBasicResource,
    BaseParameters<OutboundRuleBasicResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes an outbound rule from the managed network of a machine learning workspace.")
  @operationId("ManagedNetworkSettingsRule_Delete")
  delete is ArmResourceDeleteAsync<OutboundRuleBasicResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists the managed network outbound rules for a machine learning workspace.")
  @operationId("ManagedNetworkSettingsRule_List")
  list is ArmResourceListByParent<OutboundRuleBasicResource>;
}
