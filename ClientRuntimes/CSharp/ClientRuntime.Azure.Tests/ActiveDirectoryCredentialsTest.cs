// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Net;
using System.Net.Http;
using System.Reflection;
using System.Threading;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Microsoft.Rest.ClientRuntime.Azure.Test.Fakes;
using Xunit;
using Microsoft.Azure;

namespace Microsoft.Rest.ClientRuntime.Azure.Test
{
    public class ActiveDirectoryCredentialsTest
    {
        public ActiveDirectoryCredentialsTest()
        {
            IDictionary<string, string> connectionProperties =
                ParseConnectionString(Environment.GetEnvironmentVariable("ARM_Connection_String"));
            if (!connectionProperties.ContainsKey("username") || !connectionProperties.ContainsKey("password"))
            {
                throw new InvalidOperationException("An environment variable ARM_Connection_String=username=<username>;password=<password> is required to run this test");
            }

            this.Username = connectionProperties["username"];
            this.Password = connectionProperties["password"];
        }

        private static IDictionary<string, string> ParseConnectionString(string connectionString)
        {
            Dictionary<string, string> result = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            foreach (var pairString in connectionString.Split(new[] {';'}, StringSplitOptions.RemoveEmptyEntries))
            {
                var pair = pairString.Split(new[] {'='}, 2, StringSplitOptions.RemoveEmptyEntries);
                result[pair[0]] = pair[1];
            }

            return result;
        }

        public string Username {get; private set; }
        public string Password { get; private set; }
        [Fact]
        public void UserCredentialsPopsDialog()
        {
            var credentials = new UserAccessTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                "rbactest.onmicrosoft.com");
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
            var credentials = new UserAccessTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                "rbactest.onmicrosoft.com", this.Username, this.Password);
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
            var exception = Assert.Throws<AggregateException>(() =>new UserAccessTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                "rbactest.onmicrosoft.com", this.Username, "This is not a valid password")); 
            Assert.NotNull(exception.InnerException);
            Assert.Equal(typeof(AdalServiceException), exception.InnerException.GetType());
            exception = Assert.Throws<AggregateException>(() =>new UserAccessTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                "rbactest.onmicrosoft.com", "bad_user@bad_domain.com", this.Password));    
            Assert.NotNull(exception.InnerException);
            Assert.Equal(typeof(AdalException), exception.InnerException.GetType());
            exception = Assert.Throws<AggregateException>(() =>new UserAccessTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                "not-a-valid-domain", this.Username, this.Password));    
            Assert.NotNull(exception.InnerException);
            Assert.Equal(typeof(AdalServiceException), exception.InnerException.GetType());
            exception = Assert.Throws<AggregateException>(() =>new UserAccessTokenCredentials("not-a-valid-client-id",
                "rbactest.onmicrosoft.com", this.Username, this.Password));    
            Assert.NotNull(exception.InnerException);
            Assert.Equal(typeof(AdalServiceException), exception.InnerException.GetType());
       }

        [Fact]
        public void CredentialsConstructorThrowsForInvalidValues()
        {
            Assert.Throws<ArgumentOutOfRangeException>(() =>new UserAccessTokenCredentials(null,
                "microsoft.onmicrosoft.com"));
           Assert.Throws<ArgumentOutOfRangeException>(() =>new UserAccessTokenCredentials(string.Empty,
                "microsoft.onmicrosoft.com"));
           Assert.Throws<ArgumentOutOfRangeException>(() =>new UserAccessTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                null));
            Assert.Throws<ArgumentOutOfRangeException>(() =>new UserAccessTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                string.Empty));
             Assert.Throws<ArgumentOutOfRangeException>(() =>new UserAccessTokenCredentials(null,
                "rbactest.onmicrosoft.com", this.Username, this.Password));
             Assert.Throws<ArgumentOutOfRangeException>(() =>new UserAccessTokenCredentials(string.Empty,
                "rbactest.onmicrosoft.com", this.Username, this.Password));
             Assert.Throws<ArgumentOutOfRangeException>(() =>new UserAccessTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                null, this.Username, this.Password));
             Assert.Throws<ArgumentOutOfRangeException>(() =>new UserAccessTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                string.Empty, this.Username, this.Password));
             Assert.Throws<ArgumentOutOfRangeException>(() =>new UserAccessTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                "rbactest.onmicrosoft.com", null, this.Password));
             Assert.Throws<ArgumentOutOfRangeException>(() =>new UserAccessTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                "rbactest.onmicrosoft.com", string.Empty, this.Password));
             Assert.Throws<ArgumentOutOfRangeException>(() =>new UserAccessTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                "rbactest.onmicrosoft.com", this.Username, null));
             Assert.Throws<ArgumentOutOfRangeException>(() =>new UserAccessTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                "rbactest.onmicrosoft.com", this.Username, string.Empty));
        }
        [Fact]
        public void TokenProviderRefreshWorks()
        {
            var cache = new TestTokenCache();
            var provider = new ActiveDirectoryTokenProvider("1950a258-227b-4e31-a9cf-717495945fc2",
                "rbactest.onmicrosoft.com", this.Username, this.Password, AzureEnvironment.Azure, cache);
            cache.ForceTokenExpiry();
            Assert.NotNull(provider.GetAccessTokenAsync(CancellationToken.None).Result);
            var credentials = new AccessTokenCredentials(provider);
            var client = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Get, 
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            var response = client.SendAsync(request).Result;
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
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
                var expiresOnProperty = typeof (AuthenticationResult).GetProperty("ExpiresOn");
                var expiresOnSet = expiresOnProperty.GetSetMethod(true);
                expiresOnSet.Invoke(item, new object[] {newDate});
            }
        }
    }
}
