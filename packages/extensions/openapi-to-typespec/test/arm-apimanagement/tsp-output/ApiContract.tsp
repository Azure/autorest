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
 * API details.
 */
@parentResource(ApiManagementServiceResource)
model ApiContract
  is Azure.ResourceManager.ProxyResource<ApiContractProperties> {
  ...ResourceNameParameter<
    Resource = ApiContract,
    KeyName = "apiId",
    SegmentName = "apis",
    NamePattern = "^[^*#&+:<>?]+$"
  >;
}

@armResourceOperations
interface ApiContracts {
  /**
   * Gets the details of the API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Api_Get")
  get is ArmResourceRead<ApiContract>;

  /**
   * Gets the entity state (Etag) version of the API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @head
  @operationId("Api_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<ApiContract, BaseParameters<ApiContract>>,
  ): OkResponse | ErrorResponse;

  /**
   * Creates new or updates existing specified API of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "For backward compatibility"
  @operationId("Api_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    ApiContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    },
    Response = ArmResourceCreatedResponse<ApiContract> | ArmResourceUpdatedResponse<ApiContract> | ArmAcceptedLroResponse
  >;

  /**
   * Updates the specified API of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("Api_Update")
  update is ArmCustomPatchSync<
    ApiContract,
    ApiUpdateContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes the specified API of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Api_Delete")
  delete is ArmResourceDeleteSync<
    ApiContract,
    Parameters = {
      /**
       * Delete all revisions of the Api.
       */
      @query("deleteRevisions")
      deleteRevisions?: boolean;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists all APIs of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Api_ListByService")
  listByService is ArmResourceListByParent<
    ApiContract,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| serviceUrl | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| path | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| isCurrent | filter | eq, ne |  |</br>
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

      /**
       * Include full ApiVersionSet resource in response
       */
      @query("expandApiVersionSet")
      expandApiVersionSet?: boolean;
    },
    Response = ApiListResult
  >;

  /**
   * Lists all revisions of an API.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @operationId("ApiRevision_ListByService")
  apiRevisionListByService is ArmResourceActionSync<
    ApiContract,
    void,
    ApiRevisionListResult,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| apiRevision | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
   * Lists all Products, which the API is part of.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @operationId("ApiProduct_ListByApis")
  listByApis is ArmResourceActionSync<
    ApiContract,
    void,
    ProductListResult,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
   * Lists a collection of operations associated with tags.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @operationId("Operation_ListByTags")
  listByTags is ArmResourceActionSync<
    ApiContract,
    void,
    TagResourceListResult,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| apiName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| method | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| urlTemplate | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
       * Include not tagged Operations.
       */
      @query("includeNotTaggedOperations")
      includeNotTaggedOperations?: boolean;
    }
  >;
}

@@maxLength(ApiContract.name, 256);
@@minLength(ApiContract.name, 1);
@@doc(ApiContract.name,
  "API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number."
);
@@doc(ApiContract.properties, "API entity contract properties.");
@@doc(ApiContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@doc(ApiContracts.update::parameters.properties,
  "API Update Contract parameters."
);
