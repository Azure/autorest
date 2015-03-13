#Error Handling

##Tracing

Clients generated with AutoRest come with an extensible tracing infrastructure. The following events are traced when the client is executed:

* EnterMethod - operation method is entered
* SendRequest - Http request is sent
* ReceiveResponse - Http response is received
* TraceError - error is raised
* ExitMethod - method is exited
