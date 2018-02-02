# Deprecated on operations, model types, properties and parameters

`deprecated` on operations is of course part of the [OpenAPI 2.0](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#fixed-fields-5) specification. For all other constructs, we've added `x-deprecated`: It accepts `true` or an object that can specify `description` or `replaced-by` to influence the deprecation message. Of course, `x-deprecated` also works on operations for the same reason of influencing the deprecation message.

> see https://aka.ms/autorest

``` yaml 
input-file: deprecated.yaml
csharp:
  - output-folder: ClientCSharp
go:
  - output-folder: ClientGo
java:
  - output-folder: ClientJava
nodejs:
  - output-folder: ClientNode
python:
  - output-folder: ClientPython
ruby:
  - output-folder: ClientRuby
typescript:
  - output-folder: ClientTypeScript
```