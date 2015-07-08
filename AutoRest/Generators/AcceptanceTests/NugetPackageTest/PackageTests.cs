// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Fixtures.Bodynumber;
using Microsoft.Rest.Generator.CSharp.Tests;
using Newtonsoft.Json;
using System;
using Xunit;
using Xunit.Abstractions;

namespace NugetPackageTest
{
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
        public void TestClientRuntimeWorks()
        {
            var client = new AutoRestNumberTestService(Fixture.Uri);
            client.Number.PutBigFloat(3.402823e+20);
            client.Number.PutSmallFloat(3.402823e-20);
            client.Number.PutBigDouble(2.5976931e+101);
            client.Number.PutSmallDouble(2.5976931e-101);
            client.Number.PutBigDoubleNegativeDecimal(-99999999.99);
            client.Number.PutBigDoublePositiveDecimal(99999999.99);
            client.Number.GetNull();
            Assert.Equal(3.402823e+20, client.Number.GetBigFloat());
            Assert.Equal(3.402823e-20, client.Number.GetSmallFloat());
            Assert.Equal(2.5976931e+101, client.Number.GetBigDouble());
            Assert.Equal(2.5976931e-101, client.Number.GetSmallDouble());
            Assert.Equal(-99999999.99, client.Number.GetBigDoubleNegativeDecimal());
            Assert.Equal(99999999.99, client.Number.GetBigDoublePositiveDecimal());
            Assert.Throws<JsonReaderException>(() => client.Number.GetInvalidDouble());
            Assert.Throws<JsonReaderException>(() => client.Number.GetInvalidFloat());
        }
    }
}
