import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

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
interface Compute {
  @doc("Gets compute definition by its name. Any secrets (storage keys, service credentials, etc) are not returned - use 'keys' nested resource to get them.")
  get is ArmResourceRead<ComputeResource>;
  @doc("Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ComputeResource>;
  @doc("Updates properties of a compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation.")
  update is ArmResourcePatchAsync<ComputeResource, {}>;
  @doc("Deletes specified Machine Learning compute.")
  delete is ArmResourceDeleteAsync<
    ComputeResource,
    {
      ...BaseParameters<ComputeResource>;

      @doc("Delete the underlying compute if 'Delete', or detach the underlying compute from workspace if 'Detach'.")
      @query("underlyingResourceAction")
      underlyingResourceAction: UnderlyingResourceAction;
    }
  >;
  @doc("Gets computes in specified workspace.")
  list is ArmResourceListByParent<
    ComputeResource,
    {
      ...BaseParameters<ComputeResource>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;
    }
  >;
  @doc("Updates the custom services list. The list of custom services provided shall be overwritten")
  updateCustomServices is ArmResourceActionSync<
    ComputeResource,
    CustomService[],
    void
  >;
  @doc("Get the details (e.g IP address, port etc) of all the compute nodes in the compute.")
  listNodes is ArmResourceActionSync<
    ComputeResource,
    void,
    AmlComputeNodesInformation
  >;
  @doc("Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).")
  listKeys is ArmResourceActionSync<ComputeResource, void, ComputeSecrets>;
  @doc("Posts a start action to a compute instance")
  start is ArmResourceActionNoResponseContentAsync<ComputeResource, void>;
  @doc("Posts a stop action to a compute instance")
  stop is ArmResourceActionNoResponseContentAsync<ComputeResource, void>;
  @doc("Posts a restart action to a compute instance")
  restart is ArmResourceActionNoResponseContentAsync<ComputeResource, void>;
  @doc("Updates the idle shutdown setting of a compute instance.")
  updateIdleShutdownSetting is ArmResourceActionSync<
    ComputeResource,
    IdleShutdownSetting,
    void
  >;
}
