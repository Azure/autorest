// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.IO;
using System.Collections.Generic;
using Microsoft.Rest.Generator.Python;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Modeler.Swagger.Tests;
using System.Linq;
using Xunit;
using Xunit.Abstractions;

namespace Microsoft.Rest.Generator.Python.Tests
{
    [Collection("AutoRest Python Tests")]
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
        public static void SampleTestForGeneratingPython()
        {
            SwaggerSpecHelper.RunTests<PythonCodeGenerator>(
                SwaggerPath("body-complex.json"), ExpectedPath("BodyComplex"));
        }
    }
}
