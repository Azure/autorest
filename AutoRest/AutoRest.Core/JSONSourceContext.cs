using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace Microsoft.Rest.Generator
{
    public class JSONSourceContext : SourceContext
    {
        public JSONSourceContext(int lineNumber, int linePosition, string jsonSource)
        {
            this.LineNumber = lineNumber;
            this.LinePosition = linePosition;
            this.RawSource = jsonSource;
        }
    }
}
