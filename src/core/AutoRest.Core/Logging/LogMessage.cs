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
        /// Instantiates a new instance of the LogEntry class
        /// </summary>
        /// <param name="severity">The LogEntrySeverity of the LogEntry instance.</param>
        /// <param name="message">The message of the LogEntry instance.</param>
        public LogMessage(LogMessageSeverity severity, string message)
            : this(severity, message, new ObjectPath()) { }

        public LogMessage(LogMessageSeverity severity, string message, ObjectPath path)
        {
            if (path == null)
            {
                throw new ArgumentNullException(nameof(path));
            }
            Severity = severity;
            Message = message;
            Path = path;
        }

        public LogMessage(ObjectPath path, Rule rule)
            : this(path, rule, new string[0]) { }

        public LogMessage(ObjectPath path, Rule rule, params object[] formatArguments)
            : this(rule.Severity, string.Format(CultureInfo.CurrentCulture, rule.MessageTemplate, formatArguments), path)
        {
            Type = rule.GetType();
        }

        /// <summary>
        /// The class of the Validation message
        /// </summary>
        public Type Type { get; }

        /// <summary>
        /// Gets or sets the LogEntrySeverity.
        /// </summary>
        public LogMessageSeverity Severity { get; }

        /// <summary>
        /// Gets or sets the Message.
        /// </summary>
        public string Message { get; }

        /// <summary>
        /// The JSON document path to the element being validated.
        /// </summary>
        public ObjectPath Path { get; }
    }
}