// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace AutoRest.Core.Logging
{
    /// <summary>
    /// Represents a log entry in tracing output.
    /// </summary>
    public class LogMessage
    {
        /// <summary>
        /// Instantiates a new instance of the LogEntry class.
        /// </summary>
        public LogMessage()
        {
        }

        /// <summary>
        /// Instantiates a new instance of the LogEntry class
        /// </summary>
        /// <param name="severity">The LogEntrySeverity of the LogEntry instance.</param>
        /// <param name="message">The message of the LogEntry instance.</param>
        public LogMessage(LogMessageSeverity severity, string message)
        {
            Severity = severity;
            Message = message;
        }

        public LogMessage(Rule rule)
        {
            Type = rule.GetType();
            Severity = rule.Severity;
            Message = rule.MessageTemplate;
        }

        public LogMessage(Rule rule, params object[] formatArguments)
        {
            Type = rule.GetType();
            Severity = rule.Severity;
            Message = string.Format(CultureInfo.CurrentCulture, rule.MessageTemplate, formatArguments);
        }

        /// <summary>
        /// The class of the Validation message
        /// </summary>
        public Type Type { get; }

        /// <summary>
        /// Gets or sets the LogEntrySeverity.
        /// </summary>
        public LogMessageSeverity Severity { get; set; }

        /// <summary>
        /// Gets or sets the Message.
        /// </summary>
        public string Message { get; set; }

        /// <summary>
        /// The JSON document path to the element being validated.
        /// </summary>
        public IList<string> Path { get; } = new List<string>();

        /// <summary>
        /// A fluent interface to append a string to the path.
        /// </summary>
        /// <param name="path">the string to add to the end of the Path collection</param>
        /// <returns>This ValidationMethod</returns>
        public LogMessage AppendToPath(string path)
        {
            Path.Add(path);
            return this;
        }
    }
}