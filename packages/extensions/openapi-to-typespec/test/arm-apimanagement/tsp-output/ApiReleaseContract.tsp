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
 * ApiRelease details.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiContract)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(ApiReleaseContractProperties)
model ApiReleaseContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = ApiReleaseContract,
    KeyName = "releaseId",
    SegmentName = "releases",
    NamePattern = "^[^*#&+:<>?]+$"
  >;

  /**
   * ApiRelease entity contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: ApiReleaseContractProperties;
}

@armResourceOperations
interface ApiReleaseContracts {
  /**
   * Returns the details of an API release.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiRelease_Get")
  get is ArmResourceRead<ApiReleaseContract>;

  /**
   * Returns the etag of an API release.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("ApiRelease_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiReleaseContract,
      BaseParameters<ApiReleaseContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates a new Release for the API.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiRelease_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiReleaseContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ApiReleaseContract>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates the details of the release of the API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("ApiRelease_Update")
  update is ArmCustomPatchSync<
    ApiReleaseContract,
    ApiReleaseContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ApiReleaseContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes the specified release in the API.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("ApiRelease_Delete")
  delete is ArmResourceDeleteSync<
    ApiReleaseContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ApiReleaseContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists all releases of an API. An API release is created when making an API Revision current. Releases are also used to rollback to previous revisions. Results will be paged and can be constrained by the $top and $skip parameters.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiRelease_ListByService")
  listByService is ArmResourceListByParent<
    ApiReleaseContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ApiReleaseContract>;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| notes | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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

@@maxLength(ApiReleaseContract.name, 80);
@@minLength(ApiReleaseContract.name, 1);
@@doc(ApiReleaseContract.name,
  "Release identifier within an API. Must be unique in the current API Management service instance."
);
@@encodedName(ApiReleaseContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(ApiReleaseContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(ApiReleaseContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@encodedName(ApiReleaseContracts.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(ApiReleaseContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(ApiReleaseContracts.update::parameters.properties,
  "API Release Update parameters."
);
