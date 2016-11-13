# Error Handling
When errors are encountered while executing client operations, they are surfaced with an `HttpOperationException`. The exception includes the HTTP Request and Response objects as shown in this example:
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
Many services define models for error conditions. Use either the base type `RestException` or a model type to catch the exception:
```csharp
try
{
    pets = client.FindPets(null, -1);
}
catch (RestException ex)
{
    var request = ex.Request;
    var response = ex.Response;
}

try
{
    pets = client.FindPets(null, -1);
}
catch (PetException ex)
{
    var request = ex.Request;
    var response = ex.Response;
    var errorData = ex.Body;
    var message = errorData.Message;
}
```
