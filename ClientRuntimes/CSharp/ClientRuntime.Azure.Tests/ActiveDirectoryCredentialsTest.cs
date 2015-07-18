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
using Microsoft.Azure.Authentication;

namespace Microsoft.Rest.ClientRuntime.Azure.Test
{
    public class ActiveDirectoryCredentialsTest
    {
        public ActiveDirectoryCredentialsTest()
        {
            IDictionary<string, string> connectionProperties =
                ParseConnectionString(Environment.GetEnvironmentVariable("ARM_Connection_String"));
            if (!(connectionProperties.ContainsKey("username") && connectionProperties.ContainsKey("password") &&
                connectionProperties.ContainsKey("applicationid") && connectionProperties.ContainsKey("secret")
                && connectionProperties.ContainsKey("domain")))
            {
                throw new InvalidOperationException("An environment variable: ARM_Connection_String=username=<username>;password=<password>;applicationid=<applicationId>;secret=<secret>;domain=<domain> is required to run this test");
            }

            this.Username = connectionProperties["username"];
            this.Password = connectionProperties["password"];
            this.ApplicationId = connectionProperties["applicationid"];
            this.Secret = connectionProperties["secret"];
            this.Domain = connectionProperties["domain"];
        }

        public string Username { get; private set; }
        public string Password { get; private set; }
        public string ApplicationId { get; private set; }
        public string Secret { get; private set; }
        public string Domain { get; private set; }

        [Fact(Skip="Test should only run with user interaction")]
        public void UserCredentialsPopsDialog()
        {
            var credentials = new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                this.Domain);
            var client = new HttpClient();

            var request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            var response = client.SendAsync(request).Result;
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        }

        [Fact]
        public void OrgIdCredentialWorksWithoutDialog()
        {
            var credentials = new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                this.Domain, this.Username, this.Password);
            var client = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            var response = client.SendAsync(request).Result;
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        }

        [Fact]
        public void OrgIdCredentialsThrowsForInvalidCredentials()
        {
            var exception = Assert.Throws<AggregateException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                this.Domain, "unuseduser@thisdomain.com", "This is not a valid password"));
            Assert.NotNull(exception.InnerException);
            Assert.Equal(typeof(AdalException), exception.InnerException.GetType());
            exception = Assert.Throws<AggregateException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                this.Domain, "bad_user@bad_domain.com", this.Password));
            Assert.NotNull(exception.InnerException);
            Assert.Equal(typeof(AdalException), exception.InnerException.GetType());
            exception = Assert.Throws<AggregateException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                "not-a-valid-domain", this.Username, this.Password));
            Assert.NotNull(exception.InnerException);
            Assert.Equal(typeof(AdalServiceException), exception.InnerException.GetType());
            exception = Assert.Throws<AggregateException>(() => new UserTokenCredentials("not-a-valid-client-id",
                this.Domain, this.Username, this.Password));
            Assert.NotNull(exception.InnerException);
            Assert.Equal(typeof(AdalServiceException), exception.InnerException.GetType());
        }

        [Fact]
        public void CredentialsConstructorThrowsForInvalidValues()
        {
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials(null,
                "microsoft.onmicrosoft.com"));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials(string.Empty,
                 "microsoft.onmicrosoft.com"));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                 null));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                string.Empty));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials(null,
               "rbactest.onmicrosoft.com", this.Username, this.Password));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials(string.Empty,
               "rbactest.onmicrosoft.com", this.Username, this.Password));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
               null, this.Username, this.Password));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
               string.Empty, this.Username, this.Password));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
               "rbactest.onmicrosoft.com", null, this.Password));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
               "rbactest.onmicrosoft.com", string.Empty, this.Password));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
               "rbactest.onmicrosoft.com", this.Username, null));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
               "rbactest.onmicrosoft.com", this.Username, string.Empty));
        }
        [Fact]
        public void UserTokenProviderRefreshWorks()
        {
            var cache = new TestTokenCache();
            var provider = new ActiveDirectoryUserTokenProvider("1950a258-227b-4e31-a9cf-717495945fc2",
                this.Domain, this.Username, this.Password, AzureEnvironment.Azure, cache);
            cache.ForceTokenExpiry();
            Assert.NotNull(provider.GetAccessTokenAsync(CancellationToken.None).Result);
            var credentials = new TokenCredentials(provider);
            var client = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            var response = client.SendAsync(request).Result;
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        }

        [Fact]
        public void ValidApplicationCredentialsAuthenticateCorrectly()
        {
            var credentials = new ApplicationTokenCredentials(
                this.Domain, this.ApplicationId, this.Secret);
            var client = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            var response = client.SendAsync(request).Result;
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        }

        [Fact]
        public void ApplicationCredentialsCanBeRenewed()
        {
            var cache = new TestTokenCache();
            var provider = new ActiveDirectoryApplicationTokenProvider(this.Domain,
                 this.ApplicationId, this.Secret, AzureEnvironment.Azure, cache);
            cache.ForceTokenExpiry();
            var credentials = new TokenCredentials(provider);
            Assert.NotNull(provider.GetAccessTokenAsync(CancellationToken.None).Result);
            var client = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            var response = client.SendAsync(request).Result;
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        }

        [Fact]
        public void CanAuthenticateApplicationWithTokenStore()
        {
            var store = new InMemoryTokenStore();
            var provider = new ActiveDirectoryApplicationTokenProvider(this.Domain, this.ApplicationId, this.Secret,
                AzureEnvironment.Azure, store);
            var credentials = new TokenCredentials(provider);
            var client = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            var response = client.SendAsync(request).Result;
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
            Assert.Equal(2, store.BeginAccessNotifications.Count);
            Assert.Equal(2, store.EndAccessNotifications.Count);
            Assert.Equal(1, store.BeginWriteNotifications.Count);
        }

        [Fact]
        public void CanAuthenticateUserWithTokenStore()
        {
            var store = new InMemoryTokenStore();
            var provider = new ActiveDirectoryUserTokenProvider("1950a258-227b-4e31-a9cf-717495945fc2",
                this.Domain, this.Username, this.Password, AzureEnvironment.Azure, store);
            var credentials = new TokenCredentials(provider);
            var client = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            var response = client.SendAsync(request).Result;
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
            Assert.Equal(2, store.BeginAccessNotifications.Count);
            Assert.Equal(2, store.EndAccessNotifications.Count);
            Assert.Equal(1, store.BeginWriteNotifications.Count);
       }

        
        private static IDictionary<string, string> ParseConnectionString(string connectionString)
        {
            if (string.IsNullOrWhiteSpace(connectionString))
            {
                throw new InvalidOperationException("An environment variable: ARM_Connection_String=username=<username>;password=<password>;applicationid=<applicationId>;secret=<secret>;domain=<domain> is required to run this test");
            }
            Dictionary<string, string> result = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            foreach (var pairString in connectionString.Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries))
            {
                var pair = pairString.Split(new[] { '=' }, 2, StringSplitOptions.RemoveEmptyEntries);
                result[pair[0]] = pair[1];
            }

            return result;
        }

        class InMemoryTokenStore : ActiveDirectoryTokenStore
        {
            private List<Tuple<string, string, string, string>> _beginAccess =
                new List<Tuple<string, string, string, string>>();
            private List<Tuple<string, string, string, string>> _endAccess =
                new List<Tuple<string, string, string, string>>();
            private List<Tuple<string, string, string, string>> _beginWrite =
                new List<Tuple<string, string, string, string>>();
            public List<Tuple<string, string, string, string>> BeginAccessNotifications { get { return _beginAccess; } }
            public List<Tuple<string, string, string, string>> EndAccessNotifications { get { return _endAccess; } }
            public List<Tuple<string, string, string, string>> BeginWriteNotifications { get { return _beginWrite; } }
            protected override void BeginAccessToken(string clientId, string audience, string uniqueId, string userId)
            {
                BeginAccessNotifications.Add(
                    new Tuple<string,string,string,string>(clientId, audience, uniqueId, userId)
                );
            }

            protected override void EndAccessToken(string clientId, string audience, string uniqueId, string userId)
            {
                EndAccessNotifications.Add(
                    new Tuple<string,string,string,string>(clientId, audience, uniqueId, userId)
                );
            }

            protected override void BeginWriteToken(string clientId, string audience, string uniqueId, string userId)
            {
                BeginWriteNotifications.Add(
                    new Tuple<string,string,string,string>(clientId, audience, uniqueId, userId)
                );
            }
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
}
