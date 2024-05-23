import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./TrafficController.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.ServiceNetworking;
/**
 * Frontend Subresource of Traffic Controller.
 */
@parentResource(TrafficController)
model Frontend is Azure.ResourceManager.TrackedResource<FrontendProperties> {
  ...ResourceNameParameter<
    Resource = Frontend,
    KeyName = "frontendName",
    SegmentName = "frontends",
    NamePattern = "^[A-Za-z0-9]([A-Za-z0-9-_.]{0,62}[A-Za-z0-9])?$"
  >;
}

@armResourceOperations
interface Frontends {
  /**
   * Get a Frontend
   */
  get is ArmResourceRead<Frontend>;

  /**
   * Create a Frontend
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Frontend>;

  /**
   * Update a Frontend
   */
  @parameterVisibility
  update is ArmCustomPatchSync<Frontend, FrontendUpdate>;

  /**
   * Delete a Frontend
   */
  delete is ArmResourceDeleteAsync<Frontend>;

  /**
   * List Frontend resources by TrafficController
   */
  listByTrafficController is ArmResourceListByParent<Frontend>;
}

@@doc(Frontend.name, "Frontends");
