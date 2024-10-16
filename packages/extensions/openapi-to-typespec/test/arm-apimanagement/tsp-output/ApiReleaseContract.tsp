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
@parentResource(ApiContract)
model ApiReleaseContract
  is Azure.ResourceManager.ProxyResource<ApiReleaseContractProperties> {
  ...ResourceNameParameter<
    Resource = ApiReleaseContract,
    KeyName = "releaseId",
    SegmentName = "releases",
    NamePattern = "^[^*#&+:<>?]+$"
  >;
}

@armResourceOperations
interface ApiReleaseContracts {
  /**
   * Returns the details of an API release.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiRelease_Get")
  get is ArmResourceRead<ApiReleaseContract>;

  /**
   * Returns the etag of an API release.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiRelease_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiReleaseContract,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("ApiRelease_Update")
  update is ArmCustomPatchSync<
    ApiReleaseContract,
    ApiReleaseContract,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("ApiRelease_Delete")
  delete is ArmResourceDeleteSync<
    ApiReleaseContract,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiRelease_ListByService")
  listByService is ArmResourceListByParent<
    ApiReleaseContract,
    Parameters = {
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
    },
    Response = ApiReleaseListResult
  >;
}

@@maxLength(ApiReleaseContract.name, 80);
@@minLength(ApiReleaseContract.name, 1);
@@doc(ApiReleaseContract.name,
  "Release identifier within an API. Must be unique in the current API Management service instance."
);
@@doc(ApiReleaseContract.properties, "ApiRelease entity contract properties.");
@@doc(ApiReleaseContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@doc(ApiReleaseContracts.update::parameters.properties,
  "API Release Update parameters."
);
