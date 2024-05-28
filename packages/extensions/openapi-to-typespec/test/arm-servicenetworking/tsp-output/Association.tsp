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
 * Association Subresource of Traffic Controller
 */
@parentResource(TrafficController)
model Association
  is Azure.ResourceManager.TrackedResource<AssociationProperties> {
  ...ResourceNameParameter<
    Resource = Association,
    KeyName = "associationName",
    SegmentName = "associations",
    NamePattern = "^[A-Za-z0-9]([A-Za-z0-9-_.]{0,62}[A-Za-z0-9])?$"
  >;
}

@armResourceOperations
interface Associations {
  /**
   * Get a Association
   */
  get is ArmResourceRead<Association>;

  /**
   * Create a Association
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Association>;

  /**
   * Update a Association
   */
  @parameterVisibility
  update is ArmCustomPatchSync<Association, AssociationUpdate>;

  /**
   * Delete a Association
   */
  delete is ArmResourceDeleteAsync<Association>;

  /**
   * List Association resources by TrafficController
   */
  listByTrafficController is ArmResourceListByParent<Association>;
}

@@doc(Association.name, "Name of Association");
