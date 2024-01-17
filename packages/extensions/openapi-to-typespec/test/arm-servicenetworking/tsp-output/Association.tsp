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
@doc("Association Subresource of Traffic Controller")
@parentResource(TrafficController)
model Association is TrackedResource<AssociationProperties> {
  @doc("Name of Association")
  @pattern("^[A-Za-z0-9]([A-Za-z0-9-_.]{0,62}[A-Za-z0-9])?$")
  @path
  @key("associationName")
  @segment("associations")
  name: string;
}

@armResourceOperations
interface Associations {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get a Association")
  @operationId("AssociationsInterface_Get")
  get is ArmResourceRead<Association>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create a Association")
  @operationId("AssociationsInterface_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    Association,
    BaseParameters<Association>,
    ArmAsyncOperationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Update a Association")
  @parameterVisibility("read")
  @operationId("AssociationsInterface_Update")
  update is ArmCustomPatchSync<Association, AssociationUpdate>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete a Association")
  @operationId("AssociationsInterface_Delete")
  delete is ArmResourceDeleteAsync<
    Association,
    BaseParameters<Association>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List Association resources by TrafficController")
  @operationId("AssociationsInterface_ListByTrafficController")
  listByTrafficController is ArmResourceListByParent<Association>;
}
