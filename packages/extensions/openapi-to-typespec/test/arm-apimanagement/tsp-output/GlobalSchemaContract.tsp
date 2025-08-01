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
 * Global Schema Contract details.
 */
@parentResource(ApiManagementServiceResource)
model GlobalSchemaContract
  is Azure.ResourceManager.ProxyResource<GlobalSchemaContractProperties> {
  ...ResourceNameParameter<
    Resource = GlobalSchemaContract,
    KeyName = "schemaId",
    SegmentName = "schemas",
    NamePattern = ""
  >;
}

@armResourceOperations
interface GlobalSchemaContracts {
  /**
   * Gets the details of the Schema specified by its identifier.
   */
  get is ArmResourceRead<GlobalSchemaContract>;

  /**
   * Gets the entity state (Etag) version of the Schema specified by its identifier.
   */
  getEntityTag is ArmResourceCheckExistence<GlobalSchemaContract>;

  /**
   * Creates new or updates existing specified Schema of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    GlobalSchemaContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    },
    Response = ArmResourceUpdatedResponse<GlobalSchemaContract> | ArmResourceCreatedResponse<
      GlobalSchemaContract,
      ArmLroLocationHeader<FinalResult = GlobalSchemaContract> &
        Azure.Core.Foundations.RetryAfterHeader
    > | ArmAcceptedLroResponse
  >;

  /**
   * Deletes specific Schema.
   */
  delete is ArmResourceDeleteSync<
    GlobalSchemaContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists a collection of schemas registered with service instance.
   */
  listByService is ArmResourceListByParent<
    GlobalSchemaContract,
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

@@maxLength(GlobalSchemaContract.name, 80);
@@minLength(GlobalSchemaContract.name, 1);
@@doc(GlobalSchemaContract.name,
  "Schema id identifier. Must be unique in the current API Management service instance."
);
@@doc(GlobalSchemaContract.properties, "Properties of the Global Schema.");
@@doc(GlobalSchemaContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
