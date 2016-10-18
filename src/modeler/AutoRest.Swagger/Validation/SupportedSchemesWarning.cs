// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class SupportedSchemesWarning : TypedRule<TransferProtocolScheme>
    {
        /// <summary>
        /// This rule passes if the scheme is of type https
        /// </summary>
        /// <param name="scheme"></param>
        /// <returns></returns>
        public override bool IsValid(TransferProtocolScheme scheme) => (scheme==TransferProtocolScheme.Https) || (scheme == TransferProtocolScheme.Http);

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.SupportedSchemesWarningMessage;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Warning;

    }
}
