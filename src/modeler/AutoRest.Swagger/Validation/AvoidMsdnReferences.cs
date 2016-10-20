// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class AvoidMsdnReferences : TypedRule<string>
    {
        private static readonly Regex MsdnRegex = new Regex(@"https?:\/\/msdn(?:.microsoft)?.com\/", RegexOptions.IgnoreCase);

        /// <summary>
        /// An <paramref name="entity"/> fails this rule if its description contains references to "msdn.microsoft.com".
        /// </summary>
        /// <param name="entity">The entity to validate</param>
        /// <returns></returns>
        public override bool IsValid(string entity) => string.IsNullOrEmpty(entity) || !MsdnRegex.IsMatch(entity);

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.MsdnReferencesDiscouraged;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Warning;

    }
}
