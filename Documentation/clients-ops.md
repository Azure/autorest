#Client Operations

## Calling operations
AutoRest provides both synchronous and asynchronous method overloads for each service operation. Use the following syntax to call the synchronous method:
```csharp
var pets = client.FindPets(null, 10);
```
Use the following syntax to call the asynchronous method:
```csharp
var petsTask = client.FindPetsAsync(null, 10);

...

if (petsTask.Wait(TimeSpan.FromSeconds(10)))
{
    pets = petsTask.Result;
}
```

## Getting HTTP request and response information
To access HTTP request and response information for a service operation, use the following method overload: 
```csharp
var petsResult = client.FindPetsAsync(null, 10, CancellationToken.None).Result;
```
To access the HTTP request:
```csharp
var request = petsResult.Request;
```
To access the HTTP response:
```csharp
var response = petsResult.Response;
```
## Handling errors
To access information about HTTP errors, including the HTTP request and response, use the `HttpOperationException` class as follows:
```csharp
try
{
    pets = client.FindPets(null, -1);
}
catch (HttpOperationException ex)
{
    var request = ex.Request;
    var response = ex.Response;
}
```
Many service operations have service specific error data, use the `HttpOperationException<T>` class to access this data:
```csharp
try
{
    pets = client.FindPets(null, -1);
}
catch (HttpOperationException<ErrorModel> ex)
{
    var errorData = ex.Body;
    var message = errorData.Message;
    var request = ex.Request;
    var response = ex.Response;
}
```
See [Error Modeling](swagger.md#error-modeling) for more information on modeling service specific errors.