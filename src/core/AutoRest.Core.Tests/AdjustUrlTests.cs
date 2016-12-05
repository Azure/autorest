// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Utilities;
using Xunit;
namespace AutoRest.Core.Tests
{
    [Collection("AutoRest Tests")]
    public class AdjustUrlTests
    {
        [Fact]
        public void AdjustGithubUrls()
        {
            Assert.Equal(
                "https://raw.githubusercontent.com/Microsoft/vscode/master/.gitignore",
                "https://github.com/Microsoft/vscode/blob/master/.gitignore"
                .AdjustGithubUrl());
            Assert.Equal(
                "https://raw.githubusercontent.com/Microsoft/TypeScript/master/README.md",
                "https://github.com/Microsoft/TypeScript/blob/master/README.md"
                .AdjustGithubUrl());
            Assert.Equal(
                "https://raw.githubusercontent.com/Microsoft/TypeScript/master/tests/cases/compiler/APISample_watcher.ts",
                "https://github.com/Microsoft/TypeScript/blob/master/tests/cases/compiler/APISample_watcher.ts"
                .AdjustGithubUrl());
            Assert.Equal(
                "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-web/2015-08-01/AppServiceCertificateOrders.json",
                "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-web/2015-08-01/AppServiceCertificateOrders.json"
                .AdjustGithubUrl());
        }

        [Fact]
        public void AdjustGithubUrlsNot()
        {
            Assert.Equal(
                "https://raw.githubusercontent.com/Microsoft/TypeScript/master/tests/cases/compiler/APISample_watcher.ts",
                "https://raw.githubusercontent.com/Microsoft/TypeScript/master/tests/cases/compiler/APISample_watcher.ts"
                .AdjustGithubUrl());
            Assert.Equal(
                "https://assets.onestore.ms/cdnfiles/external/uhf/long/9a49a7e9d8e881327e81b9eb43dabc01de70a9bb/images/microsoft-gray.png",
                "https://assets.onestore.ms/cdnfiles/external/uhf/long/9a49a7e9d8e881327e81b9eb43dabc01de70a9bb/images/microsoft-gray.png"
                .AdjustGithubUrl());
            Assert.Equal(
                "README.md",
                "README.md"
                .AdjustGithubUrl());
            Assert.Equal(
                "compiler/APISample_watcher.ts",
                "compiler/APISample_watcher.ts"
                .AdjustGithubUrl());
            Assert.Equal(
                @"compiler\APISample_watcher.ts",
                @"compiler\APISample_watcher.ts"
                .AdjustGithubUrl());
            Assert.Equal(
                @"C:\arm-web\2015-08-01\AppServiceCertificateOrders.json",
                @"C:\arm-web\2015-08-01\AppServiceCertificateOrders.json"
                .AdjustGithubUrl());
        }
    }
}
