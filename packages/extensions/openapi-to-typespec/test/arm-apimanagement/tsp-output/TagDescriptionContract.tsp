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
 * Contract details.
 */
@parentResource(ApiContract)
model TagDescriptionContract
  is ProxyResource<TagDescriptionContractProperties> {
  /**
   * Tag description identifier. Used when creating tagDescription for API/Tag association. Based on API and Tag names.
   */
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("tagDescriptionId")
  @segment("tagDescriptions")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface TagDescriptionContracts {
  /**
   * Get Tag description in scope of API
   */
  get is ArmResourceRead<TagDescriptionContract>;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      TagDescriptionContract,
      BaseParameters<TagDescriptionContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Create/Update tag description in scope of the Api.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    TagDescriptionContract,
    {
      ...BaseParameters<TagDescriptionContract>;

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
  delete is ArmResourceDeleteSync<
    TagDescriptionContract,
    {
      ...BaseParameters<TagDescriptionContract>;

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
  listByService is ArmResourceListByParent<
    TagDescriptionContract,
    {
      ...BaseParameters<TagDescriptionContract>;

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

@@doc(TagDescriptionContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
