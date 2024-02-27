// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.MachineLearning;

interface UsagesOperations {
  /**
   * Gets the current usage information as well as limits for AML resources for given subscription and location.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/usages")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...LocationResourceParameter,
  ): ArmResponse<ListUsagesResult> | ErrorResponse;
}

interface VirtualMachineSizesOperations {
  /**
   * Returns supported VM Sizes in a location
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/vmSizes")
  @get
  list(
    ...ApiVersionParameter,
    ...LocationResourceParameter,
    ...SubscriptionIdParameter,
  ): ArmResponse<VirtualMachineSizeListResult> | ErrorResponse;
}

interface QuotasOperations {
  /**
   * Update quota for each VM family in workspace.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/updateQuotas")
  @post
  update(
    ...ApiVersionParameter,
    ...LocationResourceParameter,
    ...SubscriptionIdParameter,

    /**
     * Quota update parameters.
     */
    @body
    parameters: QuotaUpdateParameters,
  ): ArmResponse<UpdateWorkspaceQuotasResult> | ErrorResponse;

  /**
   * Gets the currently assigned Workspace Quotas based on VMFamily.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/quotas")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...LocationResourceParameter,
  ): ArmResponse<ListWorkspaceQuotas> | ErrorResponse;
}

interface CodeContainersOperations {
  /**
   * List containers.
   */
  @summary("List containers.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Continuation token for pagination.
     */
    @query("$skip")
    $skip?: string,
  ): ArmResponse<ResourceListResult<CodeContainerResource>> | ErrorResponse;

  /**
   * Delete container.
   */
  @summary("Delete container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}")
  @delete
  delete(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @path
    name: string,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Get container.
   */
  @summary("Get container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}")
  @get
  get(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @path
    name: string,
  ): ArmResponse<CodeContainerResource> | ErrorResponse;

  /**
   * Create or update container.
   */
  @summary("Create or update container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}")
  @put
  createOrUpdate(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
    @path
    name: string,

    /**
     * Container entity to create or update.
     */
    @body
    body: CodeContainerResource,
  ): ArmResponse<CodeContainerResource> | ErrorResponse;
}

interface CodeVersionsOperations {
  /**
   * List versions.
   */
  @summary("List versions.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}/versions")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @path
    name: string,

    /**
     * Ordering of list.
     */
    @query("$orderBy")
    $orderBy?: string,

    /**
     * Maximum number of records to return.
     */
    @query("$top")
    $top?: int32,

    /**
     * Continuation token for pagination.
     */
    @query("$skip")
    $skip?: string,

    /**
     * If specified, return CodeVersion assets with specified content hash value, regardless of name
     */
    @query("hash")
    hash?: string,

    /**
     * Hash algorithm version when listing by hash
     */
    @query("hashVersion")
    hashVersion?: string,
  ): ArmResponse<ResourceListResult<CodeVersionResource>> | ErrorResponse;

  /**
   * Delete version.
   */
  @summary("Delete version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}/versions/{version}")
  @delete
  delete(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @path
    name: string,

    /**
     * Version identifier. This is case-sensitive.
     */
    @path
    version: string,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Get version.
   */
  @summary("Get version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}/versions/{version}")
  @get
  get(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @path
    name: string,

    /**
     * Version identifier. This is case-sensitive.
     */
    @path
    version: string,
  ): ArmResponse<CodeVersionResource> | ErrorResponse;

  /**
   * Create or update version.
   */
  @summary("Create or update version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}/versions/{version}")
  @put
  createOrUpdate(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
    @path
    name: string,

    /**
     * Version identifier. This is case-sensitive.
     */
    @path
    version: string,

    /**
     * Version entity to create or update.
     */
    @body
    body: CodeVersionResource,
  ): ArmResponse<CodeVersionResource> | ErrorResponse;

  /**
   * Generate a storage location and credential for the client to upload a code asset to.
   */
  @summary("Generate a storage location and credential for the client to upload a code asset to.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}/versions/{version}/startPendingUpload")
  @post
  createOrGetStartPendingUpload(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @path
    name: string,

    /**
     * Version identifier. This is case-sensitive.
     */
    @path
    version: string,

    /**
     * Pending upload request object
     */
    @body
    body: PendingUploadRequestDto,
  ): ArmResponse<PendingUploadResponseDto> | ErrorResponse;
}

interface ComponentContainersOperations {
  /**
   * List component containers.
   */
  @summary("List component containers.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Continuation token for pagination.
     */
    @query("$skip")
    $skip?: string,

    /**
     * View type for including/excluding (for example) archived entities.
     */
    @query("listViewType")
    listViewType?: ListViewType,
  ): ArmResponse<ResourceListResult<ComponentContainerResource>> | ErrorResponse;

  /**
   * Delete container.
   */
  @summary("Delete container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}")
  @delete
  delete(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name.
     */
    @path
    name: string,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Get container.
   */
  @summary("Get container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}")
  @get
  get(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name.
     */
    @path
    name: string,
  ): ArmResponse<ComponentContainerResource> | ErrorResponse;

  /**
   * Create or update container.
   */
  @summary("Create or update container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}")
  @put
  createOrUpdate(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
    @path
    name: string,

    /**
     * Container entity to create or update.
     */
    @body
    body: ComponentContainerResource,
  ): ArmResponse<ComponentContainerResource> | ErrorResponse;
}

interface ComponentVersionsOperations {
  /**
   * List component versions.
   */
  @summary("List component versions.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}/versions")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Component name.
     */
    @path
    name: string,

    /**
     * Ordering of list.
     */
    @query("$orderBy")
    $orderBy?: string,

    /**
     * Maximum number of records to return.
     */
    @query("$top")
    $top?: int32,

    /**
     * Continuation token for pagination.
     */
    @query("$skip")
    $skip?: string,

    /**
     * View type for including/excluding (for example) archived entities.
     */
    @query("listViewType")
    listViewType?: ListViewType,

    /**
     * Component stage.
     */
    @query("stage")
    stage?: string,
  ): ArmResponse<ResourceListResult<ComponentVersionResource>> | ErrorResponse;

  /**
   * Delete version.
   */
  @summary("Delete version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}/versions/{version}")
  @delete
  delete(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name.
     */
    @path
    name: string,

    /**
     * Version identifier.
     */
    @path
    version: string,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Get version.
   */
  @summary("Get version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}/versions/{version}")
  @get
  get(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name.
     */
    @path
    name: string,

    /**
     * Version identifier.
     */
    @path
    version: string,
  ): ArmResponse<ComponentVersionResource> | ErrorResponse;

  /**
   * Create or update version.
   */
  @summary("Create or update version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}/versions/{version}")
  @put
  createOrUpdate(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
    @path
    name: string,

    /**
     * Version identifier.
     */
    @path
    version: string,

    /**
     * Version entity to create or update.
     */
    @body
    body: ComponentVersionResource,
  ): ArmResponse<ComponentVersionResource> | ErrorResponse;
}

interface DataContainersOperations {
  /**
   * List data containers.
   */
  @summary("List data containers.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Continuation token for pagination.
     */
    @query("$skip")
    $skip?: string,

    /**
     * View type for including/excluding (for example) archived entities.
     */
    @query("listViewType")
    listViewType?: ListViewType,
  ): ArmResponse<ResourceListResult<DataContainerResource>> | ErrorResponse;

  /**
   * Delete container.
   */
  @summary("Delete container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}")
  @delete
  delete(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name.
     */
    @path
    name: string,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Get container.
   */
  @summary("Get container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}")
  @get
  get(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name.
     */
    @path
    name: string,
  ): ArmResponse<DataContainerResource> | ErrorResponse;

  /**
   * Create or update container.
   */
  @summary("Create or update container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}")
  @put
  createOrUpdate(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
    @path
    name: string,

    /**
     * Container entity to create or update.
     */
    @body
    body: DataContainerResource,
  ): ArmResponse<DataContainerResource> | ErrorResponse;
}

interface DataVersionsOperations {
  /**
   * List data versions in the data container
   */
  @summary("List data versions in the data container")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}/versions")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Data container's name
     */
    @path
    name: string,

    /**
     * Please choose OrderBy value from ['createdtime', 'modifiedtime']
     */
    @query("$orderBy")
    $orderBy?: string,

    /**
     * Top count of results, top count cannot be greater than the page size.
     *                               If topCount > page size, results with be default page size count will be returned
     */
    @query("$top")
    $top?: int32,

    /**
     * Continuation token for pagination.
     */
    @query("$skip")
    $skip?: string,

    /**
     * Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2
     */
    @query("$tags")
    $tags?: string,

    /**
     * [ListViewType.ActiveOnly, ListViewType.ArchivedOnly, ListViewType.All]View type for including/excluding (for example) archived entities.
     */
    @query("listViewType")
    listViewType?: ListViewType,

    /**
     * data stage
     */
    @query("stage")
    stage?: string,
  ): ArmResponse<ResourceListResult<DataVersionBaseResource>> | ErrorResponse;

  /**
   * Delete version.
   */
  @summary("Delete version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}/versions/{version}")
  @delete
  delete(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name.
     */
    @path
    name: string,

    /**
     * Version identifier.
     */
    @path
    version: string,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Get version.
   */
  @summary("Get version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}/versions/{version}")
  @get
  get(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name.
     */
    @path
    name: string,

    /**
     * Version identifier.
     */
    @path
    version: string,
  ): ArmResponse<DataVersionBaseResource> | ErrorResponse;

  /**
   * Create or update version.
   */
  @summary("Create or update version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}/versions/{version}")
  @put
  createOrUpdate(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
    @path
    name: string,

    /**
     * Version identifier.
     */
    @path
    version: string,

    /**
     * Version entity to create or update.
     */
    @body
    body: DataVersionBaseResource,
  ): ArmResponse<DataVersionBaseResource> | ErrorResponse;
}

interface EnvironmentContainersOperations {
  /**
   * List environment containers.
   */
  @summary("List environment containers.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Continuation token for pagination.
     */
    @query("$skip")
    $skip?: string,

    /**
     * View type for including/excluding (for example) archived entities.
     */
    @query("listViewType")
    listViewType?: ListViewType,
  ): ArmResponse<ResourceListResult<EnvironmentContainerResource>> | ErrorResponse;

  /**
   * Delete container.
   */
  @summary("Delete container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}")
  @delete
  delete(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @path
    name: string,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Get container.
   */
  @summary("Get container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}")
  @get
  get(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @path
    name: string,
  ): ArmResponse<EnvironmentContainerResource> | ErrorResponse;

  /**
   * Create or update container.
   */
  @summary("Create or update container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}")
  @put
  createOrUpdate(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
    @path
    name: string,

    /**
     * Container entity to create or update.
     */
    @body
    body: EnvironmentContainerResource,
  ): ArmResponse<EnvironmentContainerResource> | ErrorResponse;
}

interface EnvironmentVersionsOperations {
  /**
   * List versions.
   */
  @summary("List versions.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}/versions")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @path
    name: string,

    /**
     * Ordering of list.
     */
    @query("$orderBy")
    $orderBy?: string,

    /**
     * Maximum number of records to return.
     */
    @query("$top")
    $top?: int32,

    /**
     * Continuation token for pagination.
     */
    @query("$skip")
    $skip?: string,

    /**
     * View type for including/excluding (for example) archived entities.
     */
    @query("listViewType")
    listViewType?: ListViewType,

    /**
     * Stage for including/excluding (for example) archived entities. Takes priority over listViewType
     */
    @query("stage")
    stage?: string,
  ): ArmResponse<ResourceListResult<EnvironmentVersionResource>> | ErrorResponse;

  /**
   * Delete version.
   */
  @summary("Delete version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}/versions/{version}")
  @delete
  delete(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @path
    name: string,

    /**
     * Version identifier. This is case-sensitive.
     */
    @path
    version: string,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Get version.
   */
  @summary("Get version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}/versions/{version}")
  @get
  get(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @path
    name: string,

    /**
     * Version identifier. This is case-sensitive.
     */
    @path
    version: string,
  ): ArmResponse<EnvironmentVersionResource> | ErrorResponse;

  /**
   * Creates or updates an EnvironmentVersion.
   */
  @summary("Creates or updates an EnvironmentVersion.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}/versions/{version}")
  @put
  createOrUpdate(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Name of EnvironmentVersion. This is case-sensitive.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
    @path
    name: string,

    /**
     * Version of EnvironmentVersion.
     */
    @path
    version: string,

    /**
     * Definition of EnvironmentVersion.
     */
    @body
    body: EnvironmentVersionResource,
  ): ArmResponse<EnvironmentVersionResource> | ErrorResponse;
}

interface ModelContainersOperations {
  /**
   * List model containers.
   */
  @summary("List model containers.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Continuation token for pagination.
     */
    @query("$skip")
    $skip?: string,

    /**
     * Maximum number of results to return.
     */
    @query("count")
    count?: int32,

    /**
     * View type for including/excluding (for example) archived entities.
     */
    @query("listViewType")
    listViewType?: ListViewType,
  ): ArmResponse<ResourceListResult<ModelContainerResource>> | ErrorResponse;

  /**
   * Delete container.
   */
  @summary("Delete container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}")
  @delete
  delete(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @path
    name: string,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Get container.
   */
  @summary("Get container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}")
  @get
  get(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @path
    name: string,
  ): ArmResponse<ModelContainerResource> | ErrorResponse;

  /**
   * Create or update container.
   */
  @summary("Create or update container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}")
  @put
  createOrUpdate(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
    @path
    name: string,

    /**
     * Container entity to create or update.
     */
    @body
    body: ModelContainerResource,
  ): ArmResponse<ModelContainerResource> | ErrorResponse;
}

interface ModelVersionsOperations {
  /**
   * List model versions.
   */
  @summary("List model versions.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}/versions")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Model name. This is case-sensitive.
     */
    @path
    name: string,

    /**
     * Continuation token for pagination.
     */
    @query("$skip")
    $skip?: string,

    /**
     * Ordering of list.
     */
    @query("$orderBy")
    $orderBy?: string,

    /**
     * Maximum number of records to return.
     */
    @query("$top")
    $top?: int32,

    /**
     * Model version.
     */
    @query("version")
    version?: string,

    /**
     * Model description.
     */
    @query("description")
    description?: string,

    /**
     * Number of initial results to skip.
     */
    @query("offset")
    offset?: int32,

    /**
     * Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2
     */
    @query("tags")
    tags?: string,

    /**
     * Comma-separated list of property names (and optionally values). Example: prop1,prop2=value2
     */
    @query("properties")
    properties?: string,

    /**
     * Name of the feed.
     */
    @query("feed")
    feed?: string,

    /**
     * View type for including/excluding (for example) archived entities.
     */
    @query("listViewType")
    listViewType?: ListViewType,

    /**
     * Model stage
     */
    @query("stage")
    stage?: string,
  ): ArmResponse<ResourceListResult<ModelVersionResource>> | ErrorResponse;

  /**
   * Delete version.
   */
  @summary("Delete version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}/versions/{version}")
  @delete
  delete(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @path
    name: string,

    /**
     * Version identifier. This is case-sensitive.
     */
    @path
    version: string,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Get version.
   */
  @summary("Get version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}/versions/{version}")
  @get
  get(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @path
    name: string,

    /**
     * Version identifier. This is case-sensitive.
     */
    @path
    version: string,
  ): ArmResponse<ModelVersionResource> | ErrorResponse;

  /**
   * Create or update version.
   */
  @summary("Create or update version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}/versions/{version}")
  @put
  createOrUpdate(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
    @path
    name: string,

    /**
     * Version identifier. This is case-sensitive.
     */
    @path
    version: string,

    /**
     * Version entity to create or update.
     */
    @body
    body: ModelVersionResource,
  ): ArmResponse<ModelVersionResource> | ErrorResponse;

  /**
   * Model Version Package operation.
   */
  @summary("Model Version Package operation.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}/versions/{version}/package")
  @post
  package(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Container name. This is case-sensitive.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
    @path
    name: string,

    /**
     * Version identifier. This is case-sensitive.
     */
    @path
    version: string,

    /**
     * Package operation request body.
     */
    @body
    body: PackageRequest,
  ): ArmResponse<PackageResponse | void> | ErrorResponse;
}
