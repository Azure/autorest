import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Contract details.")
@parentResource(ApiContract)
model TagDescriptionContract
  is ProxyResource<TagDescriptionContractProperties> {
  @doc("Tag description identifier. Used when creating tagDescription for API/Tag association. Based on API and Tag names.")
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @key("tagDescriptionId")
  @segment("tagDescriptions")
  name: string;
}

@armResourceOperations
interface ApiTagDescription {
  @doc("Get Tag description in scope of API")
  get is ArmResourceRead<TagDescriptionContract>;
  @doc("Gets the entity state version of the tag specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      TagDescriptionContract,
      BaseParameters<TagDescriptionContract>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Create/Update tag description in scope of the Api.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    TagDescriptionContract,
    {
      ...BaseParameters<TagDescriptionContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Delete tag description for the Api.")
  delete is ArmResourceDeleteSync<
    TagDescriptionContract,
    {
      ...BaseParameters<TagDescriptionContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists all Tags descriptions in scope of API. Model similar to swagger - tagDescription is defined on API level but tag may be assigned to the Operations")
  listByService is ArmResourceListByParent<
    TagDescriptionContract,
    {
      ...BaseParameters<TagDescriptionContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;
    }
  >;
}
