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
 * Product details.
 */
@parentResource(ApiManagementServiceResource)
model ProductContract
  is Azure.ResourceManager.ProxyResource<ProductContractProperties> {
  ...ResourceNameParameter<
    Resource = ProductContract,
    KeyName = "productId",
    SegmentName = "products",
    NamePattern = ""
  >;
}

@armResourceOperations
interface ProductContracts {
  /**
   * Gets the details of the product specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Product_Get")
  get is ArmResourceRead<ProductContract>;

  /**
   * Gets the entity state (Etag) version of the product specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @head
  @operationId("Product_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      ProductContract,
      BaseParameters<ProductContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or Updates a product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Product_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ProductContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Update existing product details.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("Product_Update")
  update is ArmCustomPatchSync<
    ProductContract,
    ProductUpdateParameters,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Delete product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Product_Delete")
  delete is ArmResourceDeleteSync<
    ProductContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;

      /**
       * Delete existing subscriptions associated with the product or not.
       */
      @query("deleteSubscriptions")
      deleteSubscriptions?: boolean;
    }
  >;

  /**
   * Lists a collection of products in the specified service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Product_ListByService")
  listByService is ArmResourceListByParent<
    ProductContract,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| terms | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq |     |</br>| groups | expand |     |     |</br>
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
       * When set to true, the response contains an array of groups that have visibility to the product. The default is false.
       */
      @query("expandGroups")
      expandGroups?: boolean;

      /**
       * Products which are part of a specific tag.
       */
      @query("tags")
      tags?: string;
    },
    Response = ProductListResult
  >;

  /**
   * Lists a collection of the APIs associated with a product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @operationId("ProductApi_ListByProduct")
  listByProduct is ArmResourceActionSync<
    ProductContract,
    void,
    ApiManagementProductApiListResult,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| serviceUrl | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| path | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
   * Checks that API entity specified by identifier is associated with the Product entity.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @head
  @operationId("ProductApi_CheckEntityExists")
  checkEntityExists is ArmResourceActionNoContentSync<
    ProductContract,
    void,
    Parameters = {
      /**
       * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
       */
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;
    }
  >;

  /**
   * Adds an API to the specified product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @put
  @operationId("ProductApi_CreateOrUpdate")
  productApiCreateOrUpdate is ArmResourceActionSync<
    ProductContract,
    void,
    ProductApiData,
    Parameters = {
      /**
       * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
       */
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;
    }
  >;

  /**
   * Deletes the specified API from the specified product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @delete
  @operationId("ProductApi_Delete")
  productApiDelete is ArmResourceActionSync<
    ProductContract,
    void,
    void,
    Parameters = {
      /**
       * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
       */
      @maxLength(256)
      @minLength(1)
      @pattern("^[^*#&+:<>?]+$")
      @path
      apiId: string;
    }
  >;

  /**
   * Lists the collection of developer groups associated with the specified product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @operationId("ProductGroup_ListByProduct")
  productGroupListByProduct is ArmResourceActionSync<
    ProductContract,
    void,
    ApiManagementProductGroupListResult,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt |     |</br>| displayName | filter | eq, ne |     |</br>| description | filter | eq, ne |     |</br>
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
   * Checks that Group entity specified by identifier is associated with the Product entity.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @head
  @operationId("ProductGroup_CheckEntityExists")
  productGroupCheckEntityExists is ArmResourceActionNoContentSync<
    ProductContract,
    void,
    Parameters = {
      /**
       * Group identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @path
      groupId: string;
    }
  >;

  /**
   * Adds the association between the specified developer group with the specified product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @put
  @operationId("ProductGroup_CreateOrUpdate")
  productGroupCreateOrUpdate is ArmResourceActionSync<
    ProductContract,
    void,
    ProductGroupData,
    Parameters = {
      /**
       * Group identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @path
      groupId: string;
    }
  >;

  /**
   * Deletes the association between the specified group and product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @delete
  @operationId("ProductGroup_Delete")
  productGroupDelete is ArmResourceActionSync<
    ProductContract,
    void,
    void,
    Parameters = {
      /**
       * Group identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @path
      groupId: string;
    }
  >;

  /**
   * Lists the collection of subscriptions to the specified product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @operationId("ProductSubscriptions_List")
  list is ArmResourceActionSync<
    ProductContract,
    void,
    SubscriptionListResult,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| stateComment | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| ownerId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| scope | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| userId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| productId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq |     |</br>| user | expand |     |     |</br>
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

@@maxLength(ProductContract.name, 256);
@@minLength(ProductContract.name, 1);
@@doc(ProductContract.name,
  "Product identifier. Must be unique in the current API Management service instance."
);
@@doc(ProductContract.properties, "Product entity contract properties.");
@@doc(ProductContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@doc(ProductContracts.update::parameters.properties, "Update parameters.");
