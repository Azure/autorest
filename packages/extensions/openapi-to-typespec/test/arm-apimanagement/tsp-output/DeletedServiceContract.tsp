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
@doc("Deleted API Management Service information.")
@locationResource
model DeletedServiceContract
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
interface DeletedServiceContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get soft-deleted Api Management Service by name.")
  @operationId("DeletedServices_GetByName")
  getByName is ArmResourceRead<DeletedServiceContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Purges Api Management Service (deletes it with no option to undelete).")
  @operationId("DeletedServices_Purge")
  purge is ArmResourceDeleteAsync<
    DeletedServiceContract,
    BaseParameters<DeletedServiceContract>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists all soft-deleted services available for undelete for the given subscription.")
  @operationId("DeletedServices_ListBySubscription")
  listBySubscription is ArmListBySubscription<DeletedServiceContract>;
}
