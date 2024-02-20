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
/**
 * Global Schema Contract details.
 */
@parentResource(ApiManagementServiceResource)
model GlobalSchemaContract is ProxyResource<GlobalSchemaContractProperties> {
  /**
   * Schema id identifier. Must be unique in the current API Management service instance.
   */
  @maxLength(80)
  @minLength(1)
  @path
  @key("schemaId")
  @segment("schemas")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface GlobalSchemaContracts {
  /**
   * Gets the details of the Schema specified by its identifier.
   */
  get is ArmResourceRead<GlobalSchemaContract>;

  /**
   * Gets the entity state (Etag) version of the Schema specified by its identifier.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      GlobalSchemaContract,
      BaseParameters<GlobalSchemaContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates new or updates existing specified Schema of the API Management service instance.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    GlobalSchemaContract,
    {
      ...BaseParameters<GlobalSchemaContract>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Deletes specific Schema.
   */
  delete is ArmResourceDeleteSync<
    GlobalSchemaContract,
    {
      ...BaseParameters<GlobalSchemaContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists a collection of schemas registered with service instance.
   */
  listByService is ArmResourceListByParent<
    GlobalSchemaContract,
    {
      ...BaseParameters<GlobalSchemaContract>;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
       */
      @query("$filter")
      $filter?: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;
    }
  >;
}

@@doc(GlobalSchemaContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
