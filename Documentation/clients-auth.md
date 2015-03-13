#Authentication
In order to support server side authentication (certificate, basic, OAuth, or custom), the client needs to be generated using [-AddCredentials](cli.md) flag. When this flag is used the the client will have a Credentials property of type [`ServiceClientCredentials`](../Microsoft.Rest/ClientRuntime/ServiceClientCredentials.cs). Microsoft.Rest.ClientRuntime package comes with two out-of-the-box Credentials: 

 * [`TokenCredentials`](../Microsoft.Rest/ClientRuntime/TokenCredentials.cs) - used for OAuth authentication
 * [`BasicAuthenticationCredentials`](../Microsoft.Rest/ClientRuntime/BasicAuthenticationCredentials.cs) - used for basic username/password authentication

In order to implement a custom Credentials type, create a class that inherits from [`ServiceClientCredentials`](../Microsoft.Rest/ClientRuntime/ServiceClientCredentials.cs) and implement a ProcessHttpRequestAsync() method.
