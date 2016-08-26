// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using AutoRest.Core.Logging;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace AutoRest.Core.Validation
{
    /// <summary>
    /// Represents a single validtion violation (can just a debug message, informational, warning, error, or fatal error)
    /// </summary>
    public class ComparisonMessage
    {
        public ComparisonMessage(MessageTemplate template, string path, LogEntrySeverity severity)
        {
            if (template == null)
                throw new ArgumentNullException("template");

            Severity = severity;
            Id = template.Id;
            Path = path;
            Message = template.Message;
        }
        public ComparisonMessage(MessageTemplate template, string path, LogEntrySeverity severity, params object[] formatArguments)
        {
            Severity = severity;
            Id = template.Id;
            Path = path;
            Message = string.Format(CultureInfo.CurrentCulture, template.Message, formatArguments);
        }

        /// <summary>
        /// The id of the validation message
        /// </summary>
        public int Id { get; private set; }

        /// <summary>
        /// The formatted message text for the validation message
        /// </summary>
        public string Message { get; private set; }

        /// <summary>
        /// The path is used to identify the Swagger element that a message refers to.
        /// </summary>
        public string Path { get; private set; }

        /// <summary>
        /// The serverity of the validation message.
        /// </summary>
        public LogEntrySeverity Severity { get; }

        public override string ToString() => $"{Id}: {Message}\n    Path: {Path}";
    }
}
