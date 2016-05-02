// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.AzureResourceSchema;
using Microsoft.Rest.Modeler.Swagger.Tests;
using System.IO;
using Xunit;

namespace AutoRest.Generator.AzureResourceSchema.Tests
{
    [Collection("AutoRest Azure Resource Schema Tests")]
    public static class AcceptanceTests
    {
        private static string SwaggerFile(string fileName)
        {
            return Path.Combine("Swagger", fileName);
        }

        private static string ExpectedFolder(string folderName)
        {
            return Path.Combine("Expected", folderName);
        }

        [Fact]
        public static void Storage()
        {
            SwaggerSpecHelper.RunTests<AzureResourceSchemaCodeGenerator>(
                SwaggerFile("storage.json"), ExpectedFolder("Storage"));
        }
    }
}
