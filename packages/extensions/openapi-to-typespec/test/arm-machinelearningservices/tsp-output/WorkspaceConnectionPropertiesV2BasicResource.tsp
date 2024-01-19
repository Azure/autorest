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

@parentResource(Workspace)
model WorkspaceConnectionPropertiesV2BasicResource
  is ProxyResource<WorkspaceConnectionPropertiesV2> {
  /**
   * Friendly name of the workspace connection
   */
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
  @path
  @key("connectionName")
  @segment("connections")
  name: string;
}

@armResourceOperations
interface WorkspaceConnectionPropertiesV2BasicResources {
  /**
   * Lists machine learning workspaces connections by name.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("WorkspaceConnections_Get")
  get is ArmResourceRead<WorkspaceConnectionPropertiesV2BasicResource>;

  /**
   * Create or update machine learning workspaces connections under the specified workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("WorkspaceConnections_Create")
  create is ArmResourceCreateOrReplaceSync<WorkspaceConnectionPropertiesV2BasicResource>;

  /**
   * Update machine learning workspaces connections under the specified workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility("read")
  @operationId("WorkspaceConnections_Update")
  update is ArmCustomPatchSync<
    WorkspaceConnectionPropertiesV2BasicResource,
    WorkspaceConnectionUpdateParameter
  >;

  /**
   * Delete machine learning workspaces connections by name.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("WorkspaceConnections_Delete")
  delete is ArmResourceDeleteSync<WorkspaceConnectionPropertiesV2BasicResource>;

  /**
   * Lists all the available machine learning workspaces connections under the specified workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("WorkspaceConnections_List")
  list is ArmResourceListByParent<
    WorkspaceConnectionPropertiesV2BasicResource,
    {
      ...BaseParameters<WorkspaceConnectionPropertiesV2BasicResource>;

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
    }
  >;

  /**
   * List all the secrets of a machine learning workspaces connections.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("WorkspaceConnections_ListSecrets")
  listSecrets is ArmResourceActionSync<
    WorkspaceConnectionPropertiesV2BasicResource,
    void,
    WorkspaceConnectionPropertiesV2BasicResource
  >;
}

@@projectedName(WorkspaceConnectionPropertiesV2BasicResources.create::parameters.resource,
  "json",
  "body"
);
@@extension(WorkspaceConnectionPropertiesV2BasicResources.create::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(WorkspaceConnectionPropertiesV2BasicResources.create::parameters.resource,
  "The object for creating or updating a new workspace connection"
);
@@projectedName(WorkspaceConnectionPropertiesV2BasicResources.update::parameters.properties,
  "json",
  "body"
);
@@extension(WorkspaceConnectionPropertiesV2BasicResources.update::parameters.properties,
  "x-ms-client-name",
  "body"
);
@@doc(WorkspaceConnectionPropertiesV2BasicResources.update::parameters.properties,
  "Parameters for workspace connection update."
);
