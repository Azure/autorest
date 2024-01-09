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
@doc("Global Schema Contract details.")
@parentResource(ApiManagementServiceResource)
model GlobalSchemaContract is ProxyResource<GlobalSchemaContractProperties> {
  @doc("Schema id identifier. Must be unique in the current API Management service instance.")
  @maxLength(80)
  @minLength(1)
  @key("schemaId")
  @segment("schemas")
  name: string;
}

@armResourceOperations
@projectedName("client", "GlobalSchema")
interface GlobalSchemaContracts_GlobalSchema {
  @doc("Gets the details of the Schema specified by its identifier.")
  get is ArmResourceRead<GlobalSchemaContract>;

  @doc("Gets the entity state (Etag) version of the Schema specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      GlobalSchemaContract,
      BaseParameters<GlobalSchemaContract>
    >,
  ): OkResponse | ErrorResponse;

  @doc("Creates new or updates existing specified Schema of the API Management service instance.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<
    GlobalSchemaContract,
    {
      ...BaseParameters<GlobalSchemaContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  @doc("Deletes specific Schema.")
  delete is ArmResourceDeleteSync<
    GlobalSchemaContract,
    {
      ...BaseParameters<GlobalSchemaContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  @doc("Lists a collection of schemas registered with service instance.")
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
