using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generators.Validation;
using System.Linq;

namespace Microsoft.Rest.Generator.Validation
{
    public class ValidationMessage
    {
        public ValidationException ValidationException { get; set; }

        public SourceContext Source { get; set; }

        public string Message { get; set; }

        public LogEntrySeverity Severity { get; set; }

        public override string ToString()
        {
            return string.Format("{0}: {1}\n    Location: Path: {2}\n              Line {3}", (int)ValidationException, Message, string.Join("->", Source.Path.Reverse()), Source.LineNumber);
        }
    }
}
