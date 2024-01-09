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
@doc("ApiRelease details.")
@parentResource(ApiContract)
model ApiReleaseContract is ProxyResource<ApiReleaseContractProperties> {
  @doc("Release identifier within an API. Must be unique in the current API Management service instance.")
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @key("releaseId")
  @segment("releases")
  name: string;
}

@armResourceOperations
@projectedName("client", "ApiRelease")
interface ApiReleaseContracts_ApiRelease {
  @doc("Returns the details of an API release.")
  get is ArmResourceRead<ApiReleaseContract>;

  @doc("Returns the etag of an API release.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiReleaseContract,
      BaseParameters<ApiReleaseContract>
    >,
  ): OkResponse | ErrorResponse;

  @doc("Creates a new Release for the API.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiReleaseContract,
    {
      ...BaseParameters<ApiReleaseContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  @doc("Updates the details of the release of the API specified by its identifier.")
  update is ArmCustomPatchSync<
    ApiReleaseContract,
    ApiReleaseContract,
    {
      ...BaseParameters<ApiReleaseContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  @doc("Deletes the specified release in the API.")
  delete is ArmResourceDeleteSync<
    ApiReleaseContract,
    {
      ...BaseParameters<ApiReleaseContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  @doc("Lists all releases of an API. An API release is created when making an API Revision current. Releases are also used to rollback to previous revisions. Results will be paged and can be constrained by the $top and $skip parameters.")
  listByService is ArmResourceListByParent<
    ApiReleaseContract,
    {
      ...BaseParameters<ApiReleaseContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| notes | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
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
