# <img align="center" src="./images/logo.png"> Sample : Generating a client using AutoRest

First, download the petstore.json example file:

| Platform | Command |
|----|---|
|PowerShell|`iwr https://raw.githubusercontent.com/Azure/autorest/master/Samples/1b-code-generation-multilang/petstore.yaml -o petstore.yaml`|
|Linux/OS X|`curl -O https://raw.githubusercontent.com/Azure/autorest/master/Samples/1b-code-generation-multilang/petstore.yaml`|

Next, generate the client:
 
``` powershell
# generate the client
> autorest --input-file=petstore.yaml --csharp --output-folder=CSharp_PetStore --namespace=PetStore
The Microsoft.Rest.ClientRuntime.2.2.0 nuget package is required to compile the generated code.

# show what got generated:
> ls CSharp_PetStore -r

    Directory: ...\CSharp_PetStore

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----        2/24/2017  12:20 PM                Models
-a----        2/24/2017  12:20 PM          17657 ISwaggerPetstore.cs
-a----        2/24/2017  12:20 PM         133979 SwaggerPetstore.cs
-a----        2/24/2017  12:20 PM          36933 SwaggerPetstoreExtensions.cs

    Directory: ...\CSharp_PetStore\Models

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        2/24/2017  12:20 PM           2454 Category.cs
-a----        2/24/2017  12:20 PM           5214 Order.cs
-a----        2/24/2017  12:20 PM           6610 Pet.cs
-a----        2/24/2017  12:20 PM           2409 Tag.cs
-a----        2/24/2017  12:20 PM           6305 User.cs
-a----        2/24/2017  12:20 PM           4026 XmlSerialization.cs
``` 

