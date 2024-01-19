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
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the target subscription.
       */
      @minLength(1)
      @path
      subscriptionId: string;

      /**
       * The location for which resource usage is queried.
       */
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;
    },
    ListUsagesResult
  >;
}

interface VirtualMachineSizesOperations {
  /**
   * Returns supported VM Sizes in a location
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/vmSizes")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The location upon which virtual-machine-sizes is queried.
       */
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;

      /**
       * The ID of the target subscription.
       */
      @minLength(1)
      @path
      subscriptionId: string;
    },
    VirtualMachineSizeListResult
  >;
}

interface QuotasOperations {
  /**
   * Update quota for each VM family in workspace.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/updateQuotas")
  @post
  update is Azure.Core.Foundations.Operation<
    {
      /**
       * The location for update quota is queried.
       */
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;

      /**
       * The ID of the target subscription.
       */
      @minLength(1)
      @path
      subscriptionId: string;

      /**
       * Quota update parameters.
       */
      @body
      parameters: QuotaUpdateParameters;
    },
    UpdateWorkspaceQuotasResult
  >;

  /**
   * Gets the currently assigned Workspace Quotas based on VMFamily.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/quotas")
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
       * The location for which resource usage is queried.
       */
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;
    },
    ListWorkspaceQuotas
  >;
}

interface CodeContainersOperations {
  /**
   * List containers.
   */
  @summary("List containers.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes")
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

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;
    },
    ResourceListResult<CodeContainerResource>
  >;

  /**
   * Delete container.
   */
  @summary("Delete container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}")
  @delete
  delete is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @path
      name: string;
    },
    void
  >;

  /**
   * Get container.
   */
  @summary("Get container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}")
  @get
  get is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @path
      name: string;
    },
    CodeContainerResource
  >;

  /**
   * Create or update container.
   */
  @summary("Create or update container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      /**
       * Container entity to create or update.
       */
      @body
      body: CodeContainerResource;
    },
    CodeContainerResource
  >;
}

interface CodeVersionsOperations {
  /**
   * List versions.
   */
  @summary("List versions.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}/versions")
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

      /**
       * Container name. This is case-sensitive.
       */
      @path
      name: string;

      /**
       * Ordering of list.
       */
      @query("$orderBy")
      $orderBy?: string;

      /**
       * Maximum number of records to return.
       */
      @query("$top")
      $top?: int32;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * If specified, return CodeVersion assets with specified content hash value, regardless of name
       */
      @query("hash")
      hash?: string;

      /**
       * Hash algorithm version when listing by hash
       */
      @query("hashVersion")
      hashVersion?: string;
    },
    ResourceListResult<CodeVersionResource>
  >;

  /**
   * Delete version.
   */
  @summary("Delete version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}/versions/{version}")
  @delete
  delete is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @path
      name: string;

      /**
       * Version identifier. This is case-sensitive.
       */
      @path
      version: string;
    },
    void
  >;

  /**
   * Get version.
   */
  @summary("Get version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}/versions/{version}")
  @get
  get is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @path
      name: string;

      /**
       * Version identifier. This is case-sensitive.
       */
      @path
      version: string;
    },
    CodeVersionResource
  >;

  /**
   * Create or update version.
   */
  @summary("Create or update version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}/versions/{version}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      /**
       * Version identifier. This is case-sensitive.
       */
      @path
      version: string;

      /**
       * Version entity to create or update.
       */
      @body
      body: CodeVersionResource;
    },
    CodeVersionResource
  >;

  /**
   * Generate a storage location and credential for the client to upload a code asset to.
   */
  @summary("Generate a storage location and credential for the client to upload a code asset to.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}/versions/{version}/startPendingUpload")
  @post
  createOrGetStartPendingUpload is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @path
      name: string;

      /**
       * Version identifier. This is case-sensitive.
       */
      @path
      version: string;

      /**
       * Pending upload request object
       */
      @body
      body: PendingUploadRequestDto;
    },
    PendingUploadResponseDto
  >;
}

interface ComponentContainersOperations {
  /**
   * List component containers.
   */
  @summary("List component containers.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components")
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

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;
    },
    ResourceListResult<ComponentContainerResource>
  >;

  /**
   * Delete container.
   */
  @summary("Delete container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}")
  @delete
  delete is Azure.Core.Foundations.Operation<
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

      /**
       * Container name.
       */
      @path
      name: string;
    },
    void
  >;

  /**
   * Get container.
   */
  @summary("Get container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}")
  @get
  get is Azure.Core.Foundations.Operation<
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

      /**
       * Container name.
       */
      @path
      name: string;
    },
    ComponentContainerResource
  >;

  /**
   * Create or update container.
   */
  @summary("Create or update container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
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

      /**
       * Container name.
       */
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      /**
       * Container entity to create or update.
       */
      @body
      body: ComponentContainerResource;
    },
    ComponentContainerResource
  >;
}

interface ComponentVersionsOperations {
  /**
   * List component versions.
   */
  @summary("List component versions.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}/versions")
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

      /**
       * Component name.
       */
      @path
      name: string;

      /**
       * Ordering of list.
       */
      @query("$orderBy")
      $orderBy?: string;

      /**
       * Maximum number of records to return.
       */
      @query("$top")
      $top?: int32;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;

      /**
       * Component stage.
       */
      @query("stage")
      stage?: string;
    },
    ResourceListResult<ComponentVersionResource>
  >;

  /**
   * Delete version.
   */
  @summary("Delete version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}/versions/{version}")
  @delete
  delete is Azure.Core.Foundations.Operation<
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

      /**
       * Container name.
       */
      @path
      name: string;

      /**
       * Version identifier.
       */
      @path
      version: string;
    },
    void
  >;

  /**
   * Get version.
   */
  @summary("Get version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}/versions/{version}")
  @get
  get is Azure.Core.Foundations.Operation<
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

      /**
       * Container name.
       */
      @path
      name: string;

      /**
       * Version identifier.
       */
      @path
      version: string;
    },
    ComponentVersionResource
  >;

  /**
   * Create or update version.
   */
  @summary("Create or update version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}/versions/{version}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
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

      /**
       * Container name.
       */
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      /**
       * Version identifier.
       */
      @path
      version: string;

      /**
       * Version entity to create or update.
       */
      @body
      body: ComponentVersionResource;
    },
    ComponentVersionResource
  >;
}

interface DataContainersOperations {
  /**
   * List data containers.
   */
  @summary("List data containers.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data")
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

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;
    },
    ResourceListResult<DataContainerResource>
  >;

  /**
   * Delete container.
   */
  @summary("Delete container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}")
  @delete
  delete is Azure.Core.Foundations.Operation<
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

      /**
       * Container name.
       */
      @path
      name: string;
    },
    void
  >;

  /**
   * Get container.
   */
  @summary("Get container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}")
  @get
  get is Azure.Core.Foundations.Operation<
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

      /**
       * Container name.
       */
      @path
      name: string;
    },
    DataContainerResource
  >;

  /**
   * Create or update container.
   */
  @summary("Create or update container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
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

      /**
       * Container name.
       */
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      /**
       * Container entity to create or update.
       */
      @body
      body: DataContainerResource;
    },
    DataContainerResource
  >;
}

interface DataVersionsOperations {
  /**
   * List data versions in the data container
   */
  @summary("List data versions in the data container")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}/versions")
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

      /**
       * Data container's name
       */
      @path
      name: string;

      /**
       * Please choose OrderBy value from ['createdtime', 'modifiedtime']
       */
      @query("$orderBy")
      $orderBy?: string;

      /**
* Top count of results, top count cannot be greater than the page size.
                              If topCount > page size, results with be default page size count will be returned
*/
      @query("$top")
      $top?: int32;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2
       */
      @query("$tags")
      $tags?: string;

      /**
       * [ListViewType.ActiveOnly, ListViewType.ArchivedOnly, ListViewType.All]View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;

      /**
       * data stage
       */
      @query("stage")
      stage?: string;
    },
    ResourceListResult<DataVersionBaseResource>
  >;

  /**
   * Delete version.
   */
  @summary("Delete version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}/versions/{version}")
  @delete
  delete is Azure.Core.Foundations.Operation<
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

      /**
       * Container name.
       */
      @path
      name: string;

      /**
       * Version identifier.
       */
      @path
      version: string;
    },
    void
  >;

  /**
   * Get version.
   */
  @summary("Get version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}/versions/{version}")
  @get
  get is Azure.Core.Foundations.Operation<
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

      /**
       * Container name.
       */
      @path
      name: string;

      /**
       * Version identifier.
       */
      @path
      version: string;
    },
    DataVersionBaseResource
  >;

  /**
   * Create or update version.
   */
  @summary("Create or update version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}/versions/{version}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
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

      /**
       * Container name.
       */
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      /**
       * Version identifier.
       */
      @path
      version: string;

      /**
       * Version entity to create or update.
       */
      @body
      body: DataVersionBaseResource;
    },
    DataVersionBaseResource
  >;
}

interface EnvironmentContainersOperations {
  /**
   * List environment containers.
   */
  @summary("List environment containers.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments")
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

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;
    },
    ResourceListResult<EnvironmentContainerResource>
  >;

  /**
   * Delete container.
   */
  @summary("Delete container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}")
  @delete
  delete is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @path
      name: string;
    },
    void
  >;

  /**
   * Get container.
   */
  @summary("Get container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}")
  @get
  get is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @path
      name: string;
    },
    EnvironmentContainerResource
  >;

  /**
   * Create or update container.
   */
  @summary("Create or update container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      /**
       * Container entity to create or update.
       */
      @body
      body: EnvironmentContainerResource;
    },
    EnvironmentContainerResource
  >;
}

interface EnvironmentVersionsOperations {
  /**
   * List versions.
   */
  @summary("List versions.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}/versions")
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

      /**
       * Container name. This is case-sensitive.
       */
      @path
      name: string;

      /**
       * Ordering of list.
       */
      @query("$orderBy")
      $orderBy?: string;

      /**
       * Maximum number of records to return.
       */
      @query("$top")
      $top?: int32;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;

      /**
       * Stage for including/excluding (for example) archived entities. Takes priority over listViewType
       */
      @query("stage")
      stage?: string;
    },
    ResourceListResult<EnvironmentVersionResource>
  >;

  /**
   * Delete version.
   */
  @summary("Delete version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}/versions/{version}")
  @delete
  delete is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @path
      name: string;

      /**
       * Version identifier. This is case-sensitive.
       */
      @path
      version: string;
    },
    void
  >;

  /**
   * Get version.
   */
  @summary("Get version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}/versions/{version}")
  @get
  get is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @path
      name: string;

      /**
       * Version identifier. This is case-sensitive.
       */
      @path
      version: string;
    },
    EnvironmentVersionResource
  >;

  /**
   * Creates or updates an EnvironmentVersion.
   */
  @summary("Creates or updates an EnvironmentVersion.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}/versions/{version}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
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

      /**
       * Name of EnvironmentVersion. This is case-sensitive.
       */
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      /**
       * Version of EnvironmentVersion.
       */
      @path
      version: string;

      /**
       * Definition of EnvironmentVersion.
       */
      @body
      body: EnvironmentVersionResource;
    },
    EnvironmentVersionResource
  >;
}

interface ModelContainersOperations {
  /**
   * List model containers.
   */
  @summary("List model containers.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models")
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

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * Maximum number of results to return.
       */
      @query("count")
      count?: int32;

      /**
       * View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;
    },
    ResourceListResult<ModelContainerResource>
  >;

  /**
   * Delete container.
   */
  @summary("Delete container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}")
  @delete
  delete is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @path
      name: string;
    },
    void
  >;

  /**
   * Get container.
   */
  @summary("Get container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}")
  @get
  get is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @path
      name: string;
    },
    ModelContainerResource
  >;

  /**
   * Create or update container.
   */
  @summary("Create or update container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      /**
       * Container entity to create or update.
       */
      @body
      body: ModelContainerResource;
    },
    ModelContainerResource
  >;
}

interface ModelVersionsOperations {
  /**
   * List model versions.
   */
  @summary("List model versions.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}/versions")
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

      /**
       * Model name. This is case-sensitive.
       */
      @path
      name: string;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * Ordering of list.
       */
      @query("$orderBy")
      $orderBy?: string;

      /**
       * Maximum number of records to return.
       */
      @query("$top")
      $top?: int32;

      /**
       * Model version.
       */
      @query("version")
      version?: string;

      /**
       * Model description.
       */
      @query("description")
      description?: string;

      /**
       * Number of initial results to skip.
       */
      @query("offset")
      offset?: int32;

      /**
       * Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2
       */
      @query("tags")
      tags?: string;

      /**
       * Comma-separated list of property names (and optionally values). Example: prop1,prop2=value2
       */
      @query("properties")
      properties?: string;

      /**
       * Name of the feed.
       */
      @query("feed")
      feed?: string;

      /**
       * View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;

      /**
       * Model stage
       */
      @query("stage")
      stage?: string;
    },
    ResourceListResult<ModelVersionResource>
  >;

  /**
   * Delete version.
   */
  @summary("Delete version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}/versions/{version}")
  @delete
  delete is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @path
      name: string;

      /**
       * Version identifier. This is case-sensitive.
       */
      @path
      version: string;
    },
    void
  >;

  /**
   * Get version.
   */
  @summary("Get version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}/versions/{version}")
  @get
  get is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @path
      name: string;

      /**
       * Version identifier. This is case-sensitive.
       */
      @path
      version: string;
    },
    ModelVersionResource
  >;

  /**
   * Create or update version.
   */
  @summary("Create or update version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}/versions/{version}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      /**
       * Version identifier. This is case-sensitive.
       */
      @path
      version: string;

      /**
       * Version entity to create or update.
       */
      @body
      body: ModelVersionResource;
    },
    ModelVersionResource
  >;

  /**
   * Model Version Package operation.
   */
  @summary("Model Version Package operation.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}/versions/{version}/package")
  @post
  package is Azure.Core.Foundations.Operation<
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

      /**
       * Container name. This is case-sensitive.
       */
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      /**
       * Version identifier. This is case-sensitive.
       */
      @path
      version: string;

      /**
       * Package operation request body.
       */
      @body
      body: PackageRequest;
    },
    PackageResponse | void
  >;
}
