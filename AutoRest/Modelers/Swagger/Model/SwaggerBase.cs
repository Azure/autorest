// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using Newtonsoft.Json;
using Microsoft.Rest.Generator.Logging;

namespace Microsoft.Rest.Modeler.Swagger.Model
{
    [Serializable]
    public abstract class SwaggerBase
    {
        public SwaggerBase()
        {
            Extensions = new Dictionary<string, object>();
        }

        /// <summary>
        /// Vendor extensions.
        /// </summary>
        [JsonExtensionData]
        public Dictionary<string, object> Extensions { get; set; }

        /// <summary>
        /// Validates the Swagger object against a number of object-specific validation rules.
        /// </summary>
        /// <returns>True if there are no validation errors, false otherwise.</returns>
        public virtual bool Validate(ValidationContext context)
        {
            var errorCount = context.ValidationErrors.Count;
            object clientName = null;
            if (Extensions.TryGetValue("x-ms-client-name", out clientName))
            {
                if (string.IsNullOrEmpty(clientName as string))
                {
                    // TODO: where is this located in the input specification document?
                    context.LogError(string.Format(CultureInfo.InvariantCulture, "Empty x-ms-client-name property."));
                }
            }
            return context.ValidationErrors.Count == errorCount;
        }

        /// <summary>
        /// Compares the Swagger object against the prior version, looking for potential breaking changes.
        /// </summary>
        /// <param name="priorVersion"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public virtual bool Compare(SwaggerBase priorVersion, ValidationContext context)
        {
            return true;
        }
    }

    public class ValidationContext
    {
        public ValidationContext()
        {
            Strict = false;
            ValidationErrors = new List<LogEntry>();
            _title.Push("");
        }

        public bool Strict { get; set; }

        public string Title { get { return _title.Peek(); } }

        public void PushTitle(string title) { _title.Push(title); }
        public void PopTitle() { _title.Pop(); }

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
}