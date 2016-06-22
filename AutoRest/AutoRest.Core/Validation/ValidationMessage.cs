using Microsoft.Rest.Generator.Logging;

namespace Microsoft.Rest.Generator.Validation
{
    public class ValidationMessage
    {
        public object Source { get; set; }

        public string Message { get; set; }

        public LogEntrySeverity Severity { get; set; }
    }
}
