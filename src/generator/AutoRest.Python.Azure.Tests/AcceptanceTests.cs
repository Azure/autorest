// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using AutoRest.Swagger.Tests;
using Xunit;

namespace AutoRest.Python.Azure.Tests
{
    [Collection("AutoRest Azure Python Tests")]
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
            SwaggerSpecHelper.RunTests(
                SwaggerPath("storage.json"),
                ExpectedPath("StorageManagementClient"),
                plugin:"Azure.Python",
                nameSpace: "fixtures.acceptancetestsstoragemanagementclient");
        }
    }
}
