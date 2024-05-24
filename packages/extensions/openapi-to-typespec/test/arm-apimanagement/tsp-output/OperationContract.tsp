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
 * API Operation details.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiContract)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(OperationContractProperties)
model OperationContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = OperationContract,
    KeyName = "operationId",
    SegmentName = "operations",
    NamePattern = ""
  >;

  /**
   * Properties of the Operation Contract.
   */
  @extension("x-ms-client-flatten", true)
  properties?: OperationContractProperties;
}

@armResourceOperations
interface OperationContracts {
  /**
   * Gets the details of the API Operation specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiOperation_Get")
  get is ArmResourceRead<OperationContract>;

  /**
   * Gets the entity state (Etag) version of the API operation specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("ApiOperation_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      OperationContract,
      BaseParameters<OperationContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates a new operation in the API or updates an existing one.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiOperation_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    OperationContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<OperationContract>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates the details of the operation in the API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("ApiOperation_Update")
  update is ArmCustomPatchSync<
    OperationContract,
    OperationUpdateContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<OperationContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes the specified operation in the API.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("ApiOperation_Delete")
  delete is ArmResourceDeleteSync<
    OperationContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<OperationContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists a collection of the operations for the specified API.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiOperation_ListByApi")
  listByApi is ArmResourceListByParent<
    OperationContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<OperationContract>;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| method | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| urlTemplate | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
       * Include tags in the response.
       */
      @query("tags")
      tags?: string;
    }
  >;
}

@@maxLength(OperationContract.name, 80);
@@minLength(OperationContract.name, 1);
@@doc(OperationContract.name,
  "Operation identifier within an API. Must be unique in the current API Management service instance."
);
@@encodedName(OperationContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(OperationContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(OperationContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@encodedName(OperationContracts.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(OperationContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(OperationContracts.update::parameters.properties,
  "API Operation Update parameters."
);
