import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Factory.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.DataFactory;
/**
 * Integration runtime resource type.
 */
@parentResource(Factory)
model IntegrationRuntimeResource
  is Azure.ResourceManager.ProxyResource<IntegrationRuntime, false> {
  ...ResourceNameParameter<
    Resource = IntegrationRuntimeResource,
    KeyName = "integrationRuntimeName",
    SegmentName = "integrationRuntimes",
    NamePattern = "^[A-Za-z0-9]+(?:-[A-Za-z0-9]+)*$"
  >;
  ...Azure.ResourceManager.Legacy.EntityTagProperty;
}

@armResourceOperations
interface IntegrationRuntimeResources {
  /**
   * Gets an integration runtime.
   */
  get is ArmResourceRead<
    IntegrationRuntimeResource,
    Parameters = {
      /**
       * ETag of the integration runtime entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
       */
      @header
      `If-None-Match`?: string;
    }
  >;

  /**
   * Creates or updates an integration runtime.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    IntegrationRuntimeResource,
    Parameters = {
      /**
       * ETag of the integration runtime entity. Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
       */
      @header
      `If-Match`?: string;
    },
    Response = ArmResourceUpdatedResponse<IntegrationRuntimeResource>
  >;

  /**
   * Updates an integration runtime.
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    IntegrationRuntimeResource,
    PatchModel = UpdateIntegrationRuntimeRequest
  >;

  /**
   * Deletes an integration runtime.
   */
  delete is ArmResourceDeleteSync<IntegrationRuntimeResource>;

  /**
   * Lists integration runtimes.
   */
  listByFactory is ArmResourceListByParent<
    IntegrationRuntimeResource,
    Response = ArmResponse<IntegrationRuntimeListResponse>
  >;

  /**
   * Gets detailed status information for an integration runtime.
   */
  getStatus is ArmResourceActionSync<
    IntegrationRuntimeResource,
    void,
    ArmResponse<IntegrationRuntimeStatusResponse>
  >;

  /**
   * Gets the list of outbound network dependencies for a given Azure-SSIS integration runtime.
   */
  @list
  @get
  @action("outboundNetworkDependenciesEndpoints")
  listOutboundNetworkDependenciesEndpoints is ArmResourceActionSync<
    IntegrationRuntimeResource,
    void,
    ArmResponse<IntegrationRuntimeOutboundNetworkDependenciesEndpointsResponse>
  >;

  /**
   * Gets the on-premises integration runtime connection information for encrypting the on-premises data source credentials.
   */
  getConnectionInfo is ArmResourceActionSync<
    IntegrationRuntimeResource,
    void,
    ArmResponse<IntegrationRuntimeConnectionInfo>
  >;

  /**
   * Regenerates the authentication key for an integration runtime.
   */
  regenerateAuthKey is ArmResourceActionSync<
    IntegrationRuntimeResource,
    IntegrationRuntimeRegenerateKeyParameters,
    ArmResponse<IntegrationRuntimeAuthKeys>
  >;

  /**
   * Retrieves the authentication keys for an integration runtime.
   */
  listAuthKeys is ArmResourceActionSync<
    IntegrationRuntimeResource,
    void,
    ArmResponse<IntegrationRuntimeAuthKeys>
  >;

  /**
   * Starts a ManagedReserved type integration runtime.
   */
  start is ArmResourceActionAsync<
    IntegrationRuntimeResource,
    void,
    ArmResponse<IntegrationRuntimeStatusResponse>
  >;

  /**
   * Stops a ManagedReserved type integration runtime.
   */
  stop is ArmResourceActionAsync<IntegrationRuntimeResource, void, OkResponse>;

  /**
   * Force the integration runtime to synchronize credentials across integration runtime nodes, and this will override the credentials across all worker nodes with those available on the dispatcher node. If you already have the latest credential backup file, you should manually import it (preferred) on any self-hosted integration runtime node than using this API directly.
   */
  syncCredentials is ArmResourceActionSync<
    IntegrationRuntimeResource,
    void,
    OkResponse
  >;

  /**
   * Get the integration runtime monitoring data, which includes the monitor data for all the nodes under this integration runtime.
   */
  @action("monitoringData")
  getMonitoringData is ArmResourceActionSync<
    IntegrationRuntimeResource,
    void,
    ArmResponse<IntegrationRuntimeMonitoringData>
  >;

  /**
   * Upgrade self-hosted integration runtime to latest version if availability.
   */
  upgrade is ArmResourceActionSync<
    IntegrationRuntimeResource,
    void,
    OkResponse
  >;

  /**
   * Remove all linked integration runtimes under specific data factory in a self-hosted integration runtime.
   */
  removeLinks is ArmResourceActionSync<
    IntegrationRuntimeResource,
    LinkedIntegrationRuntimeRequest,
    OkResponse
  >;

  /**
   * Create a linked integration runtime entry in a shared integration runtime.
   */
  @action("linkedIntegrationRuntime")
  createLinkedIntegrationRuntime is ArmResourceActionSync<
    IntegrationRuntimeResource,
    CreateLinkedIntegrationRuntimeRequest,
    ArmResponse<IntegrationRuntimeStatusResponse>
  >;

  /**
   * Refresh a SSIS integration runtime object metadata.
   */
  @action("refreshObjectMetadata")
  refresh is ArmResourceActionAsync<
    IntegrationRuntimeResource,
    void,
    ArmResponse<SsisObjectMetadataStatusResponse>
  >;

  /**
   * Get a SSIS integration runtime object metadata by specified path. The return is pageable metadata list.
   */
  @list
  @action("getObjectMetadata")
  integrationRuntimeObjectMetadataGet is ArmResourceActionSync<
    IntegrationRuntimeResource,
    GetSsisObjectMetadataRequest,
    ArmResponse<SsisObjectMetadataListResponse>,
    OptionalRequestBody = true
  >;

  /**
   * Gets a self-hosted integration runtime node.
   */
  @get
  @action("{nodeName}")
  integrationRuntimeNodesGet is ArmResourceActionSync<
    IntegrationRuntimeResource,
    void,
    ArmResponse<SelfHostedIntegrationRuntimeNode>,
    Parameters = {
      /**
       * The integration runtime node name.
       */
      @maxLength(150)
      @minLength(1)
      @pattern("^[a-z0-9A-Z][a-z0-9A-Z_-]{0,149}$")
      @path
      nodeName: string;
    }
  >;

  /**
   * Deletes a self-hosted integration runtime node.
   */
  @delete
  @action("{nodeName}")
  integrationRuntimeNodesDelete is ArmResourceActionSync<
    IntegrationRuntimeResource,
    void,
    OkResponse | NoContentResponse,
    Parameters = {
      /**
       * The integration runtime node name.
       */
      @maxLength(150)
      @minLength(1)
      @pattern("^[a-z0-9A-Z][a-z0-9A-Z_-]{0,149}$")
      @path
      nodeName: string;
    }
  >;

  /**
   * Updates a self-hosted integration runtime node.
   */
  @patch
  @action("{nodeName}")
  integrationRuntimeNodesUpdate is ArmResourceActionSync<
    IntegrationRuntimeResource,
    UpdateIntegrationRuntimeNodeRequest,
    ArmResponse<SelfHostedIntegrationRuntimeNode>,
    Parameters = {
      /**
       * The integration runtime node name.
       */
      @maxLength(150)
      @minLength(1)
      @pattern("^[a-z0-9A-Z][a-z0-9A-Z_-]{0,149}$")
      @path
      nodeName: string;
    }
  >;

  /**
   * Get the IP address of self-hosted integration runtime node.
   */
  @action("ipAddress")
  getIpAddress is ArmResourceActionSync<
    IntegrationRuntimeResource,
    void,
    ArmResponse<IntegrationRuntimeNodeIpAddress>,
    Parameters = {
      /**
       * The integration runtime node name.
       */
      @maxLength(150)
      @minLength(1)
      @pattern("^[a-z0-9A-Z][a-z0-9A-Z_-]{0,149}$")
      @path
      nodeName: string;
    }
  >;

  /**
   * Enable interactive authoring of Managed Virtual Network integration runtime.
   */
  enableInteractiveQuery is ArmResourceActionAsync<
    IntegrationRuntimeResource,
    EnableInteractiveQueryRequest,
    ArmResponse<IntegrationRuntimeResource>,
    LroHeaders = ArmAsyncOperationHeader<FinalResult = IntegrationRuntimeResource> &
      Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * Disable interactive authoring of Managed Virtual Network integration runtime.
   */
  disableInteractiveQuery is ArmResourceActionAsync<
    IntegrationRuntimeResource,
    void,
    ArmResponse<IntegrationRuntimeResource>,
    LroHeaders = ArmAsyncOperationHeader<FinalResult = IntegrationRuntimeResource> &
      Azure.Core.Foundations.RetryAfterHeader
  >;
}

@@maxLength(IntegrationRuntimeResource.name, 63);
@@minLength(IntegrationRuntimeResource.name, 3);
@@doc(IntegrationRuntimeResource.name, "The integration runtime name.");
@@doc(IntegrationRuntimeResource.properties, "Integration runtime properties.");
@@doc(IntegrationRuntimeResources.createOrUpdate::parameters.resource,
  "Integration runtime resource definition."
);
@@doc(IntegrationRuntimeResources.update::parameters.properties,
  "The parameters for updating an integration runtime."
);
@@doc(IntegrationRuntimeResources.regenerateAuthKey::parameters.body,
  "The parameters for regenerating integration runtime authentication key."
);
@@doc(IntegrationRuntimeResources.removeLinks::parameters.body,
  "The data factory name for the linked integration runtime."
);
@@doc(IntegrationRuntimeResources.createLinkedIntegrationRuntime::parameters.body,
  "The linked integration runtime properties."
);
@@doc(IntegrationRuntimeResources.integrationRuntimeObjectMetadataGet::parameters.body,
  "The parameters for getting a SSIS object metadata."
);
@@doc(IntegrationRuntimeResources.integrationRuntimeNodesUpdate::parameters.body,
  "The parameters for updating an integration runtime node."
);
@@doc(IntegrationRuntimeResources.enableInteractiveQuery::parameters.body,
  "The enable interactive authoring integration runtime properties."
);
