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
 * NamedValue details.
 */
@parentResource(ApiManagementServiceResource)
model NamedValueContract is ProxyResource<NamedValueContractProperties> {
  /**
   * Identifier of the NamedValue.
   */
  @maxLength(256)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("namedValueId")
  @segment("namedValues")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface NamedValueContracts {
  /**
   * Gets the details of the named value specified by its identifier.
   */
  get is ArmResourceRead<NamedValueContract>;

  /**
   * Gets the entity state (Etag) version of the named value specified by its identifier.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      NamedValueContract,
      BaseParameters<NamedValueContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or updates named value.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    NamedValueContract,
    {
      ...BaseParameters<NamedValueContract>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates the specific named value.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<
    NamedValueContract,
    NamedValueUpdateParameters,
    {
      ...BaseParameters<NamedValueContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes specific named value from the API Management service instance.
   */
  delete is ArmResourceDeleteSync<
    NamedValueContract,
    {
      ...BaseParameters<NamedValueContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists a collection of named values defined within a service instance.
   */
  listByService is ArmResourceListByParent<
    NamedValueContract,
    {
      ...BaseParameters<NamedValueContract>;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| tags | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith, any, all |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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

      /**
       * When set to true, the response contains only named value entities which failed refresh.
       */
      @query("isKeyVaultRefreshFailed")
      isKeyVaultRefreshFailed?: boolean;
    }
  >;

  /**
   * Gets the secret of the named value specified by its identifier.
   */
  listValue is ArmResourceActionSync<
    NamedValueContract,
    void,
    NamedValueSecretContract
  >;

  /**
   * Refresh the secret of the named value specified by its identifier.
   */
  refreshSecret is ArmResourceActionAsync<
    NamedValueContract,
    void,
    NamedValueContract
  >;
}

@@doc(NamedValueContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@doc(NamedValueContracts.update::parameters.properties, "Update parameters.");
