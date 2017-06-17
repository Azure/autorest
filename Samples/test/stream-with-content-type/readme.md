# Making the `Content-Type` request header customizable if the body is a (binary) stream

> see https://aka.ms/autorest

## Problem

If and (currently) only if the request body is a stream, one may want to specify as a parameter what the content type of that stream is.
A common use case could be an API expecting images, where the content type may actually be necessary to decode the stream correctly.
Another example could be a file API that wants to store the content type together with the file uploaded as a stream.
By default, AutoRest generated clients will/should send a content type header derived from the `consumes` definition.

Overriding this behavior is controversial:
According to the OpenAPI standard, a header parameter named `Content-Type` is to be ignored.
While AutoRest did not ignore such a parameter in the past, at least the C# generator generated failing code, as `System.Net.Http.HttpRequestMessage` rejects any attempt to simply "add" a header named `Content-Type`.
One is supposed to set the dedicated property instead.

## Solution

The C# generator no longer tries to simply set a custom `Content-Type` header, preventing the runtime failure.
In case of `Stream` request bodies, it will instead forward the parameter to the appropriate property when building the request.
(Adding the same behavior to other types of request bodies is trivial now, but was not done intentionally, as we currently see more risk than value in doing so.)

To reduce duplication in the OpenAPI definition, a header parameter called `Content-Type` will automatically be enhanced with an `enum` definition populated with the `consumes` values of the operation.
This behavior is language agnostic!
Should the parameter already have an `enum` definition, this is of course not overwritten.

## Demo

The OpenAPI definition has a header parameter called `Content-Type` defined on multiple operations.
No explicit `enum` definitions were given, so the `consumes` values are injected.
As those `consumes` values happen to be the same across the operations, only one enum type is generated and shared.

``` yaml
input-file: stream-with-content-type.yaml
csharp:
  - output-folder: Client
```