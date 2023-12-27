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

@parentResource(Workspace)
model WorkspaceConnectionPropertiesV2BasicResource
  is ProxyResource<WorkspaceConnectionPropertiesV2> {
  @doc("Friendly name of the workspace connection")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
  @key("connectionName")
  @segment("connections")
  name: string;
}

@armResourceOperations
interface WorkspaceConnections {
  @doc("Lists machine learning workspaces connections by name.")
  get is ArmResourceRead<WorkspaceConnectionPropertiesV2BasicResource>;
  @doc("Create or update machine learning workspaces connections under the specified workspace.")
  create is ArmResourceCreateOrReplaceSync<WorkspaceConnectionPropertiesV2BasicResource>;
  @doc("Update machine learning workspaces connections under the specified workspace.")
  update is ArmCustomPatchSync<
    WorkspaceConnectionPropertiesV2BasicResource,
    WorkspaceConnectionUpdateParameter
  >;
  @doc("Delete machine learning workspaces connections by name.")
  delete is ArmResourceDeleteSync<WorkspaceConnectionPropertiesV2BasicResource>;
  @doc("Lists all the available machine learning workspaces connections under the specified workspace.")
  list is ArmResourceListByParent<
    WorkspaceConnectionPropertiesV2BasicResource,
    {
      ...BaseParameters<WorkspaceConnectionPropertiesV2BasicResource>;

      @doc("Target of the workspace connection.")
      @query("target")
      target?: string;

      @doc("Category of the workspace connection.")
      @query("category")
      category?: string;
    }
  >;
  @doc("List all the secrets of a machine learning workspaces connections.")
  listSecrets is ArmResourceActionSync<
    WorkspaceConnectionPropertiesV2BasicResource,
    void,
    WorkspaceConnectionPropertiesV2BasicResource
  >;
}
