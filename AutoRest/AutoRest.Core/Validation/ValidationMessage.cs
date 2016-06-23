using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generators.Validation;

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
            return string.Format("{0}: {1}\n    Location: Line {2}", (int)ValidationException, Message, Source.LineNumber);
        }
    }
}
