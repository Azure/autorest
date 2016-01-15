using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;

namespace Fixtures.InternalCtors
{
    public partial class InternalClient
    {
        public InternalClient(string accountName, Uri baseUri) : 
            this(new Uri(baseUri.AbsoluteUri + accountName))
        { }       
    }
}
