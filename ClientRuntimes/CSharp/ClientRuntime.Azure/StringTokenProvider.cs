using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Microsoft.Azure
{
    public sealed class StringTokenProvider : ITokenProvider
    {
        public StringTokenProvider(string accessToken)
        {
            _accessToken = accessToken;
        }

        private string _accessToken;
        public Task<string> GetAccessTokenAsync(CancellationToken cancellationToken)
        {
            return Task.FromResult(_accessToken);
        }
    }
}
