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
    /// Represents a single validation violation.
    /// </summary>
    public class ComparisonMessage : LogMessage
    {
        public ComparisonMessage(MessageTemplate template, ObjectPath path, LogMessageSeverity severity)
            : this(template, path, severity, new string[0]) { }
        public ComparisonMessage(MessageTemplate template, ObjectPath path, LogMessageSeverity severity, params object[] formatArguments)
            : base(severity, $"Comparison: {template.Id} - {string.Format(CultureInfo.CurrentCulture, template.Message, formatArguments)}", path)
        {
            Id = template.Id;
        }

        /// <summary>
        /// The id of the validation message
        /// </summary>
        public int Id { get; private set; }
    }
}
