import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
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
model SchemaContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = SchemaContract,
    KeyName = "schemaId",
    SegmentName = "schemas",
    NamePattern = ""
  >;

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
      ...Azure.ResourceManager.Foundations.BaseParameters<SchemaContract>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Deletes the schema configuration at the Api.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("ApiSchema_Delete")
  delete is ArmResourceDeleteSync<
    SchemaContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<SchemaContract>;

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
      ...Azure.ResourceManager.Foundations.BaseParameters<SchemaContract>;

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

@@maxLength(SchemaContract.name, 80);
@@minLength(SchemaContract.name, 1);
@@doc(SchemaContract.name,
  "Schema id identifier. Must be unique in the current API Management service instance."
);
@@encodedName(SchemaContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(SchemaContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(SchemaContracts.createOrUpdate::parameters.resource,
  "The schema contents to apply."
);
