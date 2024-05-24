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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Compute_Get")
  get is ArmResourceRead<ComputeResource>;

  /**
   * Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Compute_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<ComputeResource>;

  /**
   * Updates properties of a compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("Compute_Update")
  update is ArmCustomPatchAsync<ComputeResource, ClusterUpdateParameters>;

  /**
   * Deletes specified Machine Learning compute.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Compute_Delete")
  delete is ArmResourceDeleteAsync<
    ComputeResource,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ComputeResource>;

      /**
       * Delete the underlying compute if 'Delete', or detach the underlying compute from workspace if 'Detach'.
       */
      @query("underlyingResourceAction")
      underlyingResourceAction: UnderlyingResourceAction;
    }
  >;

  /**
   * Gets computes in specified workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Compute_List")
  list is ArmResourceListByParent<
    ComputeResource,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ComputeResource>;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;
    }
  >;

  /**
   * Updates the custom services list. The list of custom services provided shall be overwritten
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Compute_UpdateCustomServices")
  updateCustomServices is ArmResourceActionSync<
    ComputeResource,
    CustomService[],
    void
  >;

  /**
   * Get the details (e.g IP address, port etc) of all the compute nodes in the compute.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Compute_ListNodes")
  listNodes is ArmResourceActionSync<
    ComputeResource,
    void,
    AmlComputeNodesInformation
  >;

  /**
   * Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Compute_ListKeys")
  listKeys is ArmResourceActionSync<ComputeResource, void, ComputeSecrets>;

  /**
   * Posts a start action to a compute instance
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Compute_Start")
  start is ArmResourceActionNoResponseContentAsync<ComputeResource, void>;

  /**
   * Posts a stop action to a compute instance
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Compute_Stop")
  stop is ArmResourceActionNoResponseContentAsync<ComputeResource, void>;

  /**
   * Posts a restart action to a compute instance
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Compute_Restart")
  restart is ArmResourceActionNoResponseContentAsync<ComputeResource, void>;

  /**
   * Updates the idle shutdown setting of a compute instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Compute_UpdateIdleShutdownSetting")
  updateIdleShutdownSetting is ArmResourceActionSync<
    ComputeResource,
    IdleShutdownSetting,
    void
  >;
}

@@doc(ComputeResource.name, "Name of the Azure Machine Learning compute.");
@@encodedName(ComputeResources.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(ComputeResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(ComputeResources.createOrUpdate::parameters.resource,
  "Payload with Machine Learning compute definition."
);
@@encodedName(ComputeResources.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(ComputeResources.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(ComputeResources.update::parameters.properties,
  "Additional parameters for cluster update."
);
@@encodedName(ComputeResources.updateCustomServices::parameters.body,
  "application/json",
  "customServices"
);
@@extension(ComputeResources.updateCustomServices::parameters.body,
  "x-ms-client-name",
  "customServices"
);
@@doc(ComputeResources.updateCustomServices::parameters.body,
  "New list of Custom Services."
);
@@encodedName(ComputeResources.updateIdleShutdownSetting::parameters.body,
  "application/json",
  "parameters"
);
@@extension(ComputeResources.updateIdleShutdownSetting::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(ComputeResources.updateIdleShutdownSetting::parameters.body,
  "The object for updating idle shutdown setting of specified ComputeInstance."
);
