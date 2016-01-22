// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using Newtonsoft.Json;
using Xunit;
using Xunit.Abstractions;
using Fixtures.Bodynumber;
using Microsoft.Rest.Generator.CSharp.Tests;
using Microsoft.Rest;

namespace NugetPackageTest
{
    //we random port over a C# acceptance test so to verify in sanity
    //that the freshly built out nuget packages (runtime and generator) works.
    public class PackageTests : IClassFixture<ServiceController>
    {
        private readonly ITestOutputHelper _output;

        public PackageTests(ServiceController data, ITestOutputHelper output)
        {
            this.Fixture = data;
            _output = output;
        }

        public ServiceController Fixture { get; set; }

        [Fact]
        public void TestCSharpCodeGenWorks()
        {
            var client = new AutoRestNumberTestService(Fixture.Uri);
            Assert.Equal(3.402823e+20, client.Number.GetBigFloat());
            Assert.Throws<SerializationException>(() => client.Number.GetInvalidFloat());
        }
    }
}
