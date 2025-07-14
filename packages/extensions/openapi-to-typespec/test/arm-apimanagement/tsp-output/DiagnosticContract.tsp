import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Diagnostic details.
 */
@parentResource(ApiContract)
model DiagnosticContract
  is Azure.ResourceManager.ProxyResource<DiagnosticContractProperties> {
  ...ResourceNameParameter<
    Resource = DiagnosticContract,
    KeyName = "diagnosticId",
    SegmentName = "diagnostics",
    NamePattern = "^[^*#&+:<>?]+$"
  >;
}

@armResourceOperations
interface DiagnosticContractOps
  extends Azure.ResourceManager.Legacy.LegacyOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,
        ...Azure.ResourceManager.Legacy.Provider,

        /** The name of the API Management service. */
        @path
        @segment("service")
        @key
        @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
        serviceName: string,

        /** API identifier. Must be unique in the current API Management service instance. */
        @path
        @segment("apis")
        @key
        apiId: string,
      },
      {
        /** Diagnostic identifier. Must be unique in the current API Management service instance. */
        @path
        @segment("diagnostics")
        @key
        @pattern("^[^*#&+:<>?]+$")
        diagnosticId: string,
      }
    > {}

@armResourceOperations
interface DiagnosticContracts {
  /**
   * Gets the details of the Diagnostic for an API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiDiagnostic_Get")
  get is DiagnosticContractOps.Read<DiagnosticContract>;

  /**
   * Gets the entity state (Etag) version of the Diagnostic for an API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiDiagnostic_GetEntityTag")
  getEntityTag is DiagnosticContractOps.CheckExistence<DiagnosticContract>;

  /**
   * Creates a new Diagnostic for an API or updates an existing one.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiDiagnostic_CreateOrUpdate")
  createOrUpdate is DiagnosticContractOps.CreateOrUpdateSync<
    DiagnosticContract,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @patch(#{ implicitOptionality: false })
  @operationId("ApiDiagnostic_Update")
  update is DiagnosticContractOps.CustomPatchSync<
    DiagnosticContract,
    PatchModel = DiagnosticContract,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiDiagnostic_Delete")
  delete is DiagnosticContractOps.DeleteSync<
    DiagnosticContract,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiDiagnostic_ListByService")
  listByService is DiagnosticContractOps.List<
    DiagnosticContract,
    Parameters = {
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
@armResourceOperations
interface DiagnosticOps
  extends Azure.ResourceManager.Legacy.LegacyOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,
        ...Azure.ResourceManager.Legacy.Provider,

        /** The name of the API Management service. */
        @path
        @segment("service")
        @key
        @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
        serviceName: string,
      },
      {
        /** Diagnostic identifier. Must be unique in the current API Management service instance. */
        @path
        @segment("diagnostics")
        @key
        @pattern("^[^*#&+:<>?]+$")
        diagnosticId: string,
      }
    > {}

@armResourceOperations
interface Diagnostic {
  /**
   * Gets the details of the Diagnostic specified by its identifier.
   */
  get is DiagnosticOps.Read<DiagnosticContract>;

  /**
   * Gets the entity state (Etag) version of the Diagnostic specified by its identifier.
   */
  getEntityTag is DiagnosticOps.CheckExistence<DiagnosticContract>;

  /**
   * Creates a new Diagnostic or updates an existing one.
   */
  createOrUpdate is DiagnosticOps.CreateOrUpdateSync<
    DiagnosticContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates the details of the Diagnostic specified by its identifier.
   */
  @patch(#{ implicitOptionality: false })
  update is DiagnosticOps.CustomPatchSync<
    DiagnosticContract,
    PatchModel = DiagnosticContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes the specified Diagnostic.
   */
  delete is DiagnosticOps.DeleteSync<
    DiagnosticContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists all diagnostics of the API Management service instance.
   */
  listByService is DiagnosticOps.List<
    DiagnosticContract,
    Parameters = {
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

@@maxLength(DiagnosticContract.name, 80);
@@minLength(DiagnosticContract.name, 1);
@@doc(DiagnosticContract.name,
  "Diagnostic identifier. Must be unique in the current API Management service instance."
);
@@doc(DiagnosticContract.properties, "Diagnostic entity contract properties.");
@@doc(DiagnosticContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@doc(DiagnosticContracts.update::parameters.properties,
  "Diagnostic Update parameters."
);
@@doc(Diagnostic.createOrUpdate::parameters.resource, "Create parameters.");
@@doc(Diagnostic.update::parameters.properties,
  "Diagnostic Update parameters."
);
