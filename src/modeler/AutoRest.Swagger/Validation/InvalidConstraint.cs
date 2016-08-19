// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class InvalidConstraint : TypedRule<object>
    {
        /// <summary>
        ///     Fails this rule if constraint isn't supported for SwaggerObject type
        /// </summary>
        /// <param name="constraintValue"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public override bool IsValid(object constraintValue, RuleContext context)
        {
            if ((constraintValue is bool) && !(bool)constraintValue)
            {
                return true;
            }
            return (context.Parent?.Value as SwaggerObject).IsConstraintSupported(context.Key);
        }

    /// <summary>
    ///     The template message for this Rule.
    /// </summary>
    /// <remarks>
    ///     This may contain placeholders '{0}' for parameterized messages.
    /// </remarks>
        public override string MessageTemplate => Resources.InvalidConstraint;

            /// <summary>
            ///     The severity of this message (ie, debug/info/warning/error/fatal, etc)
            /// </summary>
            public override LogEntrySeverity Severity => LogEntrySeverity.Warning;
        }
    }
