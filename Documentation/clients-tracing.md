#Tracing
Clients generated with AutoRest come with an extensible tracing infrastructure. The following events are traced when the client is executed:

- EnterMethod - operation method is entered
- SendRequest - Http request is sent
- ReceiveResponse - Http response is received
- TraceError - error is raised
- ExitMethod - method is exited

## Tracing with ETW
In order to enable ETW tracing first download _Microsoft.Rest.ClientRuntime.Etw_ package from NuGet.
Next, register `EtwTracingInterceptor` by calling:
```csharp
ServiceClientTracing.AddTracingInterceptor(new EtwTracingInterceptor());
ServiceClientTracing.IsEnabled = true;
```
Finally, use a tool such as [PerfView](http://www.microsoft.com/en-us/download/details.aspx?id=28567) to capture events under the `Microsoft.Rest` provider.

## Tracing with Log4Net
In order to enable Log4Net tracing first download _Microsoft.Rest.ClientRuntime.Log4Net_ package from NuGet. Then, configure the Log4Net in your app.config/web.config (or your preferred way). For more examples on the available configurations check [config examples](http://logging.apache.org/log4net/release/config-examples.html)

Here's an example of app.config for the logger used with ConsoleAppender:
```xml
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <configSections>
    <section name="log4net" type="log4net.Config.Log4NetConfigurationSectionHandler, log4net"/>
  </configSections>
  <log4net>
    <appender name="ConsoleAppender" type="log4net.Appender.ConsoleAppender">
      <layout type="log4net.Layout.SimpleLayout" />
    </appender>
    <root>
      <level value="ALL" />
      <appender-ref ref="ConsoleAppender" />
    </root>
    <logger name="Microsoft.Rest.Tracing.Log4Net.Log4NetTracingInterceptor">
      <level value="DEBUG" />
      <appender-ref ref="ConsoleAppender"/>
    </logger>
  </log4net>
</configuration>
```
Next, configure Log4Net in the application by adding this line to `AssemblyInfo.cs` of the application:
```csharp 
[assembly: log4net.Config.XmlConfigurator(Watch = true, ConfigFile = "FileName.ext")]
```
Finally, register `Log4NetTracingInterceptor` by calling:
```csharp
ServiceClientTracing.AddTracingInterceptor(new Log4NetTracingInterceptor());
ServiceClientTracing.IsEnabled = true;
```

## Custom Tracing
In order to trace AutoRest generated client implement a custom type that extends [IServiceClientTracingInterceptor](../Microsoft.Rest/ClientRuntime/IServiceClientTracingInterceptor.cs).
```csharp
using Microsoft.Rest;
...

public class ConsoleTracingInterceptor : IServiceClientTracingInterceptor
{
    public void Information(string message)
    {
        Console.WriteLine(message);
    }
    
    public void SendRequest(string invocationId, HttpRequestMessage request)
    {
        string requestAsString = request == null ? string.Empty : request.AsFormattedString();
        Console.WriteLine(requestAsString);
    }

    ...
}
```
Finally, register the custom tracing interceptor by calling:
```csharp
ServiceClientTracing.AddTracingInterceptor(new ConsoleTracingInterceptor());
ServiceClientTracing.IsEnabled = true;
```
