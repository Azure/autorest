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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(ProductContractProperties)
model ProductContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = ProductContract,
    KeyName = "productId",
    SegmentName = "products",
    NamePattern = ""
  >;

  /**
   * Product entity contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: ProductContractProperties;
}

@armResourceOperations
interface ProductContracts {
  /**
   * Gets the details of the product specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Product_Get")
  get is ArmResourceRead<ProductContract>;

  /**
   * Gets the entity state (Etag) version of the product specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Product_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ProductContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ProductContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("Product_Update")
  update is ArmCustomPatchSync<
    ProductContract,
    ProductUpdateParameters,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ProductContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Product_Delete")
  delete is ArmResourceDeleteSync<
    ProductContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ProductContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Product_ListByService")
  listByService is ArmResourceListByParent<
    ProductContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ProductContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ProductApi_ListByProduct")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis")
  @get
  listByProduct(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the API Management service.
     */
    @maxLength(50)
    @minLength(1)
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    @path
    serviceName: string,

    /**
     * Product identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    productId: string,

    /**
     * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| serviceUrl | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| path | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
     */
    @query("$filter")
    $filter?: string,

    /**
     * Number of records to return.
     */
    @minValue(1)
    @query("$top")
    $top?: int32,

    /**
     * Number of records to skip.
     */
    @query("$skip")
    $skip?: int32,

    ...SubscriptionIdParameter,
  ): ArmResponse<ApiManagementProductApiListResult> | ErrorResponse;

  /**
   * Lists the collection of developer groups associated with the specified product.
   */
  // FIXME: ProductGroup_ListByProduct could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ProductGroup_ListByProduct")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups")
  @get
  listByProduct(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the API Management service.
     */
    @maxLength(50)
    @minLength(1)
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    @path
    serviceName: string,

    /**
     * Product identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    productId: string,

    /**
     * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt |     |</br>| displayName | filter | eq, ne |     |</br>| description | filter | eq, ne |     |</br>
     */
    @query("$filter")
    $filter?: string,

    /**
     * Number of records to return.
     */
    @minValue(1)
    @query("$top")
    $top?: int32,

    /**
     * Number of records to skip.
     */
    @query("$skip")
    $skip?: int32,

    ...SubscriptionIdParameter,
  ): ArmResponse<ApiManagementProductGroupListResult> | ErrorResponse;

  /**
   * Lists the collection of subscriptions to the specified product.
   */
  // FIXME: ProductSubscriptions_List could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ProductSubscriptions_List")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/subscriptions")
  @get
  list(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the API Management service.
     */
    @maxLength(50)
    @minLength(1)
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    @path
    serviceName: string,

    /**
     * Product identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    productId: string,

    /**
     * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| stateComment | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| ownerId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| scope | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| userId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| productId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq |     |</br>| user | expand |     |     |</br>
     */
    @query("$filter")
    $filter?: string,

    /**
     * Number of records to return.
     */
    @minValue(1)
    @query("$top")
    $top?: int32,

    /**
     * Number of records to skip.
     */
    @query("$skip")
    $skip?: int32,

    ...SubscriptionIdParameter,
  ): ArmResponse<ResourceListResult<SubscriptionContract>> | ErrorResponse;
}

@@maxLength(ProductContract.name, 256);
@@minLength(ProductContract.name, 1);
@@doc(ProductContract.name,
  "Product identifier. Must be unique in the current API Management service instance."
);
@@encodedName(ProductContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(ProductContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(ProductContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@encodedName(ProductContracts.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(ProductContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(ProductContracts.update::parameters.properties, "Update parameters.");
