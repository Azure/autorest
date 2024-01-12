import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

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
interface LoggerContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the details of the logger specified by its identifier.")
  @operationId("Logger_Get")
  get is ArmResourceRead<LoggerContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the logger specified by its identifier.")
  @head
  @operationId("Logger_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      LoggerContract,
      BaseParameters<LoggerContract>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates or Updates a logger.")
  @operationId("Logger_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    LoggerContract,
    {
      ...BaseParameters<LoggerContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates an existing logger.")
  @operationId("Logger_Update")
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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes the specified logger.")
  @operationId("Logger_Delete")
  delete is ArmResourceDeleteSync<
    LoggerContract,
    {
      ...BaseParameters<LoggerContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists a collection of loggers in the specified service instance.")
  @operationId("Logger_ListByService")
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

@@projectedName(LoggerContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(LoggerContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(LoggerContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@projectedName(LoggerContracts.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(LoggerContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(LoggerContracts.update::parameters.properties, "Update parameters.");
