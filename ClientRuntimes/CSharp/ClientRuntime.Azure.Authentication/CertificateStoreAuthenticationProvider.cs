using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Microsoft.Rest.Azure.Authentication
{
    public class CertificateStoreAuthenticationProvider : IApplicationAuthenticationProvider
    {
        public Task<IdentityModel.Clients.ActiveDirectory.AuthenticationResult> AuthenticateAsync(string clientId, string audience, IdentityModel.Clients.ActiveDirectory.AuthenticationContext context)
        {
            throw new NotImplementedException();
        }
    }
}
