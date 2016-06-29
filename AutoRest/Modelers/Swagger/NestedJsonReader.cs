using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using Microsoft.Rest.Generator;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class NestedJsonReader : JsonTextReader
    {
        public string RawSource { get; private set; }

        public JsonSourceContext Source { get; private set; }

        public NestedJsonReader(StringReader source, JsonReader reader) : base(source)
        {
            SetParentReader(reader);
            RawSource = source?.ToString();
        }

        public NestedJsonReader(TextReader reader) : base(reader)
        {
        }

        /*
        private NestedJsonReader(TextReader reader, JsonSourceContext source) : this(reader)
        {
            Source = source;
        }
        */

        private void SetParentReader(JsonReader parentReader)
        {
            var parentSource = parentReader as NestedJsonReader;
            if (parentSource != null)
            {
                Source = parentSource.Source;
            }
        }

        /*
        public NestedJsonReader(string rawSource, JsonSourceContext source) : base(new StringReader(rawSource))
        {
            RawSource = rawSource;
            Source = source;
        }
        */
    }
}
