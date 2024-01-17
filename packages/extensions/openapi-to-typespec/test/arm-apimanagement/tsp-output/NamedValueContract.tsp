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
@doc("NamedValue details.")
@parentResource(ApiManagementServiceResource)
model NamedValueContract is ProxyResource<NamedValueContractProperties> {
  @doc("Identifier of the NamedValue.")
  @maxLength(256)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("namedValueId")
  @segment("namedValues")
  name: string;
}

@armResourceOperations
interface NamedValueContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the details of the named value specified by its identifier.")
  @operationId("NamedValue_Get")
  get is ArmResourceRead<NamedValueContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the named value specified by its identifier.")
  @head
  @operationId("NamedValue_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      NamedValueContract,
      BaseParameters<NamedValueContract>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates or updates named value.")
  @operationId("NamedValue_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    NamedValueContract,
    {
      ...BaseParameters<NamedValueContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    },
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates the specific named value.")
  @parameterVisibility("read")
  @operationId("NamedValue_Update")
  update is ArmCustomPatchAsync<
    NamedValueContract,
    NamedValueUpdateParameters,
    {
      ...BaseParameters<NamedValueContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    },
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes specific named value from the API Management service instance.")
  @operationId("NamedValue_Delete")
  delete is ArmResourceDeleteSync<
    NamedValueContract,
    {
      ...BaseParameters<NamedValueContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists a collection of named values defined within a service instance.")
  @operationId("NamedValue_ListByService")
  listByService is ArmResourceListByParent<
    NamedValueContract,
    {
      ...BaseParameters<NamedValueContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| tags | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith, any, all |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("When set to true, the response contains only named value entities which failed refresh.")
      @query("isKeyVaultRefreshFailed")
      isKeyVaultRefreshFailed?: boolean;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the secret of the named value specified by its identifier.")
  @operationId("NamedValue_ListValue")
  listValue is ArmResourceActionSync<
    NamedValueContract,
    void,
    NamedValueSecretContract
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Refresh the secret of the named value specified by its identifier.")
  @operationId("NamedValue_RefreshSecret")
  refreshSecret is ArmResourceActionAsync<
    NamedValueContract,
    void,
    NamedValueContract,
    BaseParameters<NamedValueContract>,
    ArmLroLocationHeader
  >;
}

@@projectedName(NamedValueContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(NamedValueContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(NamedValueContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@projectedName(NamedValueContracts.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(NamedValueContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(NamedValueContracts.update::parameters.properties, "Update parameters.");
