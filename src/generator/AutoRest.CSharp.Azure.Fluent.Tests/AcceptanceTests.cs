// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

// TODO: file length is getting excessive.

//using System.ComponentModel.DataAnnotations;
using System.IO;
using Xunit;
using AutoRest.CSharp.Tests.Utilities;
using Microsoft.Rest;

namespace AutoRest.CSharp.Azure.Fluent.Tests
{
    [Collection("AutoRest Tests")]
    public class AcceptanceTests : IClassFixture<ServiceController>
    {
        private static readonly TestTracingInterceptor _interceptor;

        static AcceptanceTests()
        {
            _interceptor = new TestTracingInterceptor();
            ServiceClientTracing.AddTracingInterceptor(_interceptor);
        }

        public AcceptanceTests(ServiceController data)
        {
            this.Fixture = data;
            ServiceClientTracing.IsEnabled = false;
        }

        public ServiceController Fixture { get; set; }

        private static string ExpectedPath(string file)
        {
            return Path.Combine("Expected", "AcceptanceTests", file);
        }

        private static string SwaggerPath(string file)
        {
            return Path.Combine("Swagger", file);
        }
    }
}
