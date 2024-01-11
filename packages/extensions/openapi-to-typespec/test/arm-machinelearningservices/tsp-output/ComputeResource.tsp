import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
// FIXME: ComputeResource has no properties property
@doc("Machine Learning compute object wrapped into ARM resource envelope.")
@parentResource(Workspace)
model ComputeResource is TrackedResource<{}> {
  @doc("Name of the Azure Machine Learning compute.")
  @path
  @key("computeName")
  @segment("computes")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
}

@armResourceOperations
interface ComputeResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets compute definition by its name. Any secrets (storage keys, service credentials, etc) are not returned - use 'keys' nested resource to get them.")
  @operationId("Compute_Get")
  get is ArmResourceRead<ComputeResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.")
  @operationId("Compute_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ComputeResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates properties of a compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation.")
  @operationId("Compute_Update")
  update is ArmCustomPatchAsync<ComputeResource, ClusterUpdateParameters>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes specified Machine Learning compute.")
  @operationId("Compute_Delete")
  delete is ArmResourceDeleteAsync<
    ComputeResource,
    {
      ...BaseParameters<ComputeResource>;

      @doc("Delete the underlying compute if 'Delete', or detach the underlying compute from workspace if 'Detach'.")
      @query("underlyingResourceAction")
      underlyingResourceAction: UnderlyingResourceAction;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets computes in specified workspace.")
  @operationId("Compute_List")
  list is ArmResourceListByParent<
    ComputeResource,
    {
      ...BaseParameters<ComputeResource>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates the custom services list. The list of custom services provided shall be overwritten")
  @operationId("Compute_UpdateCustomServices")
  updateCustomServices is ArmResourceActionSync<
    ComputeResource,
    CustomService[],
    void
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get the details (e.g IP address, port etc) of all the compute nodes in the compute.")
  @operationId("Compute_ListNodes")
  listNodes is ArmResourceActionSync<
    ComputeResource,
    void,
    AmlComputeNodesInformation
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).")
  @operationId("Compute_ListKeys")
  listKeys is ArmResourceActionSync<ComputeResource, void, ComputeSecrets>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Posts a start action to a compute instance")
  @operationId("Compute_Start")
  start is ArmResourceActionNoResponseContentAsync<ComputeResource, void>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Posts a stop action to a compute instance")
  @operationId("Compute_Stop")
  stop is ArmResourceActionNoResponseContentAsync<ComputeResource, void>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Posts a restart action to a compute instance")
  @operationId("Compute_Restart")
  restart is ArmResourceActionNoResponseContentAsync<ComputeResource, void>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates the idle shutdown setting of a compute instance.")
  @operationId("Compute_UpdateIdleShutdownSetting")
  updateIdleShutdownSetting is ArmResourceActionSync<
    ComputeResource,
    IdleShutdownSetting,
    void
  >;
}
