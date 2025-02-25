import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
// FIXME: ComputeResource has no properties property
/**
 * Machine Learning compute object wrapped into ARM resource envelope.
 */
@parentResource(Workspace)
model ComputeResource is Azure.ResourceManager.TrackedResource<{}> {
  ...ResourceNameParameter<
    Resource = ComputeResource,
    KeyName = "computeName",
    SegmentName = "computes",
    NamePattern = ""
  >;
  ...Azure.ResourceManager.ManagedServiceIdentityProperty;
  ...Azure.ResourceManager.ResourceSkuProperty;
}

@armResourceOperations
interface ComputeResources {
  /**
   * Gets compute definition by its name. Any secrets (storage keys, service credentials, etc) are not returned - use 'keys' nested resource to get them.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Compute_Get")
  get is ArmResourceRead<ComputeResource>;

  /**
   * Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Compute_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    ComputeResource,
    LroHeaders = ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * Updates properties of a compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("Compute_Update")
  update is ArmCustomPatchAsync<
    ComputeResource,
    PatchModel = ClusterUpdateParameters,
    Response = ArmResponse<ComputeResource>
  >;

  /**
   * Deletes specified Machine Learning compute.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("Compute_Delete")
  delete is ArmResourceDeleteWithoutOkAsync<
    ComputeResource,
    Parameters = {
      /**
       * Delete the underlying compute if 'Delete', or detach the underlying compute from workspace if 'Detach'.
       */
      @query("underlyingResourceAction")
      underlyingResourceAction: UnderlyingResourceAction;
    },
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * Gets computes in specified workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Compute_List")
  list is ArmResourceListByParent<
    ComputeResource,
    Parameters = {
      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;
    },
    Response = ArmResponse<PaginatedComputeResourcesList>
  >;

  /**
   * Updates the custom services list. The list of custom services provided shall be overwritten
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @action("customServices")
  @operationId("Compute_UpdateCustomServices")
  updateCustomServices is ArmResourceActionSync<
    ComputeResource,
    CustomService[],
    OkResponse
  >;

  /**
   * Get the details (e.g IP address, port etc) of all the compute nodes in the compute.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Compute_ListNodes")
  listNodes is ArmResourceActionSync<
    ComputeResource,
    void,
    ArmResponse<AmlComputeNodesInformation>
  >;

  /**
   * Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Compute_ListKeys")
  listKeys is ArmResourceActionSync<
    ComputeResource,
    void,
    ArmResponse<ComputeSecrets>
  >;

  /**
   * Posts a start action to a compute instance
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Compute_Start")
  start is ArmResourceActionAsyncBase<
    ComputeResource,
    void,
    ArmAcceptedLroResponse,
    BaseParameters = Azure.ResourceManager.Foundations.DefaultBaseParameters<ComputeResource>
  >;

  /**
   * Posts a stop action to a compute instance
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Compute_Stop")
  stop is ArmResourceActionAsyncBase<
    ComputeResource,
    void,
    ArmAcceptedLroResponse,
    BaseParameters = Azure.ResourceManager.Foundations.DefaultBaseParameters<ComputeResource>
  >;

  /**
   * Posts a restart action to a compute instance
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Compute_Restart")
  restart is ArmResourceActionAsyncBase<
    ComputeResource,
    void,
    ArmAcceptedLroResponse,
    BaseParameters = Azure.ResourceManager.Foundations.DefaultBaseParameters<ComputeResource>
  >;

  /**
   * Updates the idle shutdown setting of a compute instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Compute_UpdateIdleShutdownSetting")
  updateIdleShutdownSetting is ArmResourceActionSync<
    ComputeResource,
    IdleShutdownSetting,
    OkResponse
  >;
}

@@doc(ComputeResource.name, "Name of the Azure Machine Learning compute.");
@@doc(ComputeResources.createOrUpdate::parameters.resource,
  "Payload with Machine Learning compute definition."
);
@@doc(ComputeResources.update::parameters.properties,
  "Additional parameters for cluster update."
);
@@doc(ComputeResources.updateCustomServices::parameters.body,
  "New list of Custom Services."
);
@@doc(ComputeResources.updateIdleShutdownSetting::parameters.body,
  "The object for updating idle shutdown setting of specified ComputeInstance."
);
