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
 * OpenId Connect Provider details.
 */
@parentResource(ApiManagementServiceResource)
model OpenidConnectProviderContract
  is ProxyResource<OpenidConnectProviderContractProperties> {
  /**
   * Identifier of the OpenID Connect Provider.
   */
  @maxLength(256)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("opid")
  @segment("openidConnectProviders")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface OpenidConnectProviderContracts {
  /**
   * Gets specific OpenID Connect Provider without secrets.
   */
  get is ArmResourceRead<
    OpenidConnectProviderContract,
    {
      ...BaseParameters<OpenidConnectProviderContract>;

      /**
       * Identifier of the OpenID Connect Provider.
       */
      @maxLength(256)
      @pattern("^[^*#&+:<>?]+$")
      @path
      OpenId: string;
    }
  >;

  /**
   * Creates or updates the OpenID Connect Provider.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    OpenidConnectProviderContract,
    {
      ...BaseParameters<OpenidConnectProviderContract>;

      /**
       * Identifier of the OpenID Connect Provider.
       */
      @maxLength(256)
      @pattern("^[^*#&+:<>?]+$")
      @path
      OpenId: string;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates the specific OpenID Connect Provider.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    OpenidConnectProviderContract,
    OpenidConnectProviderUpdateContract,
    {
      ...BaseParameters<OpenidConnectProviderContract>;

      /**
       * Identifier of the OpenID Connect Provider.
       */
      @maxLength(256)
      @pattern("^[^*#&+:<>?]+$")
      @path
      OpenId: string;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes specific OpenID Connect Provider of the API Management service instance.
   */
  delete is ArmResourceDeleteSync<
    OpenidConnectProviderContract,
    {
      ...BaseParameters<OpenidConnectProviderContract>;

      /**
       * Identifier of the OpenID Connect Provider.
       */
      @maxLength(256)
      @pattern("^[^*#&+:<>?]+$")
      @path
      OpenId: string;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists of all the OpenId Connect Providers.
   */
  listByService is ArmResourceListByParent<
    OpenidConnectProviderContract,
    {
      ...BaseParameters<OpenidConnectProviderContract>;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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

  /**
   * Gets the client secret details of the OpenID Connect Provider.
   */
  listSecrets is ArmResourceActionSync<
    OpenidConnectProviderContract,
    void,
    ClientSecretContract,
    {
      ...BaseParameters<OpenidConnectProviderContract>;

      /**
       * Identifier of the OpenID Connect Provider.
       */
      @maxLength(256)
      @pattern("^[^*#&+:<>?]+$")
      @path
      OpenId: string;
    }
  >;
}

@@doc(OpenidConnectProviderContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@doc(OpenidConnectProviderContracts.update::parameters.properties,
  "Update parameters."
);
