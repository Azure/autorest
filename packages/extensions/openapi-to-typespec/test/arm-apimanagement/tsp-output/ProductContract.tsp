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
/**
 * Product details.
 */
@parentResource(ApiManagementServiceResource)
model ProductContract is ProxyResource<ProductContractProperties> {
  /**
   * Product identifier. Must be unique in the current API Management service instance.
   */
  @maxLength(256)
  @minLength(1)
  @path
  @key("productId")
  @segment("products")
  @visibility("read")
  name: string;
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
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ProductContract,
      BaseParameters<ProductContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or Updates a product.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ProductContract,
    {
      ...BaseParameters<ProductContract>;

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
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    ProductContract,
    ProductUpdateParameters,
    {
      ...BaseParameters<ProductContract>;

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
    {
      ...BaseParameters<ProductContract>;

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
    {
      ...BaseParameters<ProductContract>;

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
  // FIXME: ProductApi_ListByProduct could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis")
  @get
  listByProduct is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Product identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

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

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    ApiManagementProductApiListResult
  >;

  /**
   * Lists the collection of developer groups associated with the specified product.
   */
  // FIXME: ProductGroup_ListByProduct could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups")
  @get
  listByProduct is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Product identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

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

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    ApiManagementProductGroupListResult
  >;

  /**
   * Lists the collection of subscriptions to the specified product.
   */
  // FIXME: ProductSubscriptions_List could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/subscriptions")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * Product identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(256)
      @minLength(1)
      @path
      productId: string;

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

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    ResourceListResult<SubscriptionContract>
  >;
}

@@doc(ProductContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@doc(ProductContracts.update::parameters.properties, "Update parameters.");
