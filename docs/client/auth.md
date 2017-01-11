#Authentication
By default, AutoRest generates clients that make unauthenticated HTTP requests. When the [-AddCredentials](../user/cli.md) flag is set to `true`, the generated client will include a `Credentials` property of type [ServiceClientCredentials](../../ClientRuntimes/CSharp/Microsoft.Rest.ClientRuntime/ServiceClientCredentials.cs). The Microsoft.Rest.ClientRuntime package includes two ServiceClientCredentials : 

 * [`TokenCredentials`](../ClientRuntimes/CSharp/Microsoft.Rest.ClientRuntime/TokenCredentials.cs) - used for OAuth authentication.
 * [`BasicAuthenticationCredentials`](../ClientRuntimes/CSharp/Microsoft.Rest.ClientRuntime/BasicAuthenticationCredentials.cs) - used for basic username/password authentication.

Custom authentication behaviors can be implemented by inheriting from [ServiceClientCredentials](../ClientRuntimes/CSharp/Microsoft.Rest.ClientRuntime/ServiceClientCredentials.cs). The `ProcessHttpRequestAsync()` method is invoked for each HTTP request.

## Authenticating with Azure
In addition to using  [`TokenCredentials`](../ClientRuntimes/CSharp/Microsoft.Rest.ClientRuntime/TokenCredentials.cs) with raw OAuth token, a [Microsoft.Rest.ClientRuntime.Azure.Authentication](https://www.nuget.org/packages/Microsoft.Rest.ClientRuntime.Azure.Authentication/2.0.0-preview) nuget package can be used.

`Microsoft.Rest.ClientRuntime.Azure.Authentication` supports both username/password and service principal login scenarios.

**Login using service principal and certificate**

```csharp
using Microsoft.Rest.Azure.Authentication;
...

X509Certificate2Collection certificate = <load cert>;
byte[] certificateAsBytes = certificate.Export(X509ContentType.Pkcs12, _certificatePassword);
ServiceClientCredentials creds = await ApplicationTokenProvider.LoginSilentAsync("<mydomain>", "<client_id>", certificateAsBytes, _certificatePassword);
```

**Login using username and password**

```csharp
using Microsoft.Rest.Azure.Authentication;
...

ServiceClientCredentials creds = await UserTokenProvider.LoginSilentAsync("<client_id>", "<domain>", "<username>", "<password>");
```

**Login with a prompt**

```csharp
using Microsoft.Rest.Azure.Authentication;
...

ServiceClientCredentials creds = await UserTokenProvider.LoginWithPromptAsync("<domain>", ActiveDirectoryClientSettings.UsePromptOnly("<client_id>", new Uri("urn:ietf:wg:oauth:2.0:oob")));
```
