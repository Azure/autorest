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
 * API Version Set Contract details.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  ApiVersionSetContractProperties
)
model ApiVersionSetContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = ApiVersionSetContract,
    KeyName = "versionSetId",
    SegmentName = "apiVersionSets",
    NamePattern = "^[^*#&+:<>?]+$"
  >;

  /**
   * API VersionSet contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: ApiVersionSetContractProperties;
}

@armResourceOperations
interface ApiVersionSetContracts {
  /**
   * Gets the details of the Api Version Set specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiVersionSet_Get")
  get is ArmResourceRead<ApiVersionSetContract>;

  /**
   * Gets the entity state (Etag) version of the Api Version Set specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("ApiVersionSet_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiVersionSetContract,
      BaseParameters<ApiVersionSetContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or Updates a Api Version Set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiVersionSet_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiVersionSetContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ApiVersionSetContract>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates the details of the Api VersionSet specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("ApiVersionSet_Update")
  update is ArmCustomPatchSync<
    ApiVersionSetContract,
    ApiVersionSetUpdateParameters,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ApiVersionSetContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes specific Api Version Set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("ApiVersionSet_Delete")
  delete is ArmResourceDeleteSync<
    ApiVersionSetContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ApiVersionSetContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists a collection of API Version Sets in the specified service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiVersionSet_ListByService")
  listByService is ArmResourceListByParent<
    ApiVersionSetContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ApiVersionSetContract>;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>
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

@@maxLength(ApiVersionSetContract.name, 80);
@@minLength(ApiVersionSetContract.name, 1);
@@doc(ApiVersionSetContract.name,
  "Api Version Set identifier. Must be unique in the current API Management service instance."
);
@@encodedName(ApiVersionSetContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(ApiVersionSetContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(ApiVersionSetContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@encodedName(ApiVersionSetContracts.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(ApiVersionSetContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(ApiVersionSetContracts.update::parameters.properties,
  "Update parameters."
);
