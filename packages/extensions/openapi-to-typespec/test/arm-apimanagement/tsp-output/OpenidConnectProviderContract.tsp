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
  name: string;
}

@armResourceOperations
interface OpenidConnectProviderContracts {
  /**
   * Gets specific OpenID Connect Provider without secrets.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("OpenIdConnectProvider_Get")
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("OpenIdConnectProvider_CreateOrUpdate")
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility("read")
  @operationId("OpenIdConnectProvider_Update")
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("OpenIdConnectProvider_Delete")
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("OpenIdConnectProvider_ListByService")
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("OpenIdConnectProvider_ListSecrets")
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

@@projectedName(OpenidConnectProviderContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(OpenidConnectProviderContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(OpenidConnectProviderContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@projectedName(OpenidConnectProviderContracts.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(OpenidConnectProviderContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(OpenidConnectProviderContracts.update::parameters.properties,
  "Update parameters."
);
