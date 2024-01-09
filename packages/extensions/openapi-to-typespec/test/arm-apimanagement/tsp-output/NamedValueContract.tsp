import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("NamedValue details.")
@parentResource(ApiManagementServiceResource)
model NamedValueContract is ProxyResource<NamedValueContractProperties> {
  @doc("Identifier of the NamedValue.")
  @maxLength(256)
  @pattern("^[^*#&+:<>?]+$")
  @key("namedValueId")
  @segment("namedValues")
  name: string;
}

@armResourceOperations
@projectedName("client", "NamedValue")
interface NamedValueContracts_NamedValue {
  @doc("Gets the details of the named value specified by its identifier.")
  get is ArmResourceRead<NamedValueContract>;

  @doc("Gets the entity state (Etag) version of the named value specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      NamedValueContract,
      BaseParameters<NamedValueContract>
    >,
  ): OkResponse | ErrorResponse;

  @doc("Creates or updates named value.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<
    NamedValueContract,
    {
      ...BaseParameters<NamedValueContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  @doc("Updates the specific named value.")
  update is ArmCustomPatchAsync<
    NamedValueContract,
    NamedValueUpdateParameters,
    {
      ...BaseParameters<NamedValueContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  @doc("Deletes specific named value from the API Management service instance.")
  delete is ArmResourceDeleteSync<
    NamedValueContract,
    {
      ...BaseParameters<NamedValueContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  @doc("Lists a collection of named values defined within a service instance.")
  listByService is ArmResourceListByParent<
    NamedValueContract,
    {
      ...BaseParameters<NamedValueContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| tags | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith, any, all |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("When set to true, the response contains only named value entities which failed refresh.")
      @query("isKeyVaultRefreshFailed")
      isKeyVaultRefreshFailed?: boolean;
    }
  >;

  @doc("Gets the secret of the named value specified by its identifier.")
  listValue is ArmResourceActionSync<
    NamedValueContract,
    void,
    NamedValueSecretContract
  >;

  @doc("Refresh the secret of the named value specified by its identifier.")
  refreshSecret is ArmResourceActionAsync<
    NamedValueContract,
    void,
    NamedValueContract
  >;
}
