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
@doc("Global Schema Contract details.")
@parentResource(ApiManagementServiceResource)
model GlobalSchemaContract is ProxyResource<GlobalSchemaContractProperties> {
  @doc("Schema id identifier. Must be unique in the current API Management service instance.")
  @maxLength(80)
  @minLength(1)
  @path
  @key("schemaId")
  @segment("schemas")
  name: string;
}

@armResourceOperations
interface GlobalSchemaContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the details of the Schema specified by its identifier.")
  @operationId("GlobalSchema_Get")
  get is ArmResourceRead<GlobalSchemaContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the Schema specified by its identifier.")
  @head
  @operationId("GlobalSchema_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      GlobalSchemaContract,
      BaseParameters<GlobalSchemaContract>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates new or updates existing specified Schema of the API Management service instance.")
  @operationId("GlobalSchema_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    GlobalSchemaContract,
    {
      ...BaseParameters<GlobalSchemaContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    },
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes specific Schema.")
  @operationId("GlobalSchema_Delete")
  delete is ArmResourceDeleteSync<
    GlobalSchemaContract,
    {
      ...BaseParameters<GlobalSchemaContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists a collection of schemas registered with service instance.")
  @operationId("GlobalSchema_ListByService")
  listByService is ArmResourceListByParent<
    GlobalSchemaContract,
    {
      ...BaseParameters<GlobalSchemaContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
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

@@projectedName(GlobalSchemaContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(GlobalSchemaContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(GlobalSchemaContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
