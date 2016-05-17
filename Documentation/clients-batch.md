# HTTP Batch Support

## Background Information
Typically, users of REST services issue API calls individually - i.e., each API call is a separate HTTP request. However, some REST services provide a batch interface where users can bundle multiple, separate API calls into a _single_ HTTP call. It is easy to enable this in your Web API service by following these [instructions](https://blogs.msdn.microsoft.com/webdev/2013/11/01/introducing-batch-support-in-web-api-and-web-api-odata/).

Under this model, your client stuffs multiple API calls into a single HTTP request by making the body of the HTTP request a multipart content, and adding each HttpRequestMessage for each API call as one part of that content, and issuing the HTTP request to the batch URL. Instructions are [here](https://blogs.msdn.microsoft.com/webdev/2013/11/01/introducing-batch-support-in-web-api-and-web-api-odata/).

This model conforms to the OData [3.0](http://www.odata.org/documentation/odata-version-3-0/batch-processing/) and [4.0](http://docs.oasis-open.org/odata/odata/v4.0/errata02/os/complete/part1-protocol/odata-v4.0-errata02-os-part1-protocol-complete.html#_Toc406398359) specifications for batch processing.

## Overview
[ODataBatchDelegatingHandler](../ClientRuntimes/CSharp/Microsoft.Rest.ClientRuntime/ODataBatchDelegatingHandler.cs) provides batch support in AutoRest. When attempting to do batch requests with an AutoRest generated client, you need to:
- instantiate the ODataBatchDelegatingHandler class
- add it to an array of DelegatingHandler and pass that into the constructor for your AutoRest client
- call any of your async API calls inside your AutoRest client, just as if you were doing regular non-batch calls
- do not await them yet; once you are done setting up all of your async API calls for this batch, call IssueBatch on your instance of ODataBatchDelegatingHandler. That will issue all those calls as a single batch, and properly return the appropriate response to all the tasks that were created in the previous step.
- now you can await the tasks from your individual API calls.
- if you wish to issue another batch call, call Reset() on your instance of ODataBatchDelegatingHandler

There are four tricky parts to building this handler correctly:

1. The handler has to return tasks for each API call that will properly complete only after the batch request is later successfully issued to and returned by the web service.
2. The handler is handling multiple requests and multiple responses. It has to provide the relevant response to each request task upon completion.
3. The handler should not get into an async/await deadlock.
4. A batch call could have hundreds of single API calls inside it. The handler has to be efficient.

## Example
Below is an example of how you can use the ODataBatchDelegatingHandler in a fictitious ContosoClient.
```csharp
// instantiate the handler
DelegatingHandler[] handlers = new DelegatingHandler[1];
ODataBatchDelegatingHandler batchHandler = new ODataBatchDelegatingHandler();
handlers[0] = batchHandler;

// instantiate the client, passing in the handler
Uri nonBatchURL = new Uri("http://api.contoso.com/");
ContosoClient myClient = new ContosoClient(nonBatchURL, handlers);

// request #1
Task<HttpOperationResponse<CustomerListResponse>> getCustomerListTask = myClient.Customers.GetCustomerListWithHttpMessagesAsync(appkey: "s3cr3tk3y");

// request #2
Task<HttpOperationResponse<SupplierListResponse>> getSupplierListTask = myClient.Suppliers.GetSupplierListWithHttpMessagesAsync(appkey: "s3cr3tk3y");

// issue the batch.
// because the batch URI was not specified when constructing ODataBatchDelegatingHandler,
// the batch call will be a POST to http://api.contoso.com/$batch
await batchHandler.IssueBatch();

// process response #1
HttpOperationResponse<CustomerListResponse> customersResponse = await getCustomerListTask;
if (customersResponse.IsSuccessStatusCode)
{
	Console.WriteLine("Got " + customersResponse.Body.Count + " customers");
}

// process response #2
HttpOperationResponse<SupplierListResponse> suppliersResponse = await getSupplierListTask;
if (suppliersResponse.IsSuccessStatusCode)
{
	Console.WriteLine("Got " + suppliersResponse.Body.Count + " suppliers");
}

// reset the batch handler and issue another batch of requests
batchHandler.Reset();
Task<HttpOperationResponse<ContractListResponse>> getContractListTask = myClient.Contracts.GetContractListWithHttpMessagesAsync(appkey: "s3cr3tk3y");
Task<HttpOperationResponse<NewCustomerResponse>> postNewCustomerTask = myClient.Customers.PostNewCustomerWithHttpMessagesAsync(appkey: "s3cr3tk3y", name: "John Smith");
await batchHandler.IssueBatch();
HttpOperationResponse<ContractListResponse> contractsResponse = await getContractListTask;
HttpOperationResponse<NewCustomerResponse> newCustomerResponse = await postNewCustomerTask;
```

## Limitations
- This is supported only in C# AutoRest clients.