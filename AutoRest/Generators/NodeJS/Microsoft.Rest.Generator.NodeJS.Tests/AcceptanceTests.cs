// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

// TODO: file length is getting excessive.
using System;
using System.Globalization;
using System.IO;
using System.Collections.Generic;
using Microsoft.Rest.Generator.NodeJS;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Modeler.Swagger.Tests;
using System.Linq;
using Xunit;
using Xunit.Abstractions;

namespace Microsoft.Rest.Generator.NodeJS.Tests
{
    [Collection("AutoRest NodeJS Tests")]
    public static class AcceptanceTests
    {
        private static string ExpectedPath(string file)
        {
            return Path.Combine("Expected", "AcceptanceTests", file);
        }

        private static string SwaggerPath(string file)
        {
            return Path.Combine("Swagger", file);
        }

        [Fact]
        public static void SampleTestForGeneratingNodeJS()
        {
            SwaggerSpecHelper.RunTests<NodeJSCodeGenerator>(
                new Settings
                {
                    Input = SwaggerPath("body-complex.json"),
                    OutputDirectory = "X:\\Output",
                    Header = "MICROSOFT_MIT_NO_VERSION",
                    Modeler = "Swagger",
                    CodeGenerator = "NodeJS",
                    PayloadFlatteningThreshold = 1
                }, ExpectedPath("BodyComplex"));
        }

        [Fact]
        public static void GeneratingComplexModelDefinitionsInNodeJS()
        {
            SwaggerSpecHelper.RunTests<NodeJSCodeGenerator>(
                new Settings
                {
                    Input = SwaggerPath("complex-model.json"),
                    OutputDirectory = "X:\\Output",
                    Header = "MICROSOFT_MIT_NO_VERSION",
                    Modeler = "Swagger",
                    CodeGenerator = "NodeJS",
                    PayloadFlatteningThreshold = 1
                }, ExpectedPath("ComplexModelClient"));
        }
    }
}
