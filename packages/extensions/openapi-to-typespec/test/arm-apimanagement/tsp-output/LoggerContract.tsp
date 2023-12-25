import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Logger details.")
@parentResource(ApiManagementServiceResource)
model LoggerContract is ProxyResource<LoggerContractProperties> {
  @doc("Logger identifier. Must be unique in the API Management service instance.")
  @maxLength(256)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("loggerId")
  @segment("loggers")
  name: string;
}

@armResourceOperations
interface Logger {
  @doc("Gets the details of the logger specified by its identifier.")
  get is ArmResourceRead<LoggerContract>;
  @doc("Gets the entity state (Etag) version of the logger specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      LoggerContract,
      BaseParameters<LoggerContract>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Creates or Updates a logger.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    LoggerContract,
    {
      ...BaseParameters<LoggerContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Updates an existing logger.")
  update is ArmCustomPatchSync<
    LoggerContract,
    LoggerUpdateContract,
    {
      ...BaseParameters<LoggerContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Deletes the specified logger.")
  delete is ArmResourceDeleteSync<
    LoggerContract,
    {
      ...BaseParameters<LoggerContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists a collection of loggers in the specified service instance.")
  listByService is ArmResourceListByParent<
    LoggerContract,
    {
      ...BaseParameters<LoggerContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| loggerType | filter | eq |     |</br>| resourceId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;
    }
  >;
}
