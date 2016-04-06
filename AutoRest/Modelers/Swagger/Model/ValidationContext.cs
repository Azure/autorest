using System.Globalization;
using System.Collections.Generic;
using Resources = Microsoft.Rest.Modeler.Swagger.Properties.Resources;
using Microsoft.Rest.Generator.Logging;
using System.Diagnostics.CodeAnalysis;

namespace Microsoft.Rest.Modeler.Swagger.Model
{
    /// <summary>
    /// Specifies a context used in validation and version compare.
    /// </summary>
    public class ValidationContext
    {
        public ValidationContext()
        {
            Direction = DataDirection.None;
            Strict = false;
            ValidationErrors = new List<LogEntry>();
            _title.Push("");
        }

        public bool Strict { get; set; }

        public string Title { get { return _title.Peek(); } }


        public void PushTitle(string title) { _title.Push(title); }
        public void PopTitle() { _title.Pop(); }

        public string Path { get; set; }

        public DataDirection Direction { get; set; }

        public Dictionary<string, Schema> Definitions { get; internal set; }
        public Dictionary<string, Schema> PriorDefinitions { get; internal set; }

        public Dictionary<string, SwaggerParameter> Parameters { get; internal set; }
        public Dictionary<string, SwaggerParameter> PriorParameters { get; internal set; }

        public Dictionary<string, OperationResponse> Responses { get; internal set; }
        public Dictionary<string, OperationResponse> PriorResponses { get; internal set; }

        [SuppressMessage("Microsoft.Design", "CA1002:DoNotExposeGenericLists", Justification = "Only used internally.")]
        public List<LogEntry> ValidationErrors { get; private set; }

        public void LogError(string message)
        {
            ValidationErrors.Add(new LogEntry
            {
                Severity = LogEntrySeverity.Error,
                Message = string.Format(CultureInfo.InvariantCulture, Resources.ZeroColonOne2, Title, message)
            });
        }

        public void LogBreakingChange(string message)
        {
            ValidationErrors.Add(new LogEntry
            {
                Severity = Strict ? LogEntrySeverity.Error : LogEntrySeverity.Warning,
                Message = string.Format(CultureInfo.InvariantCulture, Resources.ZeroColonOne2, Title, message)
            });
        }

        private Stack<string> _title = new Stack<string>();
    }

    public enum DataDirection
    {
        None,
        Request,
        Response
    }
}
