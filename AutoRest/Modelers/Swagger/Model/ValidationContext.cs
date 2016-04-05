using System;
using System.Collections.Generic;
using Microsoft.Rest.Generator.Logging;

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

        public Dictionary<string, Schema> Definitions { get; set; }
        public Dictionary<string, Schema> PriorDefinitions { get; set; }

        public Dictionary<string, SwaggerParameter> Parameters { get; set; }
        public Dictionary<string, SwaggerParameter> PriorParameters { get; set; }

        public Dictionary<string, OperationResponse> Responses { get; set; }
        public Dictionary<string, OperationResponse> PriorResponses { get; set; }

        public List<LogEntry> ValidationErrors { get; set; }

        public void LogError(string message)
        {
            ValidationErrors.Add(new LogEntry
            {
                Severity = LogEntrySeverity.Error,
                Message = string.Format("{0}: {1}", Title, message)
            });
        }

        public void LogBreakingChange(string message)
        {
            ValidationErrors.Add(new LogEntry
            {
                Severity = Strict ? LogEntrySeverity.Error : LogEntrySeverity.Warning,
                Message = string.Format("{0}: {1}", Title, message)
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
