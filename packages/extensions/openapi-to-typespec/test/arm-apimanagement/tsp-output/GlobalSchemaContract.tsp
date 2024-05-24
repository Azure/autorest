import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Global Schema Contract details.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  GlobalSchemaContractProperties
)
model GlobalSchemaContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = GlobalSchemaContract,
    KeyName = "schemaId",
    SegmentName = "schemas",
    NamePattern = ""
  >;

  /**
   * Properties of the Global Schema.
   */
  @extension("x-ms-client-flatten", true)
  properties?: GlobalSchemaContractProperties;
}

@armResourceOperations
interface GlobalSchemaContracts {
  /**
   * Gets the details of the Schema specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GlobalSchema_Get")
  get is ArmResourceRead<GlobalSchemaContract>;

  /**
   * Gets the entity state (Etag) version of the Schema specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("GlobalSchema_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      GlobalSchemaContract,
      BaseParameters<GlobalSchemaContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates new or updates existing specified Schema of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GlobalSchema_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    GlobalSchemaContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<GlobalSchemaContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("GlobalSchema_Delete")
  delete is ArmResourceDeleteSync<
    GlobalSchemaContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<GlobalSchemaContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GlobalSchema_ListByService")
  listByService is ArmResourceListByParent<
    GlobalSchemaContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<GlobalSchemaContract>;

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

@@maxLength(GlobalSchemaContract.name, 80);
@@minLength(GlobalSchemaContract.name, 1);
@@doc(GlobalSchemaContract.name,
  "Schema id identifier. Must be unique in the current API Management service instance."
);
@@encodedName(GlobalSchemaContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(GlobalSchemaContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(GlobalSchemaContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
