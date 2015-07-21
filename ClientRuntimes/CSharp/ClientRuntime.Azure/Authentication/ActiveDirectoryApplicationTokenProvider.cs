// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Properties;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Microsoft.Rest;

namespace Microsoft.Azure.Authentication
{
    /// <summary>
    /// Provides tokens for Azure Active Directory applications. 
    /// </summary>
    public class ActiveDirectoryApplicationTokenProvider : ITokenProvider
    {
        private AuthenticationContext _authenticationContext;
        private string _tokenAudience;
        private string _clientId;
        private ClientCredential _credential;
        private string _type;

        /// <summary>
        /// Initializes a token provider for application credentials.
        /// See <see href="https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/">Active Directory Quickstart for .Net</see> 
        /// for detailed instructions on creating an Azure Active Directory application.
        /// </summary>
        /// <param name="clientId">The client Id of the application in Active Directory.</param>
        /// <param name="domain">The domain or tenant id for the application.</param>
        /// <param name="secret">The application secret, used for authentication.</param>
        /// <param name="environment">The Azure environment to manage resources in.</param>
        public ActiveDirectoryApplicationTokenProvider(string clientId, string domain, string secret, AzureEnvironment environment)
            : this(clientId, domain, secret, environment, cache: null)
        {
        }

        /// <summary>
        /// Initializes a token provider for application credentials.
        /// See <see href="https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/">Active Directory Quickstart for .Net</see> 
        /// for detailed instructions on creating an Azure Active Directory application.
        /// </summary>
        /// <param name="clientId">The client Id of the application in Active Directory.</param>
        /// <param name="domain">The domain or tenant id for the application.</param>
        /// <param name="secret">The application secret, used for authentication.</param>
        /// <param name="environment">The Azure environment to manage resources in.</param>
        /// <param name="store">The active directory token store to use during authentication.</param>
        public ActiveDirectoryApplicationTokenProvider(string clientId, string domain, string secret, AzureEnvironment environment, ActiveDirectoryTokenStore store) 
        {
            if (store == null)
            {
                throw new ArgumentNullException("store");
            }

            Initialize(clientId, domain, secret, environment, store.TokenCache);
        }

        /// <summary>
        /// Initializes a token provider for application credentials.
        /// </summary>
        /// <param name="clientId">The client Id of the application in Active Directory.</param>
        /// <param name="domain">The domain or tenant id for the application.</param>
        /// <param name="secret">The application secret, used for authentication.</param>
        /// <param name="environment">The Azure environment to manage resources in.</param>
        /// <param name="cache">The TokenCache to use during authentication.</param>
        internal ActiveDirectoryApplicationTokenProvider(string clientId, string domain, string secret, AzureEnvironment environment, TokenCache cache)
        {
            Initialize(clientId, domain, secret, environment, cache);
        }

        /// <summary>
        /// Returns the token type of the returned token.
        /// </summary>
        public string TokenType
        {
            get { return _type; }
        }

        /// <summary>
        /// Gets an access token from the token cache or from AD authentication endpoint. 
        /// Attempts to refresh the access token if it has expired.
        /// </summary>
        public virtual async Task<string> GetAccessTokenAsync(CancellationToken cancellationToken)
        {
            var result = await this.Authenticate().ConfigureAwait(false);
            ValidateAuthenticationResult(result);
            return result.AccessToken;
        }

        /// <summary>
        /// Initialize private fields in the token provider.
        /// </summary>
        /// <param name="clientId">The client Id of the application in Active Directory.</param>
        /// <param name="domain">The domain or tenant id for the application.</param>
        /// <param name="environment">The Azure environment to manage resources in.</param>
        /// <param name="cache">The TokenCache to use while authenticating.</param>
        protected void InitializeAuthenticationContext(string clientId, string domain,
            AzureEnvironment environment, TokenCache cache)
        {
            ValidateCommonParameters(clientId, domain, environment);
            this._clientId = clientId;
            this._tokenAudience = environment.TokenAudience.ToString();
            try
            {
                this._authenticationContext = (cache == null)
                    ? new AuthenticationContext(environment.AuthenticationEndpoint + domain,
                        environment.ValidateAuthority)
                    : new AuthenticationContext(environment.AuthenticationEndpoint + domain,
                        environment.ValidateAuthority,
                        cache);
            }
            catch (AdalException authenticationException)
            {
                throw new AuthenticationException(Resources.ErrorCreatingAuthenticationContext, authenticationException);
            }
        }
        /// <summary>
        /// Validate ActiveDirectory authentication properties for this application
        /// </summary>
        /// <param name="authenticationResult">The authentication result</param>
        protected void ValidateAuthenticationResult(AuthenticationResult authenticationResult)
        {
            if (authenticationResult == null || authenticationResult.AccessToken == null )
            {
                throw new AuthenticationException(string.Format(CultureInfo.CurrentCulture,
                    Resources.AuthenticationValidationFailed,
                    this._clientId));
            }

            this._type = authenticationResult.AccessTokenType;
        }

        private async Task<AuthenticationResult> Authenticate()
        {
            try
            {
                return await this._authenticationContext.AcquireTokenAsync(this._tokenAudience, this._credential).ConfigureAwait(false);
            }
            catch (AdalException authenticationException)
            {
                throw new AuthenticationException(Resources.ErrorAcquiringToken, authenticationException);
            }
        }

        private void Initialize(string clientId, string domain, string secret, AzureEnvironment environment, 
            TokenCache cache)
        {
            if (string.IsNullOrWhiteSpace(secret))
            {
                throw new ArgumentOutOfRangeException("secret");
            }

            InitializeAuthenticationContext(clientId, domain, environment, cache);
            this._credential = new ClientCredential(clientId, secret);
            ValidateAuthenticationResult(Authenticate().Result);
        }

        /// <summary>
        /// Validate the parameters used by every constructor.
        /// </summary>
        /// <param name="clientId">The client Id of the application in Active Directory.</param>
        /// <param name="domain">The domain or tenant id for the service principal.</param>
        /// <param name="environment">The Azure environment to manage resources in.</param>
        private static void ValidateCommonParameters(string clientId, string domain, AzureEnvironment environment)
        {
            if (string.IsNullOrWhiteSpace(clientId))
            {
                throw new ArgumentOutOfRangeException("clientId");
            }
            if (string.IsNullOrWhiteSpace(domain))
            {
                throw new ArgumentOutOfRangeException("domain");
            }
            if (environment == null || environment.AuthenticationEndpoint == null || environment.TokenAudience == null)
            {
                throw new ArgumentOutOfRangeException("environment");
            }
        }
    }
}
