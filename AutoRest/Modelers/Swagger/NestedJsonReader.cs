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
        public string RawSource;

        public JSONSourceContext Source { get; private set; }

        public NestedJsonReader(TextReader reader) : base(reader)
        {
        }

        private NestedJsonReader(TextReader reader, JSONSourceContext source) : this(reader)
        {
            Source = source;
        }

        private NestedJsonReader(TextReader reader, JsonReader parentReader) : this(reader)
        {
            var parentSource = parentReader as NestedJsonReader;
            if (parentSource != null)
            {
                Source = parentSource.Source;
            }
        }

        public NestedJsonReader(string rawSource, JSONSourceContext source) : base(new StringReader(rawSource))
        {
            RawSource = rawSource;
            Source = source;
        }

        public NestedJsonReader(string rawSource, JsonReader reader) : this(new StringReader(rawSource), reader)
        {
            RawSource = rawSource;
        }
    }
}
