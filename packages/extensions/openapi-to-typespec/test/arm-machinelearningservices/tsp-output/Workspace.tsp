import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * An object that represents a machine learning workspace.
 */
model Workspace
  is Azure.ResourceManager.TrackedResource<WorkspaceProperties, false> {
  ...ResourceNameParameter<
    Resource = Workspace,
    KeyName = "workspaceName",
    SegmentName = "workspaces",
    NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$"
  >;
  ...Azure.ResourceManager.ManagedServiceIdentityProperty;
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  kind?: string;
  ...Azure.ResourceManager.ResourceSkuProperty;
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  @operationId("Workspaces_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    Workspace,
    Response = ArmResourceUpdatedResponse<Workspace> | ArmAcceptedLroResponse,
    LroHeaders = ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * Updates a machine learning workspace with the specified parameters.
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    Workspace,
    PatchModel = WorkspaceUpdateParameters
  >;

  /**
   * Deletes a machine learning workspace.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    Workspace,
    Parameters = {
      /**
       * Flag to indicate delete is a purge request.
       */
      @query("forceToPurge")
      forceToPurge?: boolean;
    },
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * Lists all the available machine learning workspaces under the specified resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Workspaces_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<
    Workspace,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Workspaces_ListBySubscription")
  listBySubscription is ArmListBySubscription<
    Workspace,
    Parameters = {
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
   * Lists all enabled features for a workspace
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("WorkspaceFeatures_List")
  @get
  @action("features")
  list is ArmResourceActionSync<
    Workspace,
    void,
    ArmResponse<ListAmlUserFeatureResult>
  >;

  /**
   * Diagnose workspace setup issue.
   */
  diagnose is ArmResourceActionAsync<
    Workspace,
    DiagnoseWorkspaceParameters,
    ArmResponse<DiagnoseResponseResult>,
    OptionalRequestBody = true
  >;

  /**
   * Lists all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Workspaces_ListKeys")
  listKeys is ArmResourceActionSync<
    Workspace,
    void,
    ArmResponse<ListWorkspaceKeysResult>
  >;

  /**
   * Get Azure Machine Learning Workspace notebook access token
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Workspaces_ListNotebookAccessToken")
  listNotebookAccessToken is ArmResourceActionSync<
    Workspace,
    void,
    ArmResponse<NotebookAccessTokenResult>
  >;

  /**
   * Lists keys of Azure Machine Learning Workspaces notebook.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Workspaces_ListNotebookKeys")
  listNotebookKeys is ArmResourceActionSync<
    Workspace,
    void,
    ArmResponse<ListNotebookKeysResult>
  >;

  /**
   * Lists keys of Azure Machine Learning Workspace's storage account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Workspaces_ListStorageAccountKeys")
  listStorageAccountKeys is ArmResourceActionSync<
    Workspace,
    void,
    ArmResponse<ListStorageAccountKeysResult>
  >;

  /**
   * Called by Client (Portal, CLI, etc) to get a list of all external outbound dependencies (FQDNs) programmatically.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Workspaces_ListOutboundNetworkDependenciesEndpoints")
  @get
  @action("outboundNetworkDependenciesEndpoints")
  listOutboundNetworkDependenciesEndpoints is ArmResourceActionSync<
    Workspace,
    void,
    ArmResponse<ExternalFqdnResponse>
  >;

  /**
   * Prepare Azure Machine Learning Workspace's notebook resource
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Workspaces_PrepareNotebook")
  prepareNotebook is ArmResourceActionAsync<
    Workspace,
    void,
    ArmResponse<NotebookResourceInfo>
  >;

  /**
   * Resync all the keys associated with this workspace.This includes keys for the storage account, app insights and password for container registry
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Workspaces_ResyncKeys")
  resyncKeys is ArmResourceActionAsync<Workspace, void, OkResponse>;

  /**
   * Called by Client (Portal, CLI, etc) to get available "private link resources" for the workspace.
   * Each "private link resource" is a connection endpoint (IP address) to the resource.
   * Pre single connection endpoint per workspace: the Data Plane IP address, returned by DNS resolution.
   * Other RPs, such as Azure Storage, have multiple - one for Blobs, other for Queues, etc.
   * Defined in the "[NRP] Private Endpoint Design" doc, topic "GET API for GroupIds".
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("PrivateLinkResources_List")
  @get
  @action("privateLinkResources")
  privateLinkResourcesList is ArmResourceActionSync<
    Workspace,
    void,
    ArmResponse<PrivateLinkResourceListResult>
  >;

  /**
   * Provisions the managed network of a machine learning workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ManagedNetworkProvisions_ProvisionManagedNetwork")
  provisionManagedNetwork is ArmResourceActionAsync<
    Workspace,
    ManagedNetworkProvisionOptions,
    ArmResponse<ManagedNetworkProvisionStatus>,
    OptionalRequestBody = true
  >;
}

@@doc(Workspace.name, "Name of Azure Machine Learning workspace.");
@@doc(Workspace.properties, "Additional attributes of the entity.");
@@doc(Workspaces.createOrUpdate::parameters.resource,
  "The parameters for creating or updating a machine learning workspace."
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
