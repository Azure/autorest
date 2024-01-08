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
@doc("Diagnostic details.")
@parentResource(ApiContract)
model DiagnosticContract is ProxyResource<DiagnosticContractProperties> {
  @doc("Diagnostic identifier. Must be unique in the current API Management service instance.")
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @key("diagnosticId")
  @segment("diagnostics")
  name: string;
}

@armResourceOperations
@projectedName("client", "ApiDiagnostic")
interface DiagnosticContracts_ApiDiagnostic {
  @doc("Gets the details of the Diagnostic for an API specified by its identifier.")
  get is ArmResourceRead<DiagnosticContract>;
  @doc("Gets the entity state (Etag) version of the Diagnostic for an API specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      DiagnosticContract,
      BaseParameters<DiagnosticContract>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Creates a new Diagnostic for an API or updates an existing one.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    DiagnosticContract,
    {
      ...BaseParameters<DiagnosticContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Updates the details of the Diagnostic for an API specified by its identifier.")
  update is ArmCustomPatchSync<
    DiagnosticContract,
    DiagnosticContract,
    {
      ...BaseParameters<DiagnosticContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Deletes the specified Diagnostic from an API.")
  delete is ArmResourceDeleteSync<
    DiagnosticContract,
    {
      ...BaseParameters<DiagnosticContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists all diagnostics of an API.")
  listByService is ArmResourceListByParent<
    DiagnosticContract,
    {
      ...BaseParameters<DiagnosticContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
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
