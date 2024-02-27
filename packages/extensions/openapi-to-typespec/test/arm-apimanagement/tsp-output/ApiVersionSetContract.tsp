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
 * API Version Set Contract details.
 */
@parentResource(ApiManagementServiceResource)
model ApiVersionSetContract is ProxyResource<ApiVersionSetContractProperties> {
  /**
   * Api Version Set identifier. Must be unique in the current API Management service instance.
   */
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("versionSetId")
  @segment("apiVersionSets")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface ApiVersionSetContracts {
  /**
   * Gets the details of the Api Version Set specified by its identifier.
   */
  get is ArmResourceRead<ApiVersionSetContract>;

  /**
   * Gets the entity state (Etag) version of the Api Version Set specified by its identifier.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiVersionSetContract,
      BaseParameters<ApiVersionSetContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or Updates a Api Version Set.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiVersionSetContract,
    {
      ...BaseParameters<ApiVersionSetContract>;

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
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    ApiVersionSetContract,
    ApiVersionSetUpdateParameters,
    {
      ...BaseParameters<ApiVersionSetContract>;

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
  delete is ArmResourceDeleteSync<
    ApiVersionSetContract,
    {
      ...BaseParameters<ApiVersionSetContract>;

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
  listByService is ArmResourceListByParent<
    ApiVersionSetContract,
    {
      ...BaseParameters<ApiVersionSetContract>;

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

@@doc(ApiVersionSetContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@doc(ApiVersionSetContracts.update::parameters.properties,
  "Update parameters."
);
