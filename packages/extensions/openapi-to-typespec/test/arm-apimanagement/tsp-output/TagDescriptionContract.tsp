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
 * Contract details.
 */
@parentResource(ApiContract)
model TagDescriptionContract
  is Azure.ResourceManager.ProxyResource<TagDescriptionContractProperties> {
  ...ResourceNameParameter<
    Resource = TagDescriptionContract,
    KeyName = "tagDescriptionId",
    SegmentName = "tagDescriptions",
    NamePattern = "^[^*#&+:<>?]+$"
  >;
}

@armResourceOperations
interface TagDescriptionContracts {
  /**
   * Get Tag description in scope of API
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiTagDescription_Get")
  get is ArmResourceRead<TagDescriptionContract>;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiTagDescription_GetEntityTag")
  getEntityTag is ArmResourceCheckExistence<TagDescriptionContract>;

  /**
   * Create/Update tag description in scope of the Api.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiTagDescription_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    TagDescriptionContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Delete tag description for the Api.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiTagDescription_Delete")
  delete is ArmResourceDeleteSync<
    TagDescriptionContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists all Tags descriptions in scope of API. Model similar to swagger - tagDescription is defined on API level but tag may be assigned to the Operations
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiTagDescription_ListByService")
  listByService is ArmResourceListByParent<
    TagDescriptionContract,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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

@@maxLength(TagDescriptionContract.name, 80);
@@minLength(TagDescriptionContract.name, 1);
@@doc(TagDescriptionContract.name,
  "Tag description identifier. Used when creating tagDescription for API/Tag association. Based on API and Tag names."
);
@@doc(TagDescriptionContract.properties,
  "TagDescription entity contract properties."
);
@@doc(TagDescriptionContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
