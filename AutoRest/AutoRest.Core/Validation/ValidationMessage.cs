using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generators.Validation;

namespace Microsoft.Rest.Generator.Validation
{
    public class ValidationMessage
    {
        public ValidationException ValidationException { get; set; }

        public object Source { get; set; }

        public string Message { get; set; }

        public LogEntrySeverity Severity { get; set; }
    }
}
