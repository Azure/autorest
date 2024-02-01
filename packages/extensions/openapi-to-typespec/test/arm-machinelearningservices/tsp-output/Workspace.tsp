import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * An object that represents a machine learning workspace.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(WorkspaceProperties)
model Workspace extends TrackedResourceBase {
  /**
   * Name of Azure Machine Learning workspace.
   */
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
  @path
  @key("workspaceName")
  @segment("workspaces")
  @visibility("read")
  name: string;

  kind?: string;

  /**
   * Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: WorkspaceProperties;

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
}

@armResourceOperations
interface Workspaces {
  /**
   * Gets the properties of the specified machine learning workspace.
   */
  get is ArmResourceRead<Workspace>;

  /**
   * Creates or updates a workspace with the specified parameters.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Workspace>;

  /**
   * Updates a machine learning workspace with the specified parameters.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<Workspace, WorkspaceUpdateParameters>;

  /**
   * Deletes a machine learning workspace.
   */
  delete is ArmResourceDeleteAsync<
    Workspace,
    {
      ...BaseParameters<Workspace>;

      /**
       * Flag to indicate delete is a purge request.
       */
      @query("forceToPurge")
      forceToPurge?: boolean;
    }
  >;

  /**
   * Lists all the available machine learning workspaces under the specified resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Workspaces_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<
    Workspace,
    {
      ...BaseParameters<Workspace>;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * Kind of workspace.
       */
      @query("kind")
      kind?: string;
    }
  >;

  /**
   * Lists all the available machine learning workspaces under the specified subscription.
   */
  listBySubscription is ArmListBySubscription<Workspace>;

  /**
   * Diagnose workspace setup issue.
   */
  diagnose is ArmResourceActionAsync<
    Workspace,
    DiagnoseWorkspaceParameters,
    DiagnoseResponseResult
  >;

  /**
   * Lists all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry.
   */
  listKeys is ArmResourceActionSync<Workspace, void, ListWorkspaceKeysResult>;

  /**
   * Get Azure Machine Learning Workspace notebook access token
   */
  listNotebookAccessToken is ArmResourceActionSync<
    Workspace,
    void,
    NotebookAccessTokenResult
  >;

  /**
   * Lists keys of Azure Machine Learning Workspaces notebook.
   */
  listNotebookKeys is ArmResourceActionSync<
    Workspace,
    void,
    ListNotebookKeysResult
  >;

  /**
   * Lists keys of Azure Machine Learning Workspace's storage account.
   */
  listStorageAccountKeys is ArmResourceActionSync<
    Workspace,
    void,
    ListStorageAccountKeysResult
  >;

  /**
   * Prepare Azure Machine Learning Workspace's notebook resource
   */
  prepareNotebook is ArmResourceActionAsync<
    Workspace,
    void,
    NotebookResourceInfo
  >;

  /**
   * Resync all the keys associated with this workspace.This includes keys for the storage account, app insights and password for container registry
   */
  resyncKeys is ArmResourceActionAsync<Workspace, void, void>;

  /**
   * Provisions the managed network of a machine learning workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ManagedNetworkProvisions_ProvisionManagedNetwork")
  provisionManagedNetwork is ArmResourceActionAsync<
    Workspace,
    ManagedNetworkProvisionOptions,
    ManagedNetworkProvisionStatus
  >;

  /**
   * Lists all enabled features for a workspace
   */
  // FIXME: WorkspaceFeatures_List could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("WorkspaceFeatures_List")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/features")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the target subscription.
       */
      @minLength(1)
      @path
      subscriptionId: string;

      /**
       * The name of the resource group. The name is case insensitive.
       */
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      /**
       * Name of Azure Machine Learning workspace.
       */
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
      @path
      workspaceName: string;
    },
    ListAmlUserFeatureResult
  >;

  /**
   * Called by Client (Portal, CLI, etc) to get a list of all external outbound dependencies (FQDNs) programmatically.
   */
  // FIXME: Workspaces_ListOutboundNetworkDependenciesEndpoints could not be converted to a resource operation
  @summary("Called by Client (Portal, CLI, etc) to get a list of all external outbound dependencies (FQDNs) programmatically.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/outboundNetworkDependenciesEndpoints")
  @get
  listOutboundNetworkDependenciesEndpoints is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the target subscription.
       */
      @minLength(1)
      @path
      subscriptionId: string;

      /**
       * The name of the resource group. The name is case insensitive.
       */
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      /**
       * Name of Azure Machine Learning workspace.
       */
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
      @path
      workspaceName: string;
    },
    ExternalFqdnResponse
  >;

  /**
   * Called by Client (Portal, CLI, etc) to get available "private link resources" for the workspace.
   * Each "private link resource" is a connection endpoint (IP address) to the resource.
   * Pre single connection endpoint per workspace: the Data Plane IP address, returned by DNS resolution.
   * Other RPs, such as Azure Storage, have multiple - one for Blobs, other for Queues, etc.
   * Defined in the "[NRP] Private Endpoint Design" doc, topic "GET API for GroupIds".
   */
  // FIXME: PrivateLinkResources_List could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("PrivateLinkResources_List")
  @summary("""
Called by Client (Portal, CLI, etc) to get available "private link resources" for the workspace.
Each "private link resource" is a connection endpoint (IP address) to the resource.
Pre single connection endpoint per workspace: the Data Plane IP address, returned by DNS resolution.
Other RPs, such as Azure Storage, have multiple - one for Blobs, other for Queues, etc.
Defined in the "[NRP] Private Endpoint Design" doc, topic "GET API for GroupIds".
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/privateLinkResources")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the target subscription.
       */
      @minLength(1)
      @path
      subscriptionId: string;

      /**
       * The name of the resource group. The name is case insensitive.
       */
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      /**
       * Name of Azure Machine Learning workspace.
       */
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
      @path
      workspaceName: string;
    },
    PrivateLinkResourceListResult
  >;
}

@@projectedName(Workspaces.createOrUpdate::parameters.resource, "json", "body");
@@extension(Workspaces.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(Workspaces.createOrUpdate::parameters.resource,
  "The parameters for creating or updating a machine learning workspace."
);
@@projectedName(Workspaces.update::parameters.properties, "json", "body");
@@extension(Workspaces.update::parameters.properties,
  "x-ms-client-name",
  "body"
);
@@doc(Workspaces.update::parameters.properties,
  "The parameters for updating a machine learning workspace."
);
@@doc(Workspaces.diagnose::parameters.body,
  "The parameter of diagnosing workspace health"
);
@@doc(Workspaces.provisionManagedNetwork::parameters.body,
  "Managed Network Provisioning Options for a machine learning workspace."
);
