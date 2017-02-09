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
    public class ValidationMessage : LogMessage
    {
        public ValidationMessage(ObjectPath path, Rule rule, params object[] formatArguments)
            : base(rule.Severity, $"{rule.GetType().Name} - {string.Format(CultureInfo.CurrentCulture, rule.MessageTemplate, formatArguments)}", path)
        {
            Type = rule.GetType();
        }

        /// <summary>
        /// The class of the Validation message
        /// </summary>
        public Type Type { get; }

    }
}
