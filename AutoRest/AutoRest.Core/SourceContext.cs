using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Microsoft.Rest.Generator
{
    public abstract class SourceContext
    {
        private readonly IList<string> _path = new List<string>();
        public SourceContext()
        {
        }

        public IList<string> Path
        {
            get { return this._path; }
        }

        public int LineNumber { get; protected set; }

        public int LinePosition { get; protected set; }

        public string RawSource { get; protected set; }
    }
}
