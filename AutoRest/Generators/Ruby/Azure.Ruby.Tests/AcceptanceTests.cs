// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.CSharp.Tests;
using Microsoft.Rest.Generator.Ruby.Tests;
using Xunit;
using Xunit.Abstractions;

namespace Microsoft.Rest.Generator.Azure.Ruby.Tests
{
    public class AcceptanceTests : AcceptanceTestsBase, IClassFixture<ServiceController>
    {
        public AcceptanceTests(ServiceController data, ITestOutputHelper output) : base(data, output, "Azure.Ruby") { }

        [Fact(Skip = "not implemented")]
        public void HeadTests()
        {
            Test("head_spec.rb", "head.json", "Head");
        }

        [Fact(Skip = "not implemented")]
        public void PagingTests()
        {
            Test("paging_spec.rb", "paging.json", "Paging");
        }

        [Fact(Skip = "not implemented")]
        public void ResourceFlatteningTests()
        {
            Test("resource_flattening_spec.rb", "resource-flattening.json", "ResourceFlattening");
        }

        [Fact(Skip = "not implemented")]
        public void LroTests()
        {
            Test("lro_spec.rb", "lro.json", "Lro");
        }

        [Fact(Skip = "not implemented")]
        public void AzureURLTests()
        {
            Test("azure_url_spec.rb", "subscriptionId-apiVersion.json", "AzureURL");
        }

        [Fact(Skip = "not implemented")]
        public void AzureSpecialPropertiesTests()
        {
            Test("azure_special_properties_spec.rb", "azure-special-properties.json", "AzureSpecialProperties");
        }

        [Trait("Report", "true")]
        [Fact(Skip = "not all tests are ready so test coverage is too low")]
        public void EnsureTestCoverage()
        {
            Test("azure_report_spec.rb", "azure-report.json", "AzureReport");
        }
    }
}
