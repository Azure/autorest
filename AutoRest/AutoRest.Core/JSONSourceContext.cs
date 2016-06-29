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
        public JsonSourceContext(int lineNumber, int linePosition, string jsonSource)
        {
            this.LineNumber = lineNumber;
            this.LinePosition = linePosition;
            this.RawSource = jsonSource;
        }
    }
}
