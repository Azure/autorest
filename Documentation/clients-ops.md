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
To access HTTP request and response information for a service operation, use the following method: 
```csharp
var petsResult = client.FindPetsWithOperationResponseAsync(null, 10, CancellationToken.None).Result;
```
To access the HTTP request:
```csharp
var request = petsResult.Request;
```
To access the HTTP response:
```csharp
var response = petsResult.Response;
```