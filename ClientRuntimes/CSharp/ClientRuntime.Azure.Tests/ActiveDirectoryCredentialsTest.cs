// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Reflection;
using System.Threading;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Xunit;
using Microsoft.Rest.Azure.Authentication;
using Microsoft.Rest.ClientRuntime.Azure.Test.Fakes;

namespace Microsoft.Rest.ClientRuntime.Azure.Test
{
    public class ActiveDirectoryCredentialsTest
    {
        private string _username;
        private string _password;
        private string _applicationId;
        private string _secret;
        private string _domain;

        public ActiveDirectoryCredentialsTest()
        {
            IDictionary<string, string> connectionProperties =
                EnvironmentDependentFactAttribute.ParseConnectionString(Environment.GetEnvironmentVariable("ARM_Connection_String"));

            if (connectionProperties != null)
            {
                connectionProperties.TryGetValue("username", out this._username);
                connectionProperties.TryGetValue("password", out this._password);
                connectionProperties.TryGetValue("applicationid", out this._applicationId);
                connectionProperties.TryGetValue("secret", out this._secret);
                connectionProperties.TryGetValue("domain", out this._domain);
            }
        }

        [EnvironmentDependentFact(Skip = "Test should only run with user interaction")]
        public void UserCredentialsPopsDialog()
        {
            var credentials = new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                this._domain, new Uri("urn:ietf:wg:oauth:2.0:oob"));
            var client = new HttpClient();

            var request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            var response = client.SendAsync(request).ConfigureAwait(false).GetAwaiter().GetResult();
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        }

        [EnvironmentDependentFact]
        public void OrgIdCredentialWorksWithoutDialog()
        {
            var credentials = new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                this._domain, this._username, this._password);
            var client = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            var response = client.SendAsync(request).ConfigureAwait(false).GetAwaiter().GetResult();
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        }

        [EnvironmentDependentFact]
        public void OrgIdCredentialsThrowsForInvalidCredentials()
        {
            var exception = Assert.Throws<AggregateException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                this._domain, "unuseduser@thisdomain.com", "This is not a valid password"));
            Assert.NotNull(exception.InnerException);
            Assert.Equal(typeof(AdalException), exception.InnerException.GetType());
            exception = Assert.Throws<AggregateException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                this._domain, "bad_user@bad_domain.com", this._password));
            Assert.NotNull(exception.InnerException);
            Assert.Equal(typeof(AdalException), exception.InnerException.GetType());
            exception = Assert.Throws<AggregateException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                "not-a-valid-domain", this._username, this._password));
            Assert.NotNull(exception.InnerException);
            Assert.Equal(typeof(AdalServiceException), exception.InnerException.GetType());
            exception = Assert.Throws<AggregateException>(() => new UserTokenCredentials("not-a-valid-client-id",
                this._domain, this._username, this._password));
            Assert.NotNull(exception.InnerException);
            Assert.Equal(typeof(AdalServiceException), exception.InnerException.GetType());
        }

        [EnvironmentDependentFact]
        public void CredentialsConstructorThrowsForInvalidValues()
        {
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials(null,
                "microsoft.onmicrosoft.com", new Uri("urn:ietf:wg:oauth:2.0:oob")));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials(string.Empty,
                 "microsoft.onmicrosoft.com", new Uri("urn:ietf:wg:oauth:2.0:oob")));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                 null, new Uri("urn:ietf:wg:oauth:2.0:oob")));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                string.Empty, new Uri("urn:ietf:wg:oauth:2.0:oob")));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials(null,
               "rbactest.onmicrosoft.com", this._username, this._password));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials(string.Empty,
               "rbactest.onmicrosoft.com", this._username, this._password));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
               null, this._username, this._password));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
               string.Empty, this._username, this._password));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
               "rbactest.onmicrosoft.com", null, this._password));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
               "rbactest.onmicrosoft.com", string.Empty, this._password));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
               "rbactest.onmicrosoft.com", this._username, null));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
               "rbactest.onmicrosoft.com", this._username, string.Empty));
        }

        [EnvironmentDependentFact]
        public void UserTokenProviderRefreshWorks()
        {
            var cache = new TestTokenCache();
            var provider = new ActiveDirectoryUserTokenProvider("1950a258-227b-4e31-a9cf-717495945fc2",
                this._domain, this._username, this._password, AzureEnvironment.Azure, cache);
            cache.ForceTokenExpiry();
            Assert.NotNull(provider.GetAuthenticationHeaderAsync(CancellationToken.None).ConfigureAwait(false).GetAwaiter().GetResult());
            var credentials = new TokenCredentials(provider);
            var client = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            var response = client.SendAsync(request).ConfigureAwait(false).GetAwaiter().GetResult();
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        }

        [EnvironmentDependentFact]
        public void ValidApplicationCredentialsAuthenticateCorrectly()
        {
            var credentials = new ApplicationTokenCredentials(
                this._applicationId, this._domain, this._secret);
            var client = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            var response = client.SendAsync(request).ConfigureAwait(false).GetAwaiter().GetResult();
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        }

        [EnvironmentDependentFact]
        public void ApplicationCredentialsCanBeRenewed()
        {
            var cache = new TestTokenCache();
            var provider = new ActiveDirectoryApplicationTokenProvider(this._applicationId, 
                 this._domain, this._secret, AzureEnvironment.Azure, cache);
            cache.ForceTokenExpiry();
            var credentials = new TokenCredentials(provider);
            Assert.NotNull(provider.GetAuthenticationHeaderAsync(CancellationToken.None).ConfigureAwait(false).GetAwaiter().GetResult());
            var client = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            var response = client.SendAsync(request).ConfigureAwait(false).GetAwaiter().GetResult();
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        }

        [EnvironmentDependentFact]
        public void CanAuthenticateUserWithTokenStore()
        {
            var cache = new TokenCache();
            var provider = new ActiveDirectoryUserTokenProvider("1950a258-227b-4e31-a9cf-717495945fc2",
                this._domain, this._username, this._password, AzureEnvironment.Azure, cache);
            var credentials = new TokenCredentials(provider);
            var client = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            var response = client.SendAsync(request).ConfigureAwait(false).GetAwaiter().GetResult();
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
            Assert.Equal(2, cache.Count);
       }

        class TestTokenCache : TokenCache
        {
            public void ForceTokenExpiry()
            {
                var internalDictionaryProperty = typeof(TokenCache).GetField("tokenCacheDictionary", BindingFlags.NonPublic | BindingFlags.Instance);
                var internalDictionary = internalDictionaryProperty.GetValue(this);
                IDictionary myDictionary = internalDictionary as IDictionary;
                object[] authResults = new object[10];
                myDictionary.Values.CopyTo(authResults, 0);
                var authResult = authResults[0];
                var resultProperty = authResult.GetType().GetProperty("Result");
                var authObj = resultProperty.GetValue(authResult, null);
                var realAuthResult = authObj as AuthenticationResult;
                UpdateTokenCacheExpiry(realAuthResult, DateTimeOffset.UtcNow);
            }
            private static void UpdateTokenCacheExpiry(AuthenticationResult item, DateTimeOffset newDate)
            {
                var expiresOnProperty = typeof(AuthenticationResult).GetProperty("ExpiresOn");
                var expiresOnSet = expiresOnProperty.GetSetMethod(true);
                expiresOnSet.Invoke(item, new object[] { newDate });
            }
        }
    }
    public class EnvironmentDependentFactAttribute : FactAttribute
    {
        public EnvironmentDependentFactAttribute(params string[] scenarios)
        {
            IDictionary<string, string> connectionProperties =
                ParseConnectionString(Environment.GetEnvironmentVariable("ARM_Connection_String"));

            if (connectionProperties == null ||
                (!(connectionProperties.ContainsKey("username") && connectionProperties.ContainsKey("password") &&
                connectionProperties.ContainsKey("applicationid") && connectionProperties.ContainsKey("secret")
                && connectionProperties.ContainsKey("domain"))))
            {
                Skip = "An environment variable: ARM_Connection_String=username=<username>;password=<password>;applicationid=<applicationId>;secret=<secret>;domain=<domain> is required to run this test";
            }

        }

        internal static IDictionary<string, string> ParseConnectionString(string connectionString)
        {
            if (string.IsNullOrWhiteSpace(connectionString))
            {
                return null;
            }
            Dictionary<string, string> result = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            foreach (var pairString in connectionString.Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries))
            {
                var pair = pairString.Split(new[] { '=' }, 2, StringSplitOptions.RemoveEmptyEntries);
                result[pair[0]] = pair[1];
            }

            return result;
        }
    }
}
