#Automatic Retries
AutoRest generated clients support a number of retry policies based on [The Transient Fault Handling Application Block](https://msdn.microsoft.com/en-us/library/hh680934%28v=pandp.50%29.aspx). Retry policies allow generated clients to automatically recover from transient server errors (e.g. error code 5XX).

There are two ways to customize the retry behavior:

- Change the detection strategy - define which server error responses need to be retried and which ones should to be re-thrown
- Change the retry strategy - specify how long and how many times to continue retrying

By default, the detection strategy is configured to retry on HttpStatusCode 408 (RequestTimeout) as well as all 5XX codes. The only exceptions are 501 (NotImplemented) and 505 (HttpVersionNotSupported) status codes which are re-thrown to the user.

The default retry strategy is based on exponential back-off with maximum of three attempts, back-off delta of 10 seconds, minimum back-off of 1 second, and maximum back-off of 10 seconds.

## Changing the Detection Strategy
Detection strategy can be customized by implementing interface [ITransientErrorDetectionStrategy](../Microsoft.Rest/ClientRuntime/TransientFaultHandling/ITransientErrorDetectionStrategy.cs):
```csharp
public class ServerErrorDetectionStrategy : ITransientErrorDetectionStrategy
{
    public bool IsTransient(Exception ex)
    {
        if (ex != null)
        {
            // AutoRest will use this error type for all server errors.
            HttpRequestWithStatusException httpException;
            if ((httpException = ex as HttpRequestWithStatusException) != null)
            {
                // Condition to retry
                if (httpException.StatusCode == HttpStatusCode.InternalServerError)
                {
                    return true;
                }
            }
        }
        return false;
    }
}
```
Finally, set the client retry policy using preferred retry strategy:
```csharp
var retryPolicy = new RetryPolicy<ServerErrorDetectionStrategy>(new FixedIntervalRetryStrategy());
client.SetRetryPolicy(retryPolicy);
```

## Changing the Retry Strategy
Microsoft.Rest.ClientRuntime comes with three built-in retry strategies:

- [ExponentialBackoffRetryStrategy](../Microsoft.Rest/ClientRuntime/TransientFaultHandling/ExponentialBackoffRetryStrategy.cs) - a retry strategy with backoff parameters for calculating the exponential delay between retries
- [FixedIntervalRetryStrategy](../Microsoft.Rest/ClientRuntime/TransientFaultHandling/FixedIntervalRetryStrategy.cs) - a retry strategy with a specified number of retry attempts and a default, fixed time interval between retries
- [IncrementalRetryStrategy](../Microsoft.Rest/ClientRuntime/TransientFaultHandling/IncrementalRetryStrategy.cs) - a retry strategy with a specified number of retry attempts and an incremental time interval between retries

In order to set the retry strategy in the client, follow these steps:
```csharp
var retryPolicy = new RetryPolicy<HttpStatusCodeErrorDetectionStrategy>(new FixedIntervalRetryStrategy(10));
client.SetRetryPolicy(retryPolicy);
```

In order to implement a custom retry strategy extend [RetryStrategy](../Microsoft.Rest/ClientRuntime/TransientFaultHandling/RetryPolicy.cs) abstract class.
