# HTTP Batch Support

## Background Information
Typically, users of REST services issue API calls individually - i.e., each API call is a separate HTTP request. However, some REST services provide a batch interface where users can bundle multiple, separate API calls into a _single_ HTTP call. It is easy to enable this in your Web API service by following these [instructions](https://blogs.msdn.microsoft.com/webdev/2013/11/01/introducing-batch-support-in-web-api-and-web-api-odata/).

Under this model, your client stuffs multiple API calls into a single HTTP request by making the body of the HTTP request a multipart content, and adding each HttpRequestMessage for each API call as one part of that content, and issuing the HTTP request to the batch URL. Instructions are [here](https://blogs.msdn.microsoft.com/webdev/2013/11/01/introducing-batch-support-in-web-api-and-web-api-odata/).

## Overview
[BatchDelegatingHandler](../ClientRuntimes/CSharp/Microsoft.Rest.ClientRuntime/BatchDelegatingHandler.cs) provides batch support in AutoRest. When attempting to do batch requests with an AutoRest generated client, you need to:
- instantiate the BatchDelegatingHandler class
- add it to an array of DelegatingHandler and pass that into the constructor for your AutoRest client
- call any of your async API calls inside your AutoRest client, just as if you were doing regular non-batch calls
- do not await them yet; once you are done setting up all of your async API calls for this batch, call IssueBatch on your instance of BatchDelegatingHandler. That will issue all those calls as a single batch, and properly return the appropriate response to all the tasks that were created in the previous step.
- now you can await the tasks from your individual API calls.
- if you wish to issue another batch call, call Reset() on your instance of BatchDelegatingHandler

There are four tricky parts to building this handler correctly:

1. The handler has to return tasks for each API call that will properly complete only after the batch request is later successfully issued to and returned by the web service.
2. The handler is handling multiple requests and multiple responses. It has to provide the relevant response to each request task upon completion.
3. The handler should not get into an async/await deadlock.
4. A batch call could have hundreds of single API calls inside it. The handler has to be efficient.

## Example
Below is an example of how you can use the BatchDelegatingHandler in a fictitious ContosoClient.
```csharp
// instantiate the handler
DelegatingHandler[] handlers = new DelegatingHandler[1];
Uri batchURL = new Uri("http://api.contoso.com/batch");
BatchDelegatingHandler batchHandler = new BatchDelegatingHandler(HttpMethod.Post, batchURL);
handlers[0] = batchHandler;

// instantiate the client, passing in the handler
Uri nonBatchURL = new Uri("http://api.contoso.com/");
ContosoClient myClient = new ContosoClient(nonBatchURL, handlers);

// request #1
Task<HttpOperationResponse<CustomerListResponse>> getCustomerListTask = myClient.Customers.GetCustomerListWithHttpMessagesAsync(appkey: "s3cr3tk3y");

// request #2
Task<HttpOperationResponse<SupplierListResponse>> getSupplierListTask = myClient.Suppliers.GetSupplierListWithHttpMessagesAsync(appkey: "s3cr3tk3y");

// issue the batch
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
```

## Limitations
- This is supported only in C# AutoRest clients.