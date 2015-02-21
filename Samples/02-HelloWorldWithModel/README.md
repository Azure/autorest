# RESTful API Greeting #

First, lets define a `Greeting` object that the REST API will return. It could just be a string, but in practice, API definitions revolve around the data types being handled. The `Greeting` object is a POCO model, meaning that we just care about the data it uses, not any operations on it. It has just one property, the `Salutation` string.
```
public class Greeting {
    public string Salutation { get; set; }
}
```
Next, we define the REST API that returns an instance of the `Greeting` object. It is created with a route definition of /api/Greetings using the HTTP Verb `GET`.
```
public class GreetingsController : ApiController {
    // GET: api/Greetings
    public Greeting Get() {
        Greeting result = new Greeting();
        result.Salutation = "Hello Swagger World.";
        return result;
    }
}
```
When the `Greeting` is serialized as JSON, it looks like this:
```
{
    "Salutation": "Hello Swagger World."
}
```
Next, let's look again at how the `Greeting` model object is represented in Swagger.
```
{
    "swagger": "2.0",
    "info": {
        "title": "HelloSwagger",
        "version": "1.0.0"
    },
    "host": "swaggersample.azurewebsites.net",
    "basePath": "/api",
    "paths": {
        "/greetings": {
            "get": {
                "operationId": "GetGreeting",
                "produces": [
                    "application/json"
                ],
               "responses": {
                    "200": {
                        "description": "A greeting.",
                        "schema": {
                            "$ref": "#/definitions/Greeting"
                        }
                    }
                }
            }
        }
    },
    "definitions": {
        "Greeting": {
            "properties": {
                "Salutation": {
                    "type": "string"
                }
            }
        }
    }
}

```

The `basePath` is also not required but as the usage is common. The `basePath` is appended to the `host` in forming the URL for every request.
```
    "basePath": "/api",
```