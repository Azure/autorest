import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AutoRestPagingTestService;

interface PagingOperations {
  @doc("A paging operation that must return result of the default 'value' node.")
  @route("/paging/noitemname")
  @get
  getNoItemNamePages is Azure.Core.Foundations.Operation<
    {},
    ProductResultValue
  >;

  @doc("A paging operation that must ignore any kind of nextLink, and stop after page 1.")
  @route("/paging/nullnextlink")
  @get
  getNullNextLinkNamePages is Azure.Core.Foundations.Operation<
    {},
    ProductResult
  >;

  @doc("A paging operation that finishes on the first call without a nextlink")
  @route("/paging/single")
  @get
  getSinglePages is Azure.Core.Foundations.Operation<{}, ProductResult>;

  @doc("""
A paging operation whose first response's items list is empty, but still
returns a next link. Second (and final) call, will give you an items list of 1.
""")
  @route("/paging/firstResponseEmpty/1")
  @get
  firstResponseEmpty is Azure.Core.Foundations.Operation<
    {},
    ProductResultValue
  >;

  @doc("A paging operation that includes a nextLink that has 10 pages")
  @route("/paging/multiple")
  @get
  getMultiplePages is Azure.Core.Foundations.Operation<
    {
      @header `client-request-id`: string;

      @doc("Sets the maximum number of items to return in the response.")
      @header
      maxresults: int32;

      @doc("""
Sets the maximum time that the server can spend processing the request, in
seconds. The default is 30 seconds.
""")
      @header
      timeout: int32;
    },
    ProductResult
  >;

  @doc("""
A paging operation that includes a next operation. It has a different query
parameter from it's next operation nextOperationWithQueryParams. Returns a
ProductResult
""")
  @route("/paging/multiple/getWithQueryParams")
  @get
  getWithQueryParams is Azure.Core.Foundations.Operation<
    {
      @doc("A required integer query parameter. Put in value '100' to pass test.")
      @query
      requiredQueryParameter: int32;

      @doc("""
A constant. Must be True and will be passed as a query parameter to
nextOperationWithQueryParams
""")
      @query
      queryConstant: true;
    },
    ProductResult
  >;

  @doc("""
Define `filter` as a query param for all calls. However, the returned next link
will also include the `filter` as part of it. Make sure you don't end up
duplicating the `filter` param in the url sent.
""")
  @route("/paging/multiple/duplicateParams/1")
  @get
  duplicateParams is Azure.Core.Foundations.Operation<
    {
      @doc("OData filter options. Pass in 'foo'")
      @query
      $filter: string;
    },
    ProductResult
  >;

  @doc("Paging with max page size. We don't want to ")
  @route("/paging/maxPageSize")
  @get
  pageWithMaxPageSize is Azure.Core.Foundations.Operation<
    {
      @doc("Max page size query param. Don't send")
      @query
      $maxpagesize: "5";
    },
    ProductResult
  >;

  @doc("""
Next operation for getWithQueryParams. Pass in next=True to pass test. Returns
a ProductResult
""")
  @route("/paging/multiple/nextOperationWithQueryParams")
  @get
  nextOperationWithQueryParams is Azure.Core.Foundations.Operation<
    {
      @doc("A constant. Must be True")
      @query
      queryConstant: true;
    },
    ProductResult
  >;

  @doc("A paging operation that includes a nextLink in odata format that has 10 pages")
  @route("/paging/multiple/odata")
  @get
  getOdataMultiplePages is Azure.Core.Foundations.Operation<
    {
      @header `client-request-id`: string;

      @doc("Sets the maximum number of items to return in the response.")
      @header
      maxresults: int32;

      @doc("""
Sets the maximum time that the server can spend processing the request, in
seconds. The default is 30 seconds.
""")
      @header
      timeout: int32;
    },
    OdataProductResult
  >;

  @doc("A paging operation that includes a nextLink that has 10 pages")
  @route("/paging/multiple/withpath/{offset}")
  @get
  getMultiplePagesWithOffset is Azure.Core.Foundations.Operation<
    {
      @header `client-request-id`: string;

      @doc("Sets the maximum number of items to return in the response.")
      @header
      maxresults: int32;

      @doc("Offset of return value")
      @path
      offset: int32;

      @doc("""
Sets the maximum time that the server can spend processing the request, in
seconds. The default is 30 seconds.
""")
      @header
      timeout: int32;
    },
    ProductResult
  >;

  @doc("""
A paging operation that fails on the first call with 500 and then retries and
then get a response including a nextLink that has 10 pages
""")
  @route("/paging/multiple/retryfirst")
  @get
  getMultiplePagesRetryFirst is Azure.Core.Foundations.Operation<
    {},
    ProductResult
  >;

  @doc("""
A paging operation that includes a nextLink that has 10 pages, of which the 2nd
call fails first with 500. The client should retry and finish all 10 pages
eventually.
""")
  @route("/paging/multiple/retrysecond")
  @get
  getMultiplePagesRetrySecond is Azure.Core.Foundations.Operation<
    {},
    ProductResult
  >;

  @doc("A paging operation that receives a 400 on the first call")
  @route("/paging/single/failure")
  @get
  getSinglePagesFailure is Azure.Core.Foundations.Operation<{}, ProductResult>;

  @doc("A paging operation that receives a 400 on the second call")
  @route("/paging/multiple/failure")
  @get
  getMultiplePagesFailure is Azure.Core.Foundations.Operation<
    {},
    ProductResult
  >;

  @doc("A paging operation that receives an invalid nextLink")
  @route("/paging/multiple/failureuri")
  @get
  getMultiplePagesFailureUri is Azure.Core.Foundations.Operation<
    {},
    ProductResult
  >;

  @doc("A paging operation that doesn't return a full URL, just a fragment")
  @route("/paging/multiple/fragment/{tenant}")
  @get
  getMultiplePagesFragmentNextLink is Azure.Core.Foundations.Operation<
    {
      @doc("Sets the api version to use.")
      @query
      api_version: string;

      @doc("Sets the tenant to use.")
      @path
      tenant: string;
    },
    OdataProductResult
  >;

  @doc("""
A paging operation that doesn't return a full URL, just a fragment with
parameters grouped
""")
  @route("/paging/multiple/fragmentwithgrouping/{tenant}")
  @get
  getMultiplePagesFragmentWithGroupingNextLink is Azure.Core.Foundations.Operation<
    {
      @doc("Sets the api version to use.")
      @query
      api_version: string;

      @doc("Sets the tenant to use.")
      @path
      tenant: string;
    },
    OdataProductResult
  >;

  @doc("A long-running paging operation that includes a nextLink that has 10 pages")
  @route("/paging/multiple/lro")
  @post
  GetMultiplePagesLRO is Azure.Core.Foundations.Operation<
    {
      @header `client-request-id`: string;

      @doc("Sets the maximum number of items to return in the response.")
      @header
      maxresults: int32;

      @doc("""
Sets the maximum time that the server can spend processing the request, in
seconds. The default is 30 seconds.
""")
      @header
      timeout: int32;
    },
    ProductResult
  >;

  @doc("""
A paging operation with api version. When calling the next link, you want to
append your client's api version to the next link
""")
  @route("/paging/apiVersion/append/1")
  @get
  appendApiVersion is Azure.Core.Foundations.Operation<{}, ProductResult>;

  @doc("""
A paging operation with api version. When calling the next link, you want to
reformat it and override the returned api version with your client's api
version
""")
  @route("/paging/apiVersion/replace/1")
  @get
  replaceApiVersion is Azure.Core.Foundations.Operation<{}, ProductResult>;

  @doc("A paging operation that doesn't return a full URL, just a fragment")
  @route("/paging/multiple/fragment/{tenant}/{nextLink}")
  @get
  nextFragment is Azure.Core.Foundations.Operation<
    {
      @doc("Sets the api version to use.")
      @query
      api_version: string;

      @doc("Sets the tenant to use.")
      @path
      tenant: string;

      @doc("Next link for list operation.")
      @path
      nextLink: string;
    },
    OdataProductResult
  >;

  @doc("A paging operation that doesn't return a full URL, just a fragment")
  @route("/paging/multiple/fragmentwithgrouping/{tenant}/{nextLink}")
  @get
  nextFragmentWithGrouping is Azure.Core.Foundations.Operation<
    {
      @doc("Sets the api version to use.")
      @query
      api_version: string;

      @doc("Sets the tenant to use.")
      @path
      tenant: string;

      @doc("Next link for list operation.")
      @path
      nextLink: string;
    },
    OdataProductResult
  >;

  @doc("""
A paging operation that returns a paging model whose item name is is overriden
by x-ms-client-name 'indexes'.
""")
  @route("/paging/itemNameWithXMSClientName")
  @get
  getPagingModelWithItemNameWithXMSClientName is Azure.Core.Foundations.Operation<
    {},
    ProductResultValueWithXMSClientName
  >;
}
