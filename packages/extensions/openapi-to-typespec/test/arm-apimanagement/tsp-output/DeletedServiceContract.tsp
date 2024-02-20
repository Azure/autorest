import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Deleted API Management Service information.
 */
@subscriptionResource
@parentResource("SubscriptionLocationResource")
model DeletedServiceContract
  is ProxyResource<DeletedServiceContractProperties> {
  /**
   * The name of the API Management service.
   */
  @maxLength(50)
  @minLength(1)
  @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
  @path
  @key("serviceName")
  @segment("deletedservices")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface DeletedServiceContracts {
  /**
   * Get soft-deleted Api Management Service by name.
   */
  getByName is ArmResourceRead<DeletedServiceContract>;

  /**
   * Purges Api Management Service (deletes it with no option to undelete).
   */
  purge is ArmResourceDeleteAsync<DeletedServiceContract>;

  /**
   * Lists all soft-deleted services available for undelete for the given subscription.
   */
  listBySubscription is ArmListBySubscription<DeletedServiceContract>;
}
