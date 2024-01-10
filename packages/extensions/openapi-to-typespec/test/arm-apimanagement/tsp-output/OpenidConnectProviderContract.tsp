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
@doc("OpenId Connect Provider details.")
@parentResource(ApiManagementServiceResource)
model OpenidConnectProviderContract
  is ProxyResource<OpenidConnectProviderContractProperties> {
  @doc("Identifier of the OpenID Connect Provider.")
  @maxLength(256)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("opid")
  @segment("openidConnectProviders")
  name: string;
}

@armResourceOperations
interface OpenidConnectProviderContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets specific OpenID Connect Provider without secrets.")
  @operationId("OpenIdConnectProvider_Get")
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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates or updates the OpenID Connect Provider.")
  @operationId("OpenIdConnectProvider_CreateOrUpdate")
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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates the specific OpenID Connect Provider.")
  @operationId("OpenIdConnectProvider_Update")
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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes specific OpenID Connect Provider of the API Management service instance.")
  @operationId("OpenIdConnectProvider_Delete")
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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists of all the OpenId Connect Providers.")
  @operationId("OpenIdConnectProvider_ListByService")
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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the client secret details of the OpenID Connect Provider.")
  @operationId("OpenIdConnectProvider_ListSecrets")
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
