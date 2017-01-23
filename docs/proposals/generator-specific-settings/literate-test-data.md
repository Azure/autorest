# Literate Test Data
 
## The File Format

The test file is a CommonMark (aka Markdown) file that contains code blocks containing **one** recorded HTTP request and corresponding response.

> Example: A canonical test file with descriptions and HTTP data.
> ~~~ markdown
> # RedisCache Create Example
> This is example traffic of a successful call to `RedisCache.Create`.
> 
> ## Request
> It is important that `x-ms-date` is specified.
> 
> ``` message (request)
> PUT /testaccount1/containersc5d3e7c5509046d2aa3f8bb095593T?timeout=30 HTTP/1.1
> Host: localhost:10000
> x-ms-version: 2016-05-31
> x-ms-date: Wed, 11 Jan 2017 09:16:29 GMT
> Content-Length: 122
> 
> <?xml version="1.0" encoding="utf-8"?>
> <Properties>
>   <Version>1.0</Version>
>   <Policy>WriteThrough</Policy>
> </Properties>
> ```
> 
> ## Response
> Note that the server returns a base64 encoded MD5 hash of the response body using the `Content-MD5` header.
> 
> ``` message (response)
> HTTP/1.1 201 Created
> Content-MD5: kUj/bysL3DMI21i/Avp62A==
> Server: Windows-Azure-Blob/1.0 Microsoft-HTTPAPI/2.0
> x-ms-version: 2016-05-31
> x-ms-request-server-encrypted: true
> Date: Wed, 11 Jan 2017 08:59:14 GMT
> 
> ```
> ~~~

### Naming code blocks
Code blocks have to be named `request` and `response` respectively, in order to identify their roles in the test.
> Syntax of named code blocks:
> ~~~ markdown
> ``` <syntax> (<name>)
> <code>
> ```
> ~~~

### Splitting header and body
In the presence of request/response bodies it may be desirable to provide better syntax highlighting, according to their media type (e.g. XML or JSON).
However, specifying the syntax of the `request`/`response` blocks would also interfere with the coloring of the HTTP headers.
There are two possible solutions for this problem:

#### Splitting the request/response (introduces dependence on the order of code blocks!)
The test parser would simply merge all code blocks named identically into one consecutive block (care must be taken regarding newlines at the boundaries).
> Example (YAML for the headers and XML for the body)
> ~~~
> ``` yaml (request)
> PUT /testaccount1/containersc5d3e7c5509046d2aa3f8bb095593T?timeout=30 HTTP/1.1
> Host: localhost:10000
> x-ms-version: 2016-05-31
> x-ms-date: Wed, 11 Jan 2017 09:16:29 GMT
> Content-Length: 122
>
> ```
> 
> ``` XML (request)
> <?xml version="1.0" encoding="utf-8"?>
> <Properties>
>   <Version>1.0</Version>
>   <Policy>WriteThrough</Policy>
> </Properties>
> ```
> ~~~

#### More fine grained named code blocks
The test parser would reconstruct the request from more fine grained the named parts (e.g. `request-header` and `request-body` instead of `request`).
This would be an optional feature (i.e. if a block named `request` is found, more fine grained blocks are *not* searched for).
> Example (reordered, no reliance on whitespace)
> ~~~
> ``` XML (request-body)
> <?xml version="1.0" encoding="utf-8"?>
> <Properties>
>   <Version>1.0</Version>
>   <Policy>WriteThrough</Policy>
> </Properties>
> ```
>
> ``` yaml (request-header)
> PUT /testaccount1/containersc5d3e7c5509046d2aa3f8bb095593T?timeout=30 HTTP/1.1
> Host: localhost:10000
> x-ms-version: 2016-05-31
> x-ms-date: Wed, 11 Jan 2017 09:16:29 GMT
> Content-Length: 122
> ```
> ~~~