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
  get is ArmResourceRead<ProductContract>;

  /**
   * Gets the entity state (Etag) version of the product specified by its identifier.
   */
  getEntityTag is ArmResourceCheckExistence<ProductContract>;

  /**
   * Creates or Updates a product.
   */
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
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    ProductContract,
    PatchModel = ProductUpdateParameters,
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
    }
  >;

  /**
   * Lists a collection of the APIs associated with a product.
   */
  @list
  @get
  @action("apis")
  listByProduct is ArmResourceActionSync<
    ProductContract,
    void,
    ArmResponse<ResourceListResult<ProductApiData>>,
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
  @head
  @action("{apiId}")
  checkEntityExists is ArmResourceActionSync<
    ProductContract,
    void,
    NoContentResponse,
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
  @put
  @action("{apiId}")
  productApiCreateOrUpdate is ArmResourceActionSync<
    ProductContract,
    void,
    ArmResponse<ProductApiData> | ArmResourceCreatedSyncResponse<ProductApiData>,
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
  @delete
  @action("{apiId}")
  productApiDelete is ArmResourceActionSync<
    ProductContract,
    void,
    OkResponse | NoContentResponse,
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
  @list
  @get
  @action("groups")
  productGroupListByProduct is ArmResourceActionSync<
    ProductContract,
    void,
    ArmResponse<ResourceListResult<ProductGroupData>>,
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
  @head
  @action("{groupId}")
  productGroupCheckEntityExists is ArmResourceActionSync<
    ProductContract,
    void,
    NoContentResponse,
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
  @put
  @action("{groupId}")
  productGroupCreateOrUpdate is ArmResourceActionSync<
    ProductContract,
    void,
    ArmResponse<ProductGroupData> | ArmResourceCreatedSyncResponse<ProductGroupData>,
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
  @delete
  @action("{groupId}")
  productGroupDelete is ArmResourceActionSync<
    ProductContract,
    void,
    OkResponse | NoContentResponse,
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
  @list
  @get
  @action("subscriptions")
  list is ArmResourceActionSync<
    ProductContract,
    void,
    ArmResponse<ResourceListResult<SubscriptionContract>>,
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
