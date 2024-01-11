import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./TrafficController.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.ServiceNetworking;
@doc("Frontend Subresource of Traffic Controller.")
@parentResource(TrafficController)
model Frontend is TrackedResource<FrontendProperties> {
  @doc("Frontends")
  @pattern("^[A-Za-z0-9]([A-Za-z0-9-_.]{0,62}[A-Za-z0-9])?$")
  @path
  @key("frontendName")
  @segment("frontends")
  name: string;
}

@armResourceOperations
interface Frontends {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get a Frontend")
  @operationId("FrontendsInterface_Get")
  get is ArmResourceRead<Frontend>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create a Frontend")
  @operationId("FrontendsInterface_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<
    Frontend,
    BaseParameters<Frontend>,
    ArmAsyncOperationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Update a Frontend")
  @operationId("FrontendsInterface_Update")
  update is ArmCustomPatchSync<Frontend, FrontendUpdate>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete a Frontend")
  @operationId("FrontendsInterface_Delete")
  delete is ArmResourceDeleteAsync<
    Frontend,
    BaseParameters<Frontend>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List Frontend resources by TrafficController")
  @operationId("FrontendsInterface_ListByTrafficController")
  listByTrafficController is ArmResourceListByParent<Frontend>;
}
