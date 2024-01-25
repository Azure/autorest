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
/**
 * Frontend Subresource of Traffic Controller.
 */
@parentResource(TrafficController)
model Frontend is TrackedResource<FrontendProperties> {
  /**
   * Frontends
   */
  @pattern("^[A-Za-z0-9]([A-Za-z0-9-_.]{0,62}[A-Za-z0-9])?$")
  @path
  @key("frontendName")
  @segment("frontends")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface Frontends {
  /**
   * Get a Frontend
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FrontendsInterface_Get")
  get is ArmResourceRead<Frontend>;

  /**
   * Create a Frontend
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FrontendsInterface_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    Frontend,
    BaseParameters<Frontend>,
    ArmAsyncOperationHeader
  >;

  /**
   * Update a Frontend
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility("read")
  @operationId("FrontendsInterface_Update")
  update is ArmCustomPatchSync<Frontend, FrontendUpdate>;

  /**
   * Delete a Frontend
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FrontendsInterface_Delete")
  delete is ArmResourceDeleteAsync<
    Frontend,
    BaseParameters<Frontend>,
    ArmLroLocationHeader
  >;

  /**
   * List Frontend resources by TrafficController
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FrontendsInterface_ListByTrafficController")
  listByTrafficController is ArmResourceListByParent<Frontend>;
}
