import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Outbound Rule Basic Resource for the managed network of a machine learning workspace.
 */
@parentResource(Workspace)
model OutboundRuleBasicResource
  is Azure.ResourceManager.ProxyResource<OutboundRule, false> {
  ...ResourceNameParameter<
    Resource = OutboundRuleBasicResource,
    KeyName = "ruleName",
    SegmentName = "outboundRules",
    NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$"
  >;
}

@armResourceOperations
interface OutboundRuleBasicResources {
  /**
   * Gets an outbound rule from the managed network of a machine learning workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ManagedNetworkSettingsRule_Get")
  get is ArmResourceRead<OutboundRuleBasicResource>;

  /**
   * Creates or updates an outbound rule in the managed network of a machine learning workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ManagedNetworkSettingsRule_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<OutboundRuleBasicResource>;

  /**
   * Deletes an outbound rule from the managed network of a machine learning workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("ManagedNetworkSettingsRule_Delete")
  delete is ArmResourceDeleteAsync<OutboundRuleBasicResource>;

  /**
   * Lists the managed network outbound rules for a machine learning workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ManagedNetworkSettingsRule_List")
  list is ArmResourceListByParent<OutboundRuleBasicResource>;
}

@@doc(OutboundRuleBasicResource.name,
  "Name of the workspace managed network outbound rule"
);
@@doc(OutboundRuleBasicResource.properties,
  "Outbound Rule for the managed network of a machine learning workspace."
);
@@encodedName(OutboundRuleBasicResources.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(OutboundRuleBasicResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(OutboundRuleBasicResources.createOrUpdate::parameters.resource,
  "Outbound Rule to be created or updated in the managed network of a machine learning workspace."
);
