// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
using System.Net.Http;
using System.Reflection;
using System.Threading;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Microsoft.Rest.Azure.Authentication;
using Xunit;

namespace Microsoft.Rest.ClientRuntime.Azure.Test
{
    [Collection("ADAL Test Collection")]
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

        [EnvironmentDependentFact(Skip="Test should only be run with user interaction")]
        public void UserCredentialsPopsDialog()
        {
            var cache = new TestTokenCache();
            var settings = ActiveDirectorySettings.Azure;
            settings.PromptBehavior = PromptBehavior.Always;
            settings.UserIdentifier = new UserIdentifier(this._username, UserIdentifierType.RequiredDisplayableId);
            var credentials = new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                this._domain, new Uri("urn:ietf:wg:oauth:2.0:oob"), settings, cache);
            credentials.LogOnAsync().GetAwaiter().GetResult();
            var client = new HttpClient();

            var request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            var response = client.SendAsync(request).ConfigureAwait(false).GetAwaiter().GetResult();
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
            // Repeat with PromptBehavior.Never
            settings.PromptBehavior = PromptBehavior.Never;
             credentials = new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                this._domain, new Uri("urn:ietf:wg:oauth:2.0:oob"), settings, cache);
            credentials.LogOnAsync().GetAwaiter().GetResult();
            request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            response = client.SendAsync(request).ConfigureAwait(false).GetAwaiter().GetResult();
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
       }

        [EnvironmentDependentFact(Skip="Test should only be run with user interaction")]
        public void FactoryUserCredentialsPopsDialog()
        {
            var factory = new CredentialsFactory("1950a258-227b-4e31-a9cf-717495945fc2")
            {
                TokenCache = new TestTokenCache(),
                ClientRedirectUri = new Uri("urn:ietf:wg:oauth:2.0:oob")
            };
            factory.ActiveDirectorySettings.PromptBehavior = PromptBehavior.Always;
            factory.ActiveDirectorySettings.UserIdentifier = new UserIdentifier(this._username, UserIdentifierType.RequiredDisplayableId);
            var credentials = factory.CreateUserCredentialsWithPromptAsync(this._domain).GetAwaiter().GetResult();
            var client = new HttpClient();

            var request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            var response = client.SendAsync(request).ConfigureAwait(false).GetAwaiter().GetResult();
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
            // Repeat with PromptBehavior.Never
            
            credentials = factory.GetUserCredentialsFromTokenCache(this._domain, this._username).GetAwaiter().GetResult();
            request = new HttpRequestMessage(HttpMethod.Get,
                new Uri("https://management.azure.com/subscriptions?api-version=2014-04-01-preview"));
            credentials.ProcessHttpRequestAsync(request, CancellationToken.None).Wait();
            Assert.NotNull(request.Headers.Authorization);
            response = client.SendAsync(request).ConfigureAwait(false).GetAwaiter().GetResult();
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
       }


        [EnvironmentDependentFact]
        public void FactoryCanCreateOrgIdCredentials()
        {
            var factory = new CredentialsFactory("1950a258-227b-4e31-a9cf-717495945fc2");
            var credentials = factory.CreateUserCredentialsNoPromptAsync(this._domain, this._username, this._password).GetAwaiter().GetResult();
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
                this._domain, new Uri("urn:ietf:wg:oauth:2.0:oob"));
             credentials.LogOnSilentAsync(this._username, this._password).GetAwaiter().GetResult();
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
            var credentials = new
            UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                this._domain, null);
            var exception = Assert.Throws<AuthenticationException>(() => credentials.LogOnSilentAsync("unuseduser@thisdomain.com", "This is not a valid password").GetAwaiter().GetResult());
            Assert.NotNull(exception.InnerException);
            Assert.Equal(typeof(AdalException), exception.InnerException.GetType());
            exception = Assert.Throws<AuthenticationException>(() => credentials.LogOnSilentAsync("bad_user@bad_domain.com", this._password).ConfigureAwait(false).GetAwaiter().GetResult());
            Assert.NotNull(exception.InnerException);
            Assert.Equal(typeof(AdalException), exception.InnerException.GetType());
            var badCredential = new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2", "not-a-valid-domain", null);
            exception = Assert.Throws<AuthenticationException>(() => badCredential.LogOnSilentAsync(this._username, this._password).ConfigureAwait(false).GetAwaiter().GetResult());
            Assert.NotNull(exception.InnerException);
            Assert.Equal(typeof(AdalServiceException), exception.InnerException.GetType());
            badCredential = new UserTokenCredentials("not-a-valid-client-id", this._domain, null);
            exception = Assert.Throws<AuthenticationException>(() => badCredential.LogOnSilentAsync(this._username, this._password)
                .ConfigureAwait(false).GetAwaiter().GetResult());
            Assert.NotNull(exception.InnerException);
            Assert.Equal(typeof(AdalServiceException), exception.InnerException.GetType());
        }

        [EnvironmentDependentFact]
        public void CredentialsConstructorThrowsForInvalidValues()
        {
            TokenCache cache = new TestTokenCache();
            var settings = ActiveDirectorySettings.Azure;
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials(null,
                "microsoft.onmicrosoft.com", new Uri("urn:ietf:wg:oauth:2.0:oob"), settings, cache));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials(string.Empty,
                 "microsoft.onmicrosoft.com", new Uri("urn:ietf:wg:oauth:2.0:oob"), settings, cache));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                 null, new Uri("urn:ietf:wg:oauth:2.0:oob"), settings, cache));
            Assert.Throws<ArgumentOutOfRangeException>(() => new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                string.Empty, new Uri("urn:ietf:wg:oauth:2.0:oob"), settings, cache));
            var credential = new UserTokenCredentials("1950a258-227b-4e31-a9cf-717495945fc2",
                "rbactest.onmicrosoft.com", new Uri("urn:ietf:wg:oauth:2.0:oob"), settings, cache);
            Assert.Throws<AuthenticationException>(() => credential.LogOnSilentAsync(null, this._password).ConfigureAwait(false).GetAwaiter().GetResult());
            Assert.Throws<AuthenticationException>(() => credential.LogOnSilentAsync(string.Empty, this._password).ConfigureAwait(false).GetAwaiter().GetResult());
            Assert.Throws<AuthenticationException>(() => credential.LogOnSilentAsync(this._username, null).ConfigureAwait(false).GetAwaiter().GetResult());
            Assert.Throws<AuthenticationException>(() => credential.LogOnSilentAsync(this._username, string.Empty).ConfigureAwait(false).GetAwaiter().GetResult());
        }

        [EnvironmentDependentFact]
        public void UserTokenProviderRefreshWorks()
        {
            var cache = new TestTokenCache();
            var provider = new UserTokenProvider("1950a258-227b-4e31-a9cf-717495945fc2",
                this._domain, ActiveDirectorySettings.Azure, new Uri("urn:ietf:wg:oauth:2.0:oob"), cache);
            provider.LogOnSilentAsync(this._username, this._password).ConfigureAwait(false).GetAwaiter().GetResult();
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
            var provider = new ApplicationTokenProvider(this._applicationId, 
                 this._domain, this._secret, ActiveDirectorySettings.Azure, cache);
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

        class TestTokenCache : TokenCache
        {
            public void ForceTokenExpiry()
            {
                var expired = DateTimeOffset.UtcNow - TimeSpan.FromMinutes(5);
                var dictionaryProperty = typeof (TokenCache).GetField("tokenCacheDictionary", BindingFlags.NonPublic | BindingFlags.Instance);
                IDictionary dictionary = dictionaryProperty.GetValue(this) as IDictionary;
                foreach (var authValue in dictionary.Values)
                {
                    var authResult = authValue as AuthenticationResult;
                    var expiresOnProperty = typeof (AuthenticationResult).GetProperty("ExpiresOn");
                    expiresOnProperty.SetValue(authResult, expired);
                }
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
