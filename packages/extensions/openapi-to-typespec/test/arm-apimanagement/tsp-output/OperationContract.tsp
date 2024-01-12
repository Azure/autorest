import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
@doc("API Operation details.")
@parentResource(ApiContract)
model OperationContract is ProxyResource<OperationContractProperties> {
  @doc("Operation identifier within an API. Must be unique in the current API Management service instance.")
  @maxLength(80)
  @minLength(1)
  @path
  @key("operationId")
  @segment("operations")
  name: string;
}

@armResourceOperations
interface OperationContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the details of the API Operation specified by its identifier.")
  @operationId("ApiOperation_Get")
  get is ArmResourceRead<OperationContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the API operation specified by its identifier.")
  @head
  @operationId("ApiOperation_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      OperationContract,
      BaseParameters<OperationContract>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates a new operation in the API or updates an existing one.")
  @operationId("ApiOperation_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    OperationContract,
    {
      ...BaseParameters<OperationContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates the details of the operation in the API specified by its identifier.")
  @operationId("ApiOperation_Update")
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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes the specified operation in the API.")
  @operationId("ApiOperation_Delete")
  delete is ArmResourceDeleteSync<
    OperationContract,
    {
      ...BaseParameters<OperationContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists a collection of the operations for the specified API.")
  @operationId("ApiOperation_ListByApi")
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

@@projectedName(OperationContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(OperationContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(OperationContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@projectedName(OperationContracts.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(OperationContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(OperationContracts.update::parameters.properties,
  "API Operation Update parameters."
);
