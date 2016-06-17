using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Modeler.Swagger.Model;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class ValidationMessage
    {
        public object Source { get; set; }

        public string Message { get; set; }

        public LogEntrySeverity Severity { get; set; }
    }
}
