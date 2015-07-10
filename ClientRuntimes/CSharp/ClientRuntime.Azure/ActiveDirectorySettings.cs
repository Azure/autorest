using System;
using System.Collections.Generic;
using System.Linq;
using System.Security;
using System.Text;
using System.Threading.Tasks;

namespace Microsoft.Azure
{
    /// <summary>
    /// Settings for active directory authentication
    /// </summary>
    public class ActiveDirectorySettings
    {
        /// <summary>
        /// Default client id for Azure SDK
        /// </summary>
        public static readonly string DefaultClientId = "1950a258-227b-4e31-a9cf-717495945fc2";

        /// <summary>
        /// Redirect URI for portable and windows applications
        /// </summary>
        public static readonly Uri DefaultRedirectUri = new Uri("urn:ietf:wg:oauth:2.0:oob");

        /// <summary>
        /// Create default active directory settings using client defaults
        /// </summary>
        public ActiveDirectorySettings()
        {
            Environment = AzureEnvironment.Azure;
            ClientId = DefaultClientId;
            RedirectUri = DefaultRedirectUri;
        }

        /// <summary>
        /// Gets or sets the authentication settings for this installation of active directory
        /// </summary>
        public AzureEnvironment Environment { get; set; }

        /// <summary>
        /// Gets or sets the application id for the client that is authenticating against Active Directory
        /// </summary>
        public string ClientId { get; set; }

        /// <summary>
        /// Gets or sets the redirect URI for authentication requests processed by this application
        /// </summary>
        public Uri RedirectUri { get; set; }
    }
}
