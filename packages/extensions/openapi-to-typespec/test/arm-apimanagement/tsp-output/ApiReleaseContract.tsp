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
@doc("ApiRelease details.")
@parentResource(ApiContract)
model ApiReleaseContract is ProxyResource<ApiReleaseContractProperties> {
  @doc("Release identifier within an API. Must be unique in the current API Management service instance.")
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("releaseId")
  @segment("releases")
  name: string;
}

@armResourceOperations
interface ApiReleaseContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Returns the details of an API release.")
  @operationId("ApiRelease_Get")
  get is ArmResourceRead<ApiReleaseContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Returns the etag of an API release.")
  @head
  @operationId("ApiRelease_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiReleaseContract,
      BaseParameters<ApiReleaseContract>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates a new Release for the API.")
  @operationId("ApiRelease_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiReleaseContract,
    {
      ...BaseParameters<ApiReleaseContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates the details of the release of the API specified by its identifier.")
  @parameterVisibility("read")
  @operationId("ApiRelease_Update")
  update is ArmCustomPatchSync<
    ApiReleaseContract,
    ApiReleaseContract,
    {
      ...BaseParameters<ApiReleaseContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes the specified release in the API.")
  @operationId("ApiRelease_Delete")
  delete is ArmResourceDeleteSync<
    ApiReleaseContract,
    {
      ...BaseParameters<ApiReleaseContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists all releases of an API. An API release is created when making an API Revision current. Releases are also used to rollback to previous revisions. Results will be paged and can be constrained by the $top and $skip parameters.")
  @operationId("ApiRelease_ListByService")
  listByService is ArmResourceListByParent<
    ApiReleaseContract,
    {
      ...BaseParameters<ApiReleaseContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| notes | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
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

@@projectedName(ApiReleaseContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(ApiReleaseContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(ApiReleaseContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@projectedName(ApiReleaseContracts.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(ApiReleaseContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(ApiReleaseContracts.update::parameters.properties,
  "API Release Update parameters."
);
