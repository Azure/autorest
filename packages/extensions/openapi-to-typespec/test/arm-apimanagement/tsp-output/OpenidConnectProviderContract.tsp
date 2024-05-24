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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  OpenidConnectProviderContractProperties
)
model OpenidConnectProviderContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = OpenidConnectProviderContract,
    KeyName = "opid",
    SegmentName = "openidConnectProviders",
    NamePattern = "^[^*#&+:<>?]+$"
  >;

  /**
   * OpenId Connect Provider contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: OpenidConnectProviderContractProperties;
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
      ...Azure.ResourceManager.Foundations.BaseParameters<OpenidConnectProviderContract>;

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
      ...Azure.ResourceManager.Foundations.BaseParameters<OpenidConnectProviderContract>;

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
  @parameterVisibility
  @operationId("OpenIdConnectProvider_Update")
  update is ArmCustomPatchSync<
    OpenidConnectProviderContract,
    OpenidConnectProviderUpdateContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<OpenidConnectProviderContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("OpenIdConnectProvider_Delete")
  delete is ArmResourceDeleteSync<
    OpenidConnectProviderContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<OpenidConnectProviderContract>;

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
      ...Azure.ResourceManager.Foundations.BaseParameters<OpenidConnectProviderContract>;

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
      ...Azure.ResourceManager.Foundations.BaseParameters<OpenidConnectProviderContract>;

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

@@maxLength(OpenidConnectProviderContract.name, 256);
@@doc(OpenidConnectProviderContract.name,
  "Identifier of the OpenID Connect Provider."
);
@@encodedName(OpenidConnectProviderContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(OpenidConnectProviderContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(OpenidConnectProviderContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@encodedName(OpenidConnectProviderContracts.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(OpenidConnectProviderContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(OpenidConnectProviderContracts.update::parameters.properties,
  "Update parameters."
);
