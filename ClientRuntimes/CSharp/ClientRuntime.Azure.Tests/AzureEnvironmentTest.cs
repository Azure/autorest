// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using Xunit;
using Microsoft.Azure.Authentication;

namespace Microsoft.Rest.ClientRuntime.Azure.Test
{
    public class AzureEnvironmentTest
    {

        [Theory]
        [InlineData("https://www.contoso.com")]
        [InlineData("https://www.contoso.com/widgets")]
        [InlineData("http://www.contoso.com/wdgets/moreWidgets")]
        [InlineData("https://www.contoso.com:8080")]
        [InlineData("https://www.contoso.com:8080/widgets")]
       public void AzureEnvironmentAddsSlashToEndpoints(string inputUri)
        {
            var testEnvironment = new AzureEnvironment
            {
                ValidateAuthority = true,
                TokenAudience = new Uri("https://contoso.com/widgets/"),
                AuthenticationEndpoint = new Uri(inputUri)
            };
            Assert.Equal(inputUri + "/", testEnvironment.AuthenticationEndpoint.ToString());
        }

        [Theory]
        [InlineData("https://www.contoso.com/")]
        [InlineData("https://www.contoso.com/widgets/")]
        [InlineData("http://www.contoso.com/wdgets/moreWidgets/")]
        [InlineData("https://www.contoso.com:8080/")]
        [InlineData("https://www.contoso.com:8080/widgets/")]
       public void AzureEnvironmentDoesNotDuplicateSlash(string inputUri)
        {
            var testEnvironment = new AzureEnvironment
            {
                ValidateAuthority = true,
                TokenAudience = new Uri("https://contoso.com/widgets/"),
                AuthenticationEndpoint = new Uri(inputUri)
            };
            Assert.Equal(inputUri, testEnvironment.AuthenticationEndpoint.ToString());
        }

        [Theory]
        [InlineData("https://www.contoso.com?widget=blue")]
        [InlineData("https://www.contoso.com/widgets/?widget=blue&color=yellow")]
        public void AzureEnvironmentRejectsInvalidUris(string inputUri)
        {
            Assert.Throws<ArgumentOutOfRangeException>(() => new AzureEnvironment
            {
                ValidateAuthority = true,
                TokenAudience = new Uri("https://contoso.com/widgets/"),
                AuthenticationEndpoint = new Uri(inputUri)
            });
        }

        [Fact]
        public void AzureEnvironmenThrowsOnNullUri()
        {
            Assert.Throws<ArgumentNullException>(() => new AzureEnvironment
            {
                ValidateAuthority = true,
                TokenAudience = new Uri("https://contoso.com/widgets/"),
                AuthenticationEndpoint = null
            });
        }

    }
}
