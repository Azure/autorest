// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class ValidFormats : TypedRule<string>
    {
        /// <summary>
        /// An <paramref name="entity" /> fails this rule if it has a format that we can't handle
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(string format, RuleContext context, out object[] formatParams)
        {
            var swaggerObject = (context.Parent?.Value as SwaggerObject);
            var knownFormat = swaggerObject?.KnownFormat;

            if(knownFormat != null && knownFormat == Core.ClientModel.KnownFormat.unknown)
            {
                formatParams = new string[] { swaggerObject?.Format };
                return false;
            }

            formatParams = new object[0];
            return true;
        }

        /// <summary>
        ///     The template message for this Rule.
        /// </summary>
        /// <remarks>
        ///     This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.UnknownFormat;

        /// <summary>
        ///     The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Warning;
    }
}