# Swagger HelloWorld #

Swagger is written in JSON. The spec must conform to the [Swagger schema](https://raw.githubusercontent.com/swagger-api/swagger-spec/master/schemas/v2.0/schema.json).
Let's put together a minimal spec to document the service.

Every Swagger spec starts with a field declaring the version of Swagger being used. AutoRest supports version 2.0.
```
{
"swagger": "2.0"
```

The `info` object is required. The two required fields are title and version.
AutoRest uses the title as the class name of the generated client library. 
```
"info": {
    "title": "Client01",
    "version": "1.0.0"
},
```
Next, we include the name of the host. The Swagger schema doesn't require the host. If it is not provided, it is assumed that the document is being retrieved from the host that also serves the API. In the following examples, we include the host explicitly. The value can specify the hostname or ip address and a port value if needed. 
```
"host": "swaggersample.azurewebsites.net",
```
The `paths` object is a collection of individual paths and details about the operations, parameters, and responses.
```
"paths": {
...
}
```
The HelloWorld operation is exposed at
```
"/api/HelloWorld": {
```
The HelloWorld API only defined one operation. It is using the GET verb.
```
  "get": {
```    
We also include an `operationId` . The value is used by AutoRest to name the methods generating for accessing this endpoint with this verb. The Swagger schema itself does not require `operationId` but without it, automatically provisioned names can become too long or too generic. 
```
  "operationId": "GetGreeting",
```
Next, we document the mime types that the operation returns. Here, we are just specifying that we expect a JSON result.
```
  "produces": [
    "application/json"
  ],
```
Swagger allows specifying different types of responses per HTTP status code. For HelloWorld, we expect a 200 ("OK") and just a string. It is required by the Swagger schema that the response definition include a description. AutoRest uses it in the generated code as comments for the method. In Visual Studio, they are visible as tooltips. 
```
  "responses": {
    "200": {
      "description": "GETs a greeting.",
      "schema": {
        "type": "string"
      }
    }
  }
```
Because we haven't defined any other status codes or provided a `default` response schema, the AutoRest-generated client will throw an exception if the response it gets is not a 200 OK.

By convention, Swagger documents are exposed by web services with the name `swagger.json`.  Here, we are using a naming convention to make it easier to keep track of multiple examples. The title from the `info` object is *Client01* and we put it all together in a file named *swagger01.json* that looks like this:
```
{
  "swagger": "2.0",
  "info": {
    "title": "Client01",
    "version": "1.0.0"
  },
  "host": "swaggersample.azurewebsites.net",
  "paths": {
    "/api/HelloWorld": {
      "get": {
        "operationId": "GetGreeting",
        "produces": [
          "application/json"
        ],
        "responses": {
          "200": {
            "description": "GETs a greeting.",
            "schema": {
              "type": "string"
            }
          }
        }
      }
    }
  }
}
```