# Writing Tests

## Build Prerequisites
To test AutoRest in each language, you must set up your machine according to the requirements on the [Building Code](building-code.md) page.

## Architecture
Tests are split into unit and acceptance tests. Unit tests validate the AutoRest application itself and how it interprets Swagger documents. Acceptance tests validate the generated code in each language and are written in those languages.

### Unit tests
Unit tests need to be updated when core parts of AutoRest change, not when the language-specific generator code changes. Unit tests are located in:
<dl>
  <dt><a href="../AutoRest/AutoRest.Core.Tests/">\AutoRest\AutoRest.Core.Tests</a></dt>
  <dd>These need to be updated when the command-line AutoRest application itself changes</dd>
  <dt><a href="../AutoRest/Modelers/Swagger.Tests">\AutoRest\Modelers\Swagger.Tests</a><br>
      <a href="../AutoRest/Modelers/CompositeSwagger.Tests">\AutoRest\Modelers\Swagger.Composite.Tests</a></dt>
  <dd>These need to be updated when there are changes to how AutoRest processes Swagger files</dd>
</dl>

### Acceptance tests (and test server)
Acceptance tests are run against a Node.js test server (which uses [Express framework](http://expressjs.com/)). The code for the test server is checked in to the [\\AutoRest\\TestServer](../AutoRest/TestServer/) folder in the repository.

There are two main components to the test server: the Swagger definitions that describe the server and the code that handles requests to the server and responds with the appropriate status code, payload, etc. if the request is constructed correctly.

## How to add acceptance tests for scenarios
1. Add your scenarios to the Swagger files that describe the test server (located in the [\\AutoRest\\TestServer\\swagger](../AutoRest/TestServer/swagger/) folder).
2. Update the test server
   - Update the routes to generate appropriate responses for your scenarios at paths specified in the Swagger files in step 1. This code is located in the [\\AutoRest\\TestServer\\server\\routes\\*.js](../AutoRest/TestServer/server/routes) files.
   - For each scenario, the `coverage` dictionary needs to be incremented for the name of your scenario. This name will be used in the test report coverage. 
   - Update the `coverage` dictionary in [\\AutoRest\\TestServer\\server\\app.js](../AutoRest/TestServer/server/app.js) to include the names of your new scenarios. This lets the final test report include your scenarios when reporting on the coverage for each language.
3. Regenerate the expected code using `gulp regenerate` (this will use the Swagger files to generate client libraries for the test server).
4. In each language, write tests that cover your scenarios (for example, in C#, you must update [\\AutoRest\\Generators\\CSharp\CSharp.Tests\\AcceptanceTests.cs](../AutoRest/Generators/CSharp/CSharp.Tests/AcceptanceTests.cs) or [\\AutoRest\\Generators\\CSharp\\Azure.CSharp.Tests\\AcceptanceTests.cs](../AutoRest/Generators/CSharp/Azure.CSharp.Tests/AcceptanceTests.cs)). You will make calls to the test server using the generated code from step 3.
5. [Run the tests](#running-tests)

## Running Tests
When you run tests, the test server is automatically started and the code that is generated for the test server Swagger files will correctly target this new instance.

### Command Line
Tests can be run with `gulp test`. You can run tests for each language individually with `gulp:test:[language name]`. Use `gulp -T` to find the correct names.

### Visual Studio
In Visual Studio, you can run tests for all languages using Task Runner Explorer. C# tests can also be run and debugged in Test Explorer.

## Debugging the test server
When updating the test server code to return the appropriate responses for your scenarios, it can be useful to debug the code to make sure the test code calls the paths that you are expecting.

### Visual Studio
1. Install [Node.js Tools for Visual Studio](https://www.visualstudio.com/en-us/features/node-js-vs.aspx) solution.
2. Open the [\\AutoRest\\TestServer\\server\\SwaggerBATServer.sln](../AutoRest/TestServer/server/SwaggerBATServer.sln).
3. Run the [SwaggerBATServer project](../AutoRest/TestServer/server/SwaggerBATServer.njsproj).
4. Make sure that the port that the test server is using matches the port that is used by the tests when you run them.
  - For Node.js, this is straightforward because the server and tests both use port 3000 by default.
  - For C#, the infrastructure is set up to use a random port to avoid conflicts. You must change the logic in [\\AutoRest\\Generators\\CSharp\\CSharp.Tests\\Utilities\\ServiceController.cs](../AutoRest/Generators/CSharp/CSharp.Tests/Utilities/ServiceController.cs).`GetRandomPort()` to use the same port as the test server.