// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

// TODO: file length is getting excessive.
using System;
using System.Globalization;
using System.IO;
using System.Collections.Generic;
using Microsoft.Rest.Generator.NodeJS;
using Microsoft.Rest.Generator.Azure.NodeJS;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Modeler.Swagger.Tests;
using System.Linq;
using Xunit;
using Xunit.Abstractions;

namespace Microsoft.Rest.Generator.CSharp.Azure.Tests
{
    [Collection("AutoRest Tests")]
    [TestCaseOrderer("Microsoft.Rest.Generator.CSharp.Tests.AcceptanceTestOrderer",
        "AutoRest.Generator.NodeJS.Tests")]
    public class AcceptanceTests
    {
        private readonly ITestOutputHelper _output;
        
        public AcceptanceTests(ITestOutputHelper output)
        {
            _output = output;
        }

        private static string ExpectedPath(string file)
        {
            return Path.Combine("Expected", "AcceptanceTests", file);
        }

        private static string SwaggerPath(string file)
        {
            return Path.Combine("Swagger", file);
        }

        [Fact]
        public void SampleTestForGeneratingAzureNodeJS()
        {
            SwaggerSpecHelper.RunTests<AzureNodeJSCodeGenerator>(
                SwaggerPath("storage.json"), ExpectedPath("StorageManagementClient"));
        }
    }
}
