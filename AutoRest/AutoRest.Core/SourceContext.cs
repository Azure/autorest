using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Microsoft.Rest.Generator
{
    public abstract class SourceContext
    {
        public string RawSource { get; protected set; }
    }
}
