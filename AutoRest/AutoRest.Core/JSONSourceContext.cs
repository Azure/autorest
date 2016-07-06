using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace Microsoft.Rest.Generator
{
    public class JsonSourceContext : SourceContext
    {
        public JsonSourceContext(string jsonSource)
        {
            this.RawSource = jsonSource;
        }
    }
}
