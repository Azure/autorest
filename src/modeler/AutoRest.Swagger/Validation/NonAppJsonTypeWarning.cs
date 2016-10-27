// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;

namespace AutoRest.Swagger.Validation
{
    public class NonAppJsonTypeWarning : TypedRule<string>
    {
        private const string AppJsonType = "application/json";
        /// <summary>
        /// This rule passes if the entity contains application/json type 
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(string entity)
            => (entity.ToLowerInvariant().StartsWith(AppJsonType));
        
        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.NonAppJsonTypeNotSupported;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Warning;

    }
}
