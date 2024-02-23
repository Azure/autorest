import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Diagnostic details.
 */
@parentResource(ApiContract)
model DiagnosticContract is ProxyResource<DiagnosticContractProperties> {
  /**
   * Diagnostic identifier. Must be unique in the current API Management service instance.
   */
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("diagnosticId")
  @segment("diagnostics")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface DiagnosticContracts {
  /**
   * Gets the details of the Diagnostic for an API specified by its identifier.
   */
  get is ArmResourceRead<DiagnosticContract>;

  /**
   * Gets the entity state (Etag) version of the Diagnostic for an API specified by its identifier.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      DiagnosticContract,
      BaseParameters<DiagnosticContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates a new Diagnostic for an API or updates an existing one.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    DiagnosticContract,
    {
      ...BaseParameters<DiagnosticContract>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates the details of the Diagnostic for an API specified by its identifier.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    DiagnosticContract,
    DiagnosticContract,
    {
      ...BaseParameters<DiagnosticContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes the specified Diagnostic from an API.
   */
  delete is ArmResourceDeleteSync<
    DiagnosticContract,
    {
      ...BaseParameters<DiagnosticContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists all diagnostics of an API.
   */
  listByService is ArmResourceListByParent<
    DiagnosticContract,
    {
      ...BaseParameters<DiagnosticContract>;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
}

@@doc(DiagnosticContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@doc(DiagnosticContracts.update::parameters.properties,
  "Diagnostic Update parameters."
);
