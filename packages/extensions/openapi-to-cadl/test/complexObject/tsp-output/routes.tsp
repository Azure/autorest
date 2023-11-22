import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace ComplexModelClient;

@summary("Product Types")
@doc("""
The Products endpoint returns information about the Uber products offered at a
given location. The response includes the display name and other details about
each product, and lists the products in the proper display order.
""")
@route("/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/Microsoft.Cache/Redis")
@get
op list is Azure.Core.Foundations.Operation<
  {
    @doc("Subscription ID.")
    @path
    subscriptionId: "123456";

    @doc("Resource Group ID.")
    @path
    resourceGroupName: string;
  },
  CatalogArray
>;

@summary("Create products")
@doc("Resets products.")
@route("/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/Microsoft.Cache/Redis")
@post
op create is Azure.Core.Foundations.Operation<
  {
    @doc("Subscription ID.")
    @path
    subscriptionId: string;

    @doc("Resource Group ID.")
    @path
    resourceGroupName: string;

    @doc("body Parameter")
    @body
    bodyParameter: CatalogDictionaryOfArray;
  },
  CatalogDictionary
>;

@summary("Update products")
@doc("Resets products.")
@route("/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/Microsoft.Cache/Redis")
@put
op update is Azure.Core.Foundations.Operation<
  {
    @doc("Subscription ID.")
    @path
    subscriptionId: string;

    @doc("Resource Group ID.")
    @path
    resourceGroupName: string;

    @doc("body Parameter")
    @body
    bodyParameter: CatalogArrayOfDictionary;
  },
  CatalogArray
>;
