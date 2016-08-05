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
    public class ValidationMessage
    {
        public ValidationMessage(Rule rule)
        {
            Type = rule.GetType();
            Severity = rule.Severity;
            Message = string.Empty;
        }
        public ValidationMessage(Rule rule, params object[] formatArguments)
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
        /// The formatted message text for the validation message
        /// </summary>
        public string Message { get; }

        /// <summary>
        /// The serverity of the validation message.
        /// </summary>
        public LogEntrySeverity Severity { get; }

        /// <summary>
        /// The JSON document path to the element being validated.
        /// </summary>
        public IList<string> Path { get; } = new List<string>();

        /// <summary>
        /// A fluent interface to append a string to the path.
        /// </summary>
        /// <param name="path">the string to add to the end of the Path collection</param>
        /// <returns>This ValidationMethod</returns>
        public ValidationMessage AppendToPath(string path)
        {
            Path.Add(path);
            return this;
        }

        public override string ToString() => $"{Type.Name}: {Message}\n    Location: Path: {string.Join("->", Path.Reverse())}";
    }
}
