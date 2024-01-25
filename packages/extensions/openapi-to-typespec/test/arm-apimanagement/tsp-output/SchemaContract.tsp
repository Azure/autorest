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
/**
 * API Schema Contract details.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiContract)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(SchemaContractProperties)
model SchemaContract extends ProxyResourceBase {
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

  /**
   * Properties of the API Schema.
   */
  @extension("x-ms-client-flatten", true)
  properties?: SchemaContractProperties;
}

@armResourceOperations
interface SchemaContracts {
  /**
   * Get the schema configuration at the API level.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiSchema_Get")
  get is ArmResourceRead<SchemaContract>;

  /**
   * Gets the entity state (Etag) version of the schema specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("ApiSchema_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      SchemaContract,
      BaseParameters<SchemaContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or updates schema configuration for the API.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiSchema_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    SchemaContract,
    {
      ...BaseParameters<SchemaContract>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    },
    ArmLroLocationHeader
  >;

  /**
   * Deletes the schema configuration at the Api.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiSchema_Delete")
  delete is ArmResourceDeleteSync<
    SchemaContract,
    {
      ...BaseParameters<SchemaContract>;

      /**
       * If true removes all references to the schema before deleting it.
       */
      @query("force")
      force?: boolean;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Get the schema configuration at the API level.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiSchema_ListByApi")
  listByApi is ArmResourceListByParent<
    SchemaContract,
    {
      ...BaseParameters<SchemaContract>;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| contentType | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
