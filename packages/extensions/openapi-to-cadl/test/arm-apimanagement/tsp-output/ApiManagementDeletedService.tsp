import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Deleted API Management Service information.")
@locationResource
model ApiManagementDeletedService
  is ProxyResource<DeletedServiceContractProperties> {
  @doc("The name of the API Management service.")
  @maxLength(50)
  @minLength(1)
  @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
  @path
  @key("serviceName")
  @segment("deletedservices")
  name: string;
}

@armResourceOperations
interface ApiManagementDeletedServices {
  @doc("Get soft-deleted Api Management Service by name.")
  getByName is ArmResourceRead<ApiManagementDeletedService>;
  @doc("Purges Api Management Service (deletes it with no option to undelete).")
  purge is ArmResourceDeleteAsync<ApiManagementDeletedService>;
  @doc("Lists all soft-deleted services available for undelete for the given subscription.")
  listBySubscription is ArmListBySubscription<ApiManagementDeletedService>;
}
