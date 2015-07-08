// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Security;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Rest;

namespace Microsoft.Azure
{
    /// <summary>
    /// Create credentials for use with Microsft Azure and Microsoft Azure Stack services
    /// </summary>
    public static class CredentialsFactory
    {
        public static readonly string DefaultClientId = "";

        /// <summary>
        /// Create credentials in the given domain or tenant. This will pop up a dialog requesting username and password
        /// </summary>
        /// <param name="domain">The name of the domain or tenant id that contains the subscriptions or resources you 
        /// would like to manage</param>
        /// <returns>The credentials object to use with the service client.</returns>
        public static ServiceClientCredentials CreateUserCredentials(string domain)
        {
            return CreateUserCredentials(domain, null, null, null, null);
        }

        public static ServiceClientCredentials CreateUserCredentials(string domain, AzureEnvironment environment)
        {
            return CreateUserCredentials(domain, null, null, environment, null);
        }

        public static ServiceClientCredentials CreateUserCredentials(string domain, string clientId)
        {
            return CreateUserCredentials(domain, null, null, null, clientId);
        }

        public static ServiceClientCredentials CreateUserCredentials(string domain, AzureEnvironment environment, string clientId)
        {
            return CreateUserCredentials(domain, null, null, environment, clientId);
        }

        public static ServiceClientCredentials CreateUserCredentials(string domain, string username, SecureString password)
        {
            return CreateUserCredentials(domain, username, password, null, null);
        }

        public static ServiceClientCredentials CreateUserCredentials(string domain, string username, SecureString password, AzureEnvironment environment)
        {
            return CreateUserCredentials(domain, username, password, environment, null);
        }

        /// <summary>
        /// Create Azure Active Directory user credentials in the given azure environment, using the given domain, username, 
        /// password, and client id
        /// </summary>
        /// <param name="domain">The </param>
        /// <param name="username"></param>
        /// <param name="password"></param>
        /// <param name="clientId">The client ID to use in authentication</param>
        /// <returns></returns>
        public static ServiceClientCredentials CreateUserCredentials(string domain, string username, SecureString password, string clientId)
        {
            return CreateUserCredentials(domain, username, password, null, clientId);
        }

        /// <summary>
        /// Create Azure Active Directory user credentials in the given azure environment, using the given domain, 
        /// username, password, environment, and client id
        /// </summary>
        /// <param name="domain">The domain containing subscriptions or resources you wish to manage using the credentials.  
        /// This may be provided as a tenant id, or as the domain name of the corresponding AD directory.</param>
        /// <param name="username">The username to use for authentication.  If username is null or empty, a dialog will 
        /// prompt for credentials.</param>
        /// <param name="password">The password to use for authentication.  If password is null or empty, a dialog will 
        /// prompt for credentials</param>
        /// <param name="environment">The environment to authenticat against.  If no environment is provided, </param>
        /// <param name="clientId"></param>
        /// <returns>A ServiceClientCredentials object to authenticate requests for an Azure ServiceClient</returns>
        public static ServiceClientCredentials CreateUserCredentials(string domain, string username,
            SecureString password, AzureEnvironment environment, string clientId)
        {
            if (string.IsNullOrWhiteSpace(domain))
            {
                throw new ArgumentNullException("domain");
            }

            if (environment == null)
            {
                environment = AzureEnvironment.Azure;
            }

            if (string.IsNullOrWhiteSpace(clientId))
            {
                clientId = DefaultClientId;
            }

            return new AccessTokenCredentials(
                new ActiveDirectoryTokenProvider
                {
                    ClientId = clientId,
                    Domain = domain,
                    Environment = environment,
                    Id = username,
                    Secret = password
                }
            );
        }
    }
}
