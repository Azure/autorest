import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.MachineLearning;

interface UsagesOperations {
  @doc("Gets the current usage information as well as limits for AML resources for given subscription and location.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/usages")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @minLength(1)
      @path
      subscriptionId: string;

      @doc("The location for which resource usage is queried.")
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;
    },
    ListUsagesResult
  >;
}

interface VirtualMachineSizesOperations {
  @doc("Returns supported VM Sizes in a location")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/vmSizes")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The location upon which virtual-machine-sizes is queried.")
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;

      @doc("The ID of the target subscription.")
      @minLength(1)
      @path
      subscriptionId: string;
    },
    VirtualMachineSizeListResult
  >;
}

interface QuotasOperations {
  @doc("Update quota for each VM family in workspace.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/updateQuotas")
  @post
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The location for update quota is queried.")
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;

      @doc("The ID of the target subscription.")
      @minLength(1)
      @path
      subscriptionId: string;

      @doc("Quota update parameters.")
      @body
      parameters: QuotaUpdateParameters;
    },
    UpdateWorkspaceQuotasResult
  >;

  @doc("Gets the currently assigned Workspace Quotas based on VMFamily.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/quotas")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @minLength(1)
      @path
      subscriptionId: string;

      @doc("The location for which resource usage is queried.")
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;
    },
    ListWorkspaceQuotas
  >;
}

interface CodeContainersOperations {
  @summary("List containers.")
  @doc("List containers.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes")
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

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;
    },
    ResourceListResult<CodeContainerResource>
  >;

  @summary("Delete container.")
  @doc("Delete container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @path
      name: string;
    },
    void
  >;

  @summary("Get container.")
  @doc("Get container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}")
  @get
  Get is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @path
      name: string;
    },
    CodeContainerResource
  >;

  @summary("Create or update container.")
  @doc("Create or update container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      @doc("Container entity to create or update.")
      @body
      body: CodeContainerResource;
    },
    CodeContainerResource
  >;
}

interface CodeVersionsOperations {
  @summary("List versions.")
  @doc("List versions.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}/versions")
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

      @doc("Container name. This is case-sensitive.")
      @path
      name: string;

      @doc("Ordering of list.")
      @query("$orderBy")
      $orderBy?: string;

      @doc("Maximum number of records to return.")
      @query("$top")
      $top?: int32;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("If specified, return CodeVersion assets with specified content hash value, regardless of name")
      @query("hash")
      hash?: string;

      @doc("Hash algorithm version when listing by hash")
      @query("hashVersion")
      hashVersion?: string;
    },
    ResourceListResult<CodeVersionResource>
  >;

  @summary("Delete version.")
  @doc("Delete version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}/versions/{version}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @path
      name: string;

      @doc("Version identifier. This is case-sensitive.")
      @path
      version: string;
    },
    void
  >;

  @summary("Get version.")
  @doc("Get version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}/versions/{version}")
  @get
  Get is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @path
      name: string;

      @doc("Version identifier. This is case-sensitive.")
      @path
      version: string;
    },
    CodeVersionResource
  >;

  @summary("Create or update version.")
  @doc("Create or update version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}/versions/{version}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      @doc("Version identifier. This is case-sensitive.")
      @path
      version: string;

      @doc("Version entity to create or update.")
      @body
      body: CodeVersionResource;
    },
    CodeVersionResource
  >;

  @summary("Generate a storage location and credential for the client to upload a code asset to.")
  @doc("Generate a storage location and credential for the client to upload a code asset to.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/codes/{name}/versions/{version}/startPendingUpload")
  @post
  CreateOrGetStartPendingUpload is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @path
      name: string;

      @doc("Version identifier. This is case-sensitive.")
      @path
      version: string;

      @doc("Pending upload request object")
      @body
      body: PendingUploadRequestDto;
    },
    PendingUploadResponseDto
  >;
}

interface ComponentContainersOperations {
  @summary("List component containers.")
  @doc("List component containers.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components")
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

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;
    },
    ResourceListResult<ComponentContainerResource>
  >;

  @summary("Delete container.")
  @doc("Delete container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
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

      @doc("Container name.")
      @path
      name: string;
    },
    void
  >;

  @summary("Get container.")
  @doc("Get container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}")
  @get
  Get is Azure.Core.Foundations.Operation<
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

      @doc("Container name.")
      @path
      name: string;
    },
    ComponentContainerResource
  >;

  @summary("Create or update container.")
  @doc("Create or update container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
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

      @doc("Container name.")
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      @doc("Container entity to create or update.")
      @body
      body: ComponentContainerResource;
    },
    ComponentContainerResource
  >;
}

interface ComponentVersionsOperations {
  @summary("List component versions.")
  @doc("List component versions.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}/versions")
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

      @doc("Component name.")
      @path
      name: string;

      @doc("Ordering of list.")
      @query("$orderBy")
      $orderBy?: string;

      @doc("Maximum number of records to return.")
      @query("$top")
      $top?: int32;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;

      @doc("Component stage.")
      @query("stage")
      stage?: string;
    },
    ResourceListResult<ComponentVersionResource>
  >;

  @summary("Delete version.")
  @doc("Delete version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}/versions/{version}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
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

      @doc("Container name.")
      @path
      name: string;

      @doc("Version identifier.")
      @path
      version: string;
    },
    void
  >;

  @summary("Get version.")
  @doc("Get version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}/versions/{version}")
  @get
  Get is Azure.Core.Foundations.Operation<
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

      @doc("Container name.")
      @path
      name: string;

      @doc("Version identifier.")
      @path
      version: string;
    },
    ComponentVersionResource
  >;

  @summary("Create or update version.")
  @doc("Create or update version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/components/{name}/versions/{version}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
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

      @doc("Container name.")
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      @doc("Version identifier.")
      @path
      version: string;

      @doc("Version entity to create or update.")
      @body
      body: ComponentVersionResource;
    },
    ComponentVersionResource
  >;
}

interface DataContainersOperations {
  @summary("List data containers.")
  @doc("List data containers.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data")
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

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;
    },
    ResourceListResult<DataContainerResource>
  >;

  @summary("Delete container.")
  @doc("Delete container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
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

      @doc("Container name.")
      @path
      name: string;
    },
    void
  >;

  @summary("Get container.")
  @doc("Get container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}")
  @get
  Get is Azure.Core.Foundations.Operation<
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

      @doc("Container name.")
      @path
      name: string;
    },
    DataContainerResource
  >;

  @summary("Create or update container.")
  @doc("Create or update container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
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

      @doc("Container name.")
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      @doc("Container entity to create or update.")
      @body
      body: DataContainerResource;
    },
    DataContainerResource
  >;
}

interface DataVersionsOperations {
  @summary("List data versions in the data container")
  @doc("List data versions in the data container")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}/versions")
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

      @doc("Data container's name")
      @path
      name: string;

      @doc("Please choose OrderBy value from ['createdtime', 'modifiedtime']")
      @query("$orderBy")
      $orderBy?: string;

      @doc("""
Top count of results, top count cannot be greater than the page size.
                              If topCount > page size, results with be default page size count will be returned
""")
      @query("$top")
      $top?: int32;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2")
      @query("$tags")
      $tags?: string;

      @doc("[ListViewType.ActiveOnly, ListViewType.ArchivedOnly, ListViewType.All]View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;

      @doc("data stage")
      @query("stage")
      stage?: string;
    },
    ResourceListResult<DataVersionBaseResource>
  >;

  @summary("Delete version.")
  @doc("Delete version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}/versions/{version}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
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

      @doc("Container name.")
      @path
      name: string;

      @doc("Version identifier.")
      @path
      version: string;
    },
    void
  >;

  @summary("Get version.")
  @doc("Get version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}/versions/{version}")
  @get
  Get is Azure.Core.Foundations.Operation<
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

      @doc("Container name.")
      @path
      name: string;

      @doc("Version identifier.")
      @path
      version: string;
    },
    DataVersionBaseResource
  >;

  @summary("Create or update version.")
  @doc("Create or update version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/data/{name}/versions/{version}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
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

      @doc("Container name.")
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      @doc("Version identifier.")
      @path
      version: string;

      @doc("Version entity to create or update.")
      @body
      body: DataVersionBaseResource;
    },
    DataVersionBaseResource
  >;
}

interface EnvironmentContainersOperations {
  @summary("List environment containers.")
  @doc("List environment containers.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments")
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

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;
    },
    ResourceListResult<EnvironmentContainerResource>
  >;

  @summary("Delete container.")
  @doc("Delete container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @path
      name: string;
    },
    void
  >;

  @summary("Get container.")
  @doc("Get container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}")
  @get
  Get is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @path
      name: string;
    },
    EnvironmentContainerResource
  >;

  @summary("Create or update container.")
  @doc("Create or update container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      @doc("Container entity to create or update.")
      @body
      body: EnvironmentContainerResource;
    },
    EnvironmentContainerResource
  >;
}

interface EnvironmentVersionsOperations {
  @summary("List versions.")
  @doc("List versions.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}/versions")
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

      @doc("Container name. This is case-sensitive.")
      @path
      name: string;

      @doc("Ordering of list.")
      @query("$orderBy")
      $orderBy?: string;

      @doc("Maximum number of records to return.")
      @query("$top")
      $top?: int32;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;

      @doc("Stage for including/excluding (for example) archived entities. Takes priority over listViewType")
      @query("stage")
      stage?: string;
    },
    ResourceListResult<EnvironmentVersionResource>
  >;

  @summary("Delete version.")
  @doc("Delete version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}/versions/{version}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @path
      name: string;

      @doc("Version identifier. This is case-sensitive.")
      @path
      version: string;
    },
    void
  >;

  @summary("Get version.")
  @doc("Get version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}/versions/{version}")
  @get
  Get is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @path
      name: string;

      @doc("Version identifier. This is case-sensitive.")
      @path
      version: string;
    },
    EnvironmentVersionResource
  >;

  @summary("Creates or updates an EnvironmentVersion.")
  @doc("Creates or updates an EnvironmentVersion.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/environments/{name}/versions/{version}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
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

      @doc("Name of EnvironmentVersion. This is case-sensitive.")
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      @doc("Version of EnvironmentVersion.")
      @path
      version: string;

      @doc("Definition of EnvironmentVersion.")
      @body
      body: EnvironmentVersionResource;
    },
    EnvironmentVersionResource
  >;
}

interface ModelContainersOperations {
  @summary("List model containers.")
  @doc("List model containers.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models")
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

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("Maximum number of results to return.")
      @query("count")
      count?: int32;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;
    },
    ResourceListResult<ModelContainerResource>
  >;

  @summary("Delete container.")
  @doc("Delete container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @path
      name: string;
    },
    void
  >;

  @summary("Get container.")
  @doc("Get container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}")
  @get
  Get is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @path
      name: string;
    },
    ModelContainerResource
  >;

  @summary("Create or update container.")
  @doc("Create or update container.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      @doc("Container entity to create or update.")
      @body
      body: ModelContainerResource;
    },
    ModelContainerResource
  >;
}

interface ModelVersionsOperations {
  @summary("List model versions.")
  @doc("List model versions.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}/versions")
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

      @doc("Model name. This is case-sensitive.")
      @path
      name: string;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("Ordering of list.")
      @query("$orderBy")
      $orderBy?: string;

      @doc("Maximum number of records to return.")
      @query("$top")
      $top?: int32;

      @doc("Model version.")
      @query("version")
      version?: string;

      @doc("Model description.")
      @query("description")
      description?: string;

      @doc("Number of initial results to skip.")
      @query("offset")
      offset?: int32;

      @doc("Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2")
      @query("tags")
      tags?: string;

      @doc("Comma-separated list of property names (and optionally values). Example: prop1,prop2=value2")
      @query("properties")
      properties?: string;

      @doc("Name of the feed.")
      @query("feed")
      feed?: string;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;

      @doc("Model stage")
      @query("stage")
      stage?: string;
    },
    ResourceListResult<ModelVersionResource>
  >;

  @summary("Delete version.")
  @doc("Delete version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}/versions/{version}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @path
      name: string;

      @doc("Version identifier. This is case-sensitive.")
      @path
      version: string;
    },
    void
  >;

  @summary("Get version.")
  @doc("Get version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}/versions/{version}")
  @get
  Get is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @path
      name: string;

      @doc("Version identifier. This is case-sensitive.")
      @path
      version: string;
    },
    ModelVersionResource
  >;

  @summary("Create or update version.")
  @doc("Create or update version.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}/versions/{version}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      @doc("Version identifier. This is case-sensitive.")
      @path
      version: string;

      @doc("Version entity to create or update.")
      @body
      body: ModelVersionResource;
    },
    ModelVersionResource
  >;

  @summary("Model Version Package operation.")
  @doc("Model Version Package operation.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/models/{name}/versions/{version}/package")
  @post
  Package is Azure.Core.Foundations.Operation<
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

      @doc("Container name. This is case-sensitive.")
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
      @path
      name: string;

      @doc("Version identifier. This is case-sensitive.")
      @path
      version: string;

      @doc("Package operation request body.")
      @body
      body: PackageRequest;
    },
    PackageResponse | void
  >;
}
