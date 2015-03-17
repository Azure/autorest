# Error Handling
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