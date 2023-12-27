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
@doc("OpenId Connect Provider details.")
@parentResource(ApiManagementServiceResource)
model OpenidConnectProviderContract
  is ProxyResource<OpenidConnectProviderContractProperties> {
  @doc("Identifier of the OpenID Connect Provider.")
  @maxLength(256)
  @pattern("^[^*#&+:<>?]+$")
  @key("opid")
  @segment("openidConnectProviders")
  name: string;
}

@armResourceOperations
interface OpenIdConnectProvider {
  @doc("Gets specific OpenID Connect Provider without secrets.")
  get is ArmResourceRead<
    OpenidConnectProviderContract,
    {
      ...BaseParameters<OpenidConnectProviderContract>;

      @doc("Identifier of the OpenID Connect Provider.")
      @maxLength(256)
      @pattern("^[^*#&+:<>?]+$")
      @path
      OpenId: string;
    }
  >;
  @doc("Creates or updates the OpenID Connect Provider.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    OpenidConnectProviderContract,
    {
      ...BaseParameters<OpenidConnectProviderContract>;

      @doc("Identifier of the OpenID Connect Provider.")
      @maxLength(256)
      @pattern("^[^*#&+:<>?]+$")
      @path
      OpenId: string;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Updates the specific OpenID Connect Provider.")
  update is ArmCustomPatchSync<
    OpenidConnectProviderContract,
    OpenidConnectProviderUpdateContract,
    {
      ...BaseParameters<OpenidConnectProviderContract>;

      @doc("Identifier of the OpenID Connect Provider.")
      @maxLength(256)
      @pattern("^[^*#&+:<>?]+$")
      @path
      OpenId: string;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Deletes specific OpenID Connect Provider of the API Management service instance.")
  delete is ArmResourceDeleteSync<
    OpenidConnectProviderContract,
    {
      ...BaseParameters<OpenidConnectProviderContract>;

      @doc("Identifier of the OpenID Connect Provider.")
      @maxLength(256)
      @pattern("^[^*#&+:<>?]+$")
      @path
      OpenId: string;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists of all the OpenId Connect Providers.")
  listByService is ArmResourceListByParent<
    OpenidConnectProviderContract,
    {
      ...BaseParameters<OpenidConnectProviderContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
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
  @doc("Gets the client secret details of the OpenID Connect Provider.")
  listSecrets is ArmResourceActionSync<
    OpenidConnectProviderContract,
    void,
    ClientSecretContract,
    {
      ...BaseParameters<OpenidConnectProviderContract>;

      @doc("Identifier of the OpenID Connect Provider.")
      @maxLength(256)
      @pattern("^[^*#&+:<>?]+$")
      @path
      OpenId: string;
    }
  >;
}
