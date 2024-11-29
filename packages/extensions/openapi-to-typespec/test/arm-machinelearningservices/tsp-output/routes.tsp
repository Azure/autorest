// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;

@armResourceOperations
interface UsagesOperations {
  /**
   * Gets the current usage information as well as limits for AML resources for given subscription and location.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Usages_List")
  @get
  @action("usages")
  list is ArmProviderActionAsync<
    Response = ListUsagesResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}

@armResourceOperations
interface VirtualMachineSizesOperations {
  /**
   * Returns supported VM Sizes in a location
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineSizes_List")
  @get
  @action("vmSizes")
  list is ArmProviderActionAsync<
    Response = VirtualMachineSizeListResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}

@armResourceOperations
interface QuotasOperations {
  /**
   * Update quota for each VM family in workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Quotas_Update")
  @post
  @action("updateQuotas")
  update is ArmProviderActionAsync<
    Response = UpdateWorkspaceQuotasResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter,
    Request = QuotaUpdateParameters
  >;
  /**
   * Gets the currently assigned Workspace Quotas based on VMFamily.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Quotas_List")
  @get
  @action("quotas")
  list is ArmProviderActionAsync<
    Response = ListWorkspaceQuotas,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}

interface CodeContainersOperations {
  /**
   * List containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("List containers.")
  @operationId("CodeContainers_List")
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
  ): ArmResponse<CodeContainerResourceArmPaginatedResult> | ErrorResponse;

  /**
   * Delete container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Delete container.")
  @operationId("CodeContainers_Delete")
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
  ): OkResponse | ErrorResponse;

  /**
   * Get container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Get container.")
  @operationId("CodeContainers_Get")
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Create or update container.")
  @operationId("CodeContainers_CreateOrUpdate")
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
    @bodyRoot
    body: CodeContainerResource,
  ): ArmResponse<CodeContainerResource> | ErrorResponse;
}

interface CodeVersionsOperations {
  /**
   * List versions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("List versions.")
  @operationId("CodeVersions_List")
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
  ): ArmResponse<CodeVersionResourceArmPaginatedResult> | ErrorResponse;

  /**
   * Delete version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Delete version.")
  @operationId("CodeVersions_Delete")
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
  ): OkResponse | ErrorResponse;

  /**
   * Get version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Get version.")
  @operationId("CodeVersions_Get")
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Create or update version.")
  @operationId("CodeVersions_CreateOrUpdate")
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
    @bodyRoot
    body: CodeVersionResource,
  ): ArmResponse<CodeVersionResource> | ErrorResponse;

  /**
   * Generate a storage location and credential for the client to upload a code asset to.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Generate a storage location and credential for the client to upload a code asset to.")
  @operationId("CodeVersions_CreateOrGetStartPendingUpload")
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
    @bodyRoot
    body: PendingUploadRequestDto,
  ): ArmResponse<PendingUploadResponseDto> | ErrorResponse;
}

interface ComponentContainersOperations {
  /**
   * List component containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("List component containers.")
  @operationId("ComponentContainers_List")
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
  ): ArmResponse<ComponentContainerResourceArmPaginatedResult> | ErrorResponse;

  /**
   * Delete container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Delete container.")
  @operationId("ComponentContainers_Delete")
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
  ): OkResponse | ErrorResponse;

  /**
   * Get container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Get container.")
  @operationId("ComponentContainers_Get")
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Create or update container.")
  @operationId("ComponentContainers_CreateOrUpdate")
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
    @bodyRoot
    body: ComponentContainerResource,
  ): ArmResponse<ComponentContainerResource> | ErrorResponse;
}

interface ComponentVersionsOperations {
  /**
   * List component versions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("List component versions.")
  @operationId("ComponentVersions_List")
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
  ): ArmResponse<ComponentVersionResourceArmPaginatedResult> | ErrorResponse;

  /**
   * Delete version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Delete version.")
  @operationId("ComponentVersions_Delete")
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
  ): OkResponse | ErrorResponse;

  /**
   * Get version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Get version.")
  @operationId("ComponentVersions_Get")
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Create or update version.")
  @operationId("ComponentVersions_CreateOrUpdate")
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
    @bodyRoot
    body: ComponentVersionResource,
  ): ArmResponse<ComponentVersionResource> | ErrorResponse;
}

interface DataContainersOperations {
  /**
   * List data containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("List data containers.")
  @operationId("DataContainers_List")
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
  ): ArmResponse<DataContainerResourceArmPaginatedResult> | ErrorResponse;

  /**
   * Delete container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Delete container.")
  @operationId("DataContainers_Delete")
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
  ): OkResponse | ErrorResponse;

  /**
   * Get container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Get container.")
  @operationId("DataContainers_Get")
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Create or update container.")
  @operationId("DataContainers_CreateOrUpdate")
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
    @bodyRoot
    body: DataContainerResource,
  ): ArmResponse<DataContainerResource> | ErrorResponse;
}

interface DataVersionsOperations {
  /**
   * List data versions in the data container
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("List data versions in the data container")
  @operationId("DataVersions_List")
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
  ): ArmResponse<DataVersionBaseResourceArmPaginatedResult> | ErrorResponse;

  /**
   * Delete version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Delete version.")
  @operationId("DataVersions_Delete")
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
  ): OkResponse | ErrorResponse;

  /**
   * Get version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Get version.")
  @operationId("DataVersions_Get")
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Create or update version.")
  @operationId("DataVersions_CreateOrUpdate")
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
    @bodyRoot
    body: DataVersionBaseResource,
  ): ArmResponse<DataVersionBaseResource> | ErrorResponse;
}

interface EnvironmentContainersOperations {
  /**
   * List environment containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("List environment containers.")
  @operationId("EnvironmentContainers_List")
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
  ): ArmResponse<EnvironmentContainerResourceArmPaginatedResult> | ErrorResponse;

  /**
   * Delete container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Delete container.")
  @operationId("EnvironmentContainers_Delete")
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
  ): OkResponse | ErrorResponse;

  /**
   * Get container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Get container.")
  @operationId("EnvironmentContainers_Get")
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Create or update container.")
  @operationId("EnvironmentContainers_CreateOrUpdate")
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
    @bodyRoot
    body: EnvironmentContainerResource,
  ): ArmResponse<EnvironmentContainerResource> | ErrorResponse;
}

interface EnvironmentVersionsOperations {
  /**
   * List versions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("List versions.")
  @operationId("EnvironmentVersions_List")
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
  ): ArmResponse<EnvironmentVersionResourceArmPaginatedResult> | ErrorResponse;

  /**
   * Delete version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Delete version.")
  @operationId("EnvironmentVersions_Delete")
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
  ): OkResponse | ErrorResponse;

  /**
   * Get version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Get version.")
  @operationId("EnvironmentVersions_Get")
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Creates or updates an EnvironmentVersion.")
  @operationId("EnvironmentVersions_CreateOrUpdate")
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
    @bodyRoot
    body: EnvironmentVersionResource,
  ): ArmResponse<EnvironmentVersionResource> | ErrorResponse;
}

interface ModelContainersOperations {
  /**
   * List model containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("List model containers.")
  @operationId("ModelContainers_List")
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
  ): ArmResponse<ModelContainerResourceArmPaginatedResult> | ErrorResponse;

  /**
   * Delete container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Delete container.")
  @operationId("ModelContainers_Delete")
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
  ): OkResponse | ErrorResponse;

  /**
   * Get container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Get container.")
  @operationId("ModelContainers_Get")
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Create or update container.")
  @operationId("ModelContainers_CreateOrUpdate")
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
    @bodyRoot
    body: ModelContainerResource,
  ): ArmResponse<ModelContainerResource> | ErrorResponse;
}

interface ModelVersionsOperations {
  /**
   * List model versions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("List model versions.")
  @operationId("ModelVersions_List")
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
  ): ArmResponse<ModelVersionResourceArmPaginatedResult> | ErrorResponse;

  /**
   * Delete version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Delete version.")
  @operationId("ModelVersions_Delete")
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
  ): OkResponse | ErrorResponse;

  /**
   * Get version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Get version.")
  @operationId("ModelVersions_Get")
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Create or update version.")
  @operationId("ModelVersions_CreateOrUpdate")
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
    @bodyRoot
    body: ModelVersionResource,
  ): ArmResponse<ModelVersionResource> | ErrorResponse;

  /**
   * Model Version Package operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @summary("Model Version Package operation.")
  @operationId("ModelVersions_Package")
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
    @bodyRoot
    body: PackageRequest,
  ): ArmResponse<PackageResponse> | ArmAcceptedResponse | ErrorResponse;
}
