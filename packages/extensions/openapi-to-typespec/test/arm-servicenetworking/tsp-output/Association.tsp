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
 * Association Subresource of Traffic Controller
 */
@parentResource(TrafficController)
model Association is TrackedResource<AssociationProperties> {
  /**
   * Name of Association
   */
  @pattern("^[A-Za-z0-9]([A-Za-z0-9-_.]{0,62}[A-Za-z0-9])?$")
  @path
  @key("associationName")
  @segment("associations")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface Associations {
  /**
   * Get a Association
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("AssociationsInterface_Get")
  get is ArmResourceRead<Association>;

  /**
   * Create a Association
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("AssociationsInterface_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Association>;

  /**
   * Update a Association
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility("read")
  @operationId("AssociationsInterface_Update")
  update is ArmCustomPatchSync<Association, AssociationUpdate>;

  /**
   * Delete a Association
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("AssociationsInterface_Delete")
  delete is ArmResourceDeleteAsync<Association>;

  /**
   * List Association resources by TrafficController
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("AssociationsInterface_ListByTrafficController")
  listByTrafficController is ArmResourceListByParent<Association>;
}
