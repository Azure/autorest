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

@parentResource(Workspace)
model WorkspaceConnectionPropertiesV2BasicResource
  is Azure.ResourceManager.ProxyResource<
    WorkspaceConnectionPropertiesV2,
    false
  > {
  ...ResourceNameParameter<
    Resource = WorkspaceConnectionPropertiesV2BasicResource,
    KeyName = "connectionName",
    SegmentName = "connections",
    NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$"
  >;
}

@armResourceOperations
interface WorkspaceConnectionPropertiesV2BasicResources {
  /**
   * Lists machine learning workspaces connections by name.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("WorkspaceConnections_Get")
  get is ArmResourceRead<WorkspaceConnectionPropertiesV2BasicResource>;

  /**
   * Create or update machine learning workspaces connections under the specified workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("WorkspaceConnections_Create")
  create is ArmResourceCreateOrReplaceSync<WorkspaceConnectionPropertiesV2BasicResource>;

  /**
   * Update machine learning workspaces connections under the specified workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("WorkspaceConnections_Update")
  update is ArmCustomPatchSync<
    WorkspaceConnectionPropertiesV2BasicResource,
    WorkspaceConnectionUpdateParameter
  >;

  /**
   * Delete machine learning workspaces connections by name.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("WorkspaceConnections_Delete")
  delete is ArmResourceDeleteSync<WorkspaceConnectionPropertiesV2BasicResource>;

  /**
   * Lists all the available machine learning workspaces connections under the specified workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("WorkspaceConnections_List")
  list is ArmResourceListByParent<
    WorkspaceConnectionPropertiesV2BasicResource,
    Parameters = {
      /**
       * Target of the workspace connection.
       */
      @query("target")
      target?: string;

      /**
       * Category of the workspace connection.
       */
      @query("category")
      category?: string;
    },
    Response = WorkspaceConnectionPropertiesV2BasicResourceArmPaginatedResult
  >;

  /**
   * List all the secrets of a machine learning workspaces connections.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("WorkspaceConnections_ListSecrets")
  listSecrets is ArmResourceActionSync<
    WorkspaceConnectionPropertiesV2BasicResource,
    void,
    WorkspaceConnectionPropertiesV2BasicResource
  >;
}

@@doc(WorkspaceConnectionPropertiesV2BasicResource.name,
  "Friendly name of the workspace connection"
);
@@doc(WorkspaceConnectionPropertiesV2BasicResource.properties, "");
@@doc(WorkspaceConnectionPropertiesV2BasicResources.create::parameters.resource,
  "The object for creating or updating a new workspace connection"
);
@@doc(WorkspaceConnectionPropertiesV2BasicResources.update::parameters.properties,
  "Parameters for workspace connection update."
);
