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
@parentResource(ApiManagementServiceResource)
model ApiVersionSetContract
  is Azure.ResourceManager.ProxyResource<ApiVersionSetContractProperties> {
  ...ResourceNameParameter<
    Resource = ApiVersionSetContract,
    KeyName = "versionSetId",
    SegmentName = "apiVersionSets",
    NamePattern = "^[^*#&+:<>?]+$"
  >;
}

@armResourceOperations
interface ApiVersionSetContracts {
  /**
   * Gets the details of the Api Version Set specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiVersionSet_Get")
  get is ArmResourceRead<ApiVersionSetContract>;

  /**
   * Gets the entity state (Etag) version of the Api Version Set specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiVersionSet_GetEntityTag")
  getEntityTag is ArmResourceCheckExistence<ApiVersionSetContract>;

  /**
   * Creates or Updates a Api Version Set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiVersionSet_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiVersionSetContract,
    Parameters = {
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
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    ApiVersionSetContract,
    PatchModel = ApiVersionSetUpdateParameters,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiVersionSet_Delete")
  delete is ArmResourceDeleteSync<
    ApiVersionSetContract,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiVersionSet_ListByService")
  listByService is ArmResourceListByParent<
    ApiVersionSetContract,
    Parameters = {
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
@@doc(ApiVersionSetContract.properties, "API VersionSet contract properties.");
@@doc(ApiVersionSetContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@doc(ApiVersionSetContracts.update::parameters.properties,
  "Update parameters."
);
