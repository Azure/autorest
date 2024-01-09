import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("API Operation details.")
@parentResource(ApiContract)
model OperationContract is ProxyResource<OperationContractProperties> {
  @doc("Operation identifier within an API. Must be unique in the current API Management service instance.")
  @maxLength(80)
  @minLength(1)
  @key("operationId")
  @segment("operations")
  name: string;
}

@armResourceOperations
@projectedName("client", "ApiOperation")
interface OperationContracts_ApiOperation {
  @doc("Gets the details of the API Operation specified by its identifier.")
  get is ArmResourceRead<OperationContract>;

  @doc("Gets the entity state (Etag) version of the API operation specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      OperationContract,
      BaseParameters<OperationContract>
    >,
  ): OkResponse | ErrorResponse;

  @doc("Creates a new operation in the API or updates an existing one.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    OperationContract,
    {
      ...BaseParameters<OperationContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  @doc("Updates the details of the operation in the API specified by its identifier.")
  update is ArmCustomPatchSync<
    OperationContract,
    OperationUpdateContract,
    {
      ...BaseParameters<OperationContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  @doc("Deletes the specified operation in the API.")
  delete is ArmResourceDeleteSync<
    OperationContract,
    {
      ...BaseParameters<OperationContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  @doc("Lists a collection of the operations for the specified API.")
  listByApi is ArmResourceListByParent<
    OperationContract,
    {
      ...BaseParameters<OperationContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| method | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| urlTemplate | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("Include tags in the response.")
      @query("tags")
      tags?: string;
    }
  >;
}
