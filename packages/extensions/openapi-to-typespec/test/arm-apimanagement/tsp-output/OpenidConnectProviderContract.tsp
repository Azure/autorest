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
 * OpenId Connect Provider details.
 */
@parentResource(ApiManagementServiceResource)
model OpenidConnectProviderContract
  is Azure.ResourceManager.ProxyResource<OpenidConnectProviderContractProperties> {
  ...ResourceNameParameter<
    Resource = OpenidConnectProviderContract,
    KeyName = "opid",
    SegmentName = "openidConnectProviders",
    NamePattern = "^[^*#&+:<>?]+$"
  >;
}

@armResourceOperations
interface OpenidConnectProviderContracts {
  /**
   * Gets specific OpenID Connect Provider without secrets.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OpenIdConnectProvider_Get")
  get is ArmResourceRead<OpenidConnectProviderContract>;

  /**
   * Gets the entity state (Etag) version of the openIdConnectProvider specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @head
  @operationId("OpenIdConnectProvider_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      OpenidConnectProviderContract,
      BaseParameters<OpenidConnectProviderContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or updates the OpenID Connect Provider.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OpenIdConnectProvider_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    OpenidConnectProviderContract,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("OpenIdConnectProvider_Update")
  update is ArmCustomPatchSync<
    OpenidConnectProviderContract,
    OpenidConnectProviderUpdateContract,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("OpenIdConnectProvider_Delete")
  delete is ArmResourceDeleteSync<
    OpenidConnectProviderContract,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OpenIdConnectProvider_ListByService")
  listByService is ArmResourceListByParent<
    OpenidConnectProviderContract,
    Parameters = {
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
    },
    Response = OpenIdConnectProviderListResult
  >;

  /**
   * Gets the client secret details of the OpenID Connect Provider.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OpenIdConnectProvider_ListSecrets")
  listSecrets is ArmResourceActionSync<
    OpenidConnectProviderContract,
    void,
    ClientSecretContract
  >;
}

@@maxLength(OpenidConnectProviderContract.name, 256);
@@doc(OpenidConnectProviderContract.name,
  "Identifier of the OpenID Connect Provider."
);
@@doc(OpenidConnectProviderContract.properties,
  "OpenId Connect Provider contract properties."
);
@@doc(OpenidConnectProviderContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@doc(OpenidConnectProviderContracts.update::parameters.properties,
  "Update parameters."
);
