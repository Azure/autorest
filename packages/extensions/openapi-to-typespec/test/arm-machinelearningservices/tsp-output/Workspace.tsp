import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.MachineLearning;
@doc("An object that represents a machine learning workspace.")
model Workspace is TrackedResource<WorkspaceProperties> {
  @doc("Name of Azure Machine Learning workspace.")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
  @key("workspaceName")
  @segment("workspaces")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
  ...Azure.ResourceManager.ResourceKind;
}

@armResourceOperations
interface Workspaces {
  @doc("Gets the properties of the specified machine learning workspace.")
  get is ArmResourceRead<Workspace>;

  @doc("Creates or updates a workspace with the specified parameters.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Workspace>;

  @doc("Updates a machine learning workspace with the specified parameters.")
  update is ArmCustomPatchAsync<Workspace, WorkspaceUpdateParameters>;

  @doc("Deletes a machine learning workspace.")
  delete is ArmResourceDeleteAsync<
    Workspace,
    {
      ...BaseParameters<Workspace>;

      @doc("Flag to indicate delete is a purge request.")
      @query("forceToPurge")
      forceToPurge?: boolean;
    }
  >;

  @doc("Lists all the available machine learning workspaces under the specified resource group.")
  listByResourceGroup is ArmResourceListByParent<
    Workspace,
    {
      ...BaseParameters<Workspace>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("Kind of workspace.")
      @query("kind")
      kind?: string;
    }
  >;

  @doc("Lists all the available machine learning workspaces under the specified subscription.")
  listBySubscription is ArmListBySubscription<Workspace>;

  @doc("Diagnose workspace setup issue.")
  diagnose is ArmResourceActionAsync<
    Workspace,
    DiagnoseWorkspaceParameters,
    DiagnoseResponseResult
  >;

  @doc("Lists all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry.")
  listKeys is ArmResourceActionSync<Workspace, void, ListWorkspaceKeysResult>;

  @doc("Get Azure Machine Learning Workspace notebook access token")
  listNotebookAccessToken is ArmResourceActionSync<
    Workspace,
    void,
    NotebookAccessTokenResult
  >;

  @doc("Lists keys of Azure Machine Learning Workspaces notebook.")
  listNotebookKeys is ArmResourceActionSync<
    Workspace,
    void,
    ListNotebookKeysResult
  >;

  @doc("Lists keys of Azure Machine Learning Workspace's storage account.")
  listStorageAccountKeys is ArmResourceActionSync<
    Workspace,
    void,
    ListStorageAccountKeysResult
  >;

  @doc("Prepare Azure Machine Learning Workspace's notebook resource")
  prepareNotebook is ArmResourceActionAsync<
    Workspace,
    void,
    NotebookResourceInfo
  >;

  @doc("Resync all the keys associated with this workspace.This includes keys for the storage account, app insights and password for container registry")
  resyncKeys is ArmResourceActionAsync<Workspace, void, void>;

  @summary("Called by Client (Portal, CLI, etc) to get a list of all external outbound dependencies (FQDNs) programmatically.")
  @doc("Called by Client (Portal, CLI, etc) to get a list of all external outbound dependencies (FQDNs) programmatically.")
  // FIXME: Workspaces_ListOutboundNetworkDependenciesEndpoints could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/outboundNetworkDependenciesEndpoints")
  @get
  ListOutboundNetworkDependenciesEndpoints is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @minLength(1)
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      @doc("Name of Azure Machine Learning workspace.")
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
      @path
      workspaceName: string;
    },
    ExternalFqdnResponse
  >;
}

@armResourceOperations
@projectedName("client", "ManagedNetworkProvisions")
interface Workspaces_ManagedNetworkProvisions {
  @doc("Provisions the managed network of a machine learning workspace.")
  provisionManagedNetwork is ArmResourceActionAsync<
    Workspace,
    ManagedNetworkProvisionOptions,
    ManagedNetworkProvisionStatus
  >;
}

@armResourceOperations
@projectedName("client", "WorkspaceFeatures")
interface Workspaces_WorkspaceFeatures {
  @doc("Lists all enabled features for a workspace")
  // FIXME: WorkspaceFeatures_List could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/features")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @minLength(1)
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      @doc("Name of Azure Machine Learning workspace.")
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
      @path
      workspaceName: string;
    },
    ListAmlUserFeatureResult
  >;
}

@armResourceOperations
@projectedName("client", "PrivateLinkResources")
interface Workspaces_PrivateLinkResources {
  @summary("""
Called by Client (Portal, CLI, etc) to get available "private link resources" for the workspace.
Each "private link resource" is a connection endpoint (IP address) to the resource.
Pre single connection endpoint per workspace: the Data Plane IP address, returned by DNS resolution.
Other RPs, such as Azure Storage, have multiple - one for Blobs, other for Queues, etc.
Defined in the "[NRP] Private Endpoint Design" doc, topic "GET API for GroupIds".
""")
  @doc("""
Called by Client (Portal, CLI, etc) to get available \"private link resources\" for the workspace.
Each \"private link resource\" is a connection endpoint (IP address) to the resource.
Pre single connection endpoint per workspace: the Data Plane IP address, returned by DNS resolution.
Other RPs, such as Azure Storage, have multiple - one for Blobs, other for Queues, etc.
Defined in the \"[NRP] Private Endpoint Design\" doc, topic \"GET API for GroupIds\".
""")
  // FIXME: PrivateLinkResources_List could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/privateLinkResources")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @minLength(1)
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      @doc("Name of Azure Machine Learning workspace.")
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
      @path
      workspaceName: string;
    },
    PrivateLinkResourceListResult
  >;
}
