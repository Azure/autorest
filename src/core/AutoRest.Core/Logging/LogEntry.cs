// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Core.Logging
{
    /// <summary>
    /// Represents a log entry in tracing output.
    /// </summary>
    public class LogEntry
    {
        /// <summary>
        /// Instantiates a new instance of the LogEntry class.
        /// </summary>
        public LogEntry()
        {
        }

        /// <summary>
        /// Instantiates a new instance of the LogEntry class
        /// </summary>
        /// <param name="severity">The LogEntrySeverity of the LogEntry instance.</param>
        /// <param name="message">The message of the LogEntry instance.</param>
        public LogEntry(LogEntrySeverity severity, string message)
        {
            Severity = severity;
            Message = message;
        }

        /// <summary>
        /// Gets or sets the LogEntrySeverity.
        /// </summary>
        public LogEntrySeverity Severity { get; set; }

        /// <summary>
        /// Gets or sets the Message.
        /// </summary>
        public string Message { get; set; }

        /// <summary>
        /// Gets or sets the Exception to log.
        /// </summary>
        public Exception Exception { get; set; }
    }
}