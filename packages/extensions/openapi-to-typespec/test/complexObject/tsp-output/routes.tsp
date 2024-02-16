import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace ComplexModelClient;

/**
 * The Products endpoint returns information about the Uber products offered at a
 * given location. The response includes the display name and other details about
 * each product, and lists the products in the proper display order.
 */
@summary("Product Types")
@route("/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/Microsoft.Cache/Redis")
@get
op list is Azure.Core.Foundations.Operation<
  {
    /**
     * Subscription ID.
     */
    @path
    subscriptionId: "123456";

    /**
     * Resource Group ID.
     */
    @path
    resourceGroupName: string;
  },
  CatalogArray
>;

/**
 * Resets products.
 */
@summary("Create products")
@route("/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/Microsoft.Cache/Redis")
@post
op create is Azure.Core.Foundations.Operation<
  {
    /**
     * Subscription ID.
     */
    @path
    subscriptionId: string;

    /**
     * Resource Group ID.
     */
    @path
    resourceGroupName: string;

    /**
     * body Parameter
     */
    @body
    bodyParameter: CatalogDictionaryOfArray;
  },
  CatalogDictionary
>;

/**
 * Resets products.
 */
@summary("Update products")
@route("/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/Microsoft.Cache/Redis")
@put
op update is Azure.Core.Foundations.Operation<
  {
    /**
     * Subscription ID.
     */
    @path
    subscriptionId: string;

    /**
     * Resource Group ID.
     */
    @path
    resourceGroupName: string;

    /**
     * body Parameter
     */
    @body
    bodyParameter: CatalogArrayOfDictionary;
  },
  CatalogArray
>;
