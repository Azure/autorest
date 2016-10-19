// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class DisallowMsdnReferences : TypedRule<string>
    {
        private const string MsdnString = "https://msdn.microsoft.com/";

        /// <summary>
        /// An <paramref name="entity"/> fails this rule if its description contains references to https://msdn.microsoft.com/
        /// </summary>
        /// <param name="entity">The entity to validate</param>
        /// <returns></returns>
        public override bool IsValid(string entity) => string.IsNullOrEmpty(entity) || !entity.ToLowerInvariant().Contains(MsdnString);

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
