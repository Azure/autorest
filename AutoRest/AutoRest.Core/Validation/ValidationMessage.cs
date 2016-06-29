using Microsoft.Rest.Generator.Logging;
using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Rest.Generator
{
    public class ValidationMessage
    {
        private IList<string> _path = new List<string>();

        public ValidationException ValidationException { get; set; }

        public SourceContext Source { get; set; }

        public string Message { get; set; }

        public LogEntrySeverity Severity { get; set; }

        public IList<string> Path
        {
            get { return this._path; }
            protected set
            {
                this._path = value.ToList();
            }
        }


        public override string ToString()
        {
            return string.Format("{0}: {1}\n    Location: Path: {2}", ValidationException, Message, string.Join("->", Path.Reverse()));
        }
    }
}
