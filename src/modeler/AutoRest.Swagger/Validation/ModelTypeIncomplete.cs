// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class ModelTypeIncomplete : TypedRule<Schema>
    {
        public override IEnumerable<LogMessage> GetLogMessages(Schema schema, RuleContext context)
        {
            if (schema != null && string.IsNullOrEmpty(schema.Reference) && schema.RepresentsCompositeType())
            {
                if (schema.Description == null)
                {
                    yield return new LogMessage(this, "description");
                }
            }
        }

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "This definition lacks the property '{0}', which is required for model types";

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogMessageSeverity Severity => LogMessageSeverity.Warning;
    }
}
