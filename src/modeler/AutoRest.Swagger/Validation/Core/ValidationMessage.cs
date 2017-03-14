// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using AutoRest.Core.Logging;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace AutoRest.Swagger.Validation.Core
{
    /// <summary>
    /// Represents a single validation violation.
    /// </summary>
    public class ValidationMessage : LogMessage
    {
        public ValidationMessage(FileObjectPath path, Rule rule, params object[] formatArguments)
            : base(rule.Severity, $"{string.Format(CultureInfo.CurrentCulture, rule.MessageTemplate, formatArguments)}", path)
        {
            Rule = rule;
        }

        /// <summary>
        /// The validation rule which triggered this message.
        /// </summary>
        public Rule Rule { get; }
    }
}
