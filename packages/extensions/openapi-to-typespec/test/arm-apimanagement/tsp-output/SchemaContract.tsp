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
@doc("API Schema Contract details.")
@parentResource(ApiContract)
model SchemaContract is ProxyResource<SchemaContractProperties> {
  @doc("Schema id identifier. Must be unique in the current API Management service instance.")
  @maxLength(80)
  @minLength(1)
  @path
  @key("schemaId")
  @segment("schemas")
  name: string;
}

@armResourceOperations
interface SchemaContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get the schema configuration at the API level.")
  @operationId("ApiSchema_Get")
  get is ArmResourceRead<SchemaContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the schema specified by its identifier.")
  @head
  @operationId("ApiSchema_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      SchemaContract,
      BaseParameters<SchemaContract>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates or updates schema configuration for the API.")
  @operationId("ApiSchema_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<
    SchemaContract,
    {
      ...BaseParameters<SchemaContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    },
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes the schema configuration at the Api.")
  @operationId("ApiSchema_Delete")
  delete is ArmResourceDeleteSync<
    SchemaContract,
    {
      ...BaseParameters<SchemaContract>;

      @doc("If true removes all references to the schema before deleting it.")
      @query("force")
      force?: boolean;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get the schema configuration at the API level.")
  @operationId("ApiSchema_ListByApi")
  listByApi is ArmResourceListByParent<
    SchemaContract,
    {
      ...BaseParameters<SchemaContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| contentType | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
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

@@projectedName(SchemaContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(SchemaContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(SchemaContracts.createOrUpdate::parameters.resource,
  "The schema contents to apply."
);
