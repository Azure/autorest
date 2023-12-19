import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Api.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Diagnostic details.")
@parentResource(Api)
model ApiDiagnostic is ProxyResource<DiagnosticContractProperties> {
  @doc("Diagnostic identifier. Must be unique in the current API Management service instance.")
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("diagnosticId")
  @segment("diagnostics")
  name: string;
}

@armResourceOperations
interface ApiDiagnostics {
  @doc("Gets the details of the Diagnostic for an API specified by its identifier.")
  get is ArmResourceRead<ApiDiagnostic>;
  @doc("Gets the entity state (Etag) version of the Diagnostic for an API specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<ApiDiagnostic, BaseParameters<ApiDiagnostic>>,
  ): OkResponse | ErrorResponse;
  @doc("Creates a new Diagnostic for an API or updates an existing one.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiDiagnostic,
    {
      ...BaseParameters<ApiDiagnostic>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Updates the details of the Diagnostic for an API specified by its identifier.")
  update is ArmResourcePatchSync<
    ApiDiagnostic,
    DiagnosticContractProperties,
    {
      ...BaseParameters<ApiDiagnostic>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Deletes the specified Diagnostic from an API.")
  delete is ArmResourceDeleteSync<
    ApiDiagnostic,
    {
      ...BaseParameters<ApiDiagnostic>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists all diagnostics of an API.")
  listByService is ArmResourceListByParent<
    ApiDiagnostic,
    {
      ...BaseParameters<ApiDiagnostic>;

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
