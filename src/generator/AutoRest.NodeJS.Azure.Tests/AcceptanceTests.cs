// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

// TODO: file length is getting excessive.

using System.IO;
using AutoRest.Swagger.Tests;
using Xunit;

namespace AutoRest.NodeJS.Azure.Tests
{
    [Collection("AutoRest Azure NodeJS Tests")]
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
        public static void SampleTestForGeneratingAzureNodeJS()
        {
            SwaggerSpecHelper.RunTests<AzureNodeJSCodeGenerator>(
                SwaggerPath("storage.json"), ExpectedPath("StorageManagementClient"));
        }
    }
}
