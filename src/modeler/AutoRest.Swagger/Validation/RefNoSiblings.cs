// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    internal static class SwaggerObjectExtensions
    {
        internal static bool DefinesInlineProperties(this SwaggerObject entity)
        {
            return entity.Description != null
                || entity.Items != null
                || entity.Type != null;
        }
    }

    public class RefsMustNotHaveSiblings : TypedRule<SwaggerObject>
    {
        /// <summary>
        /// This rule passes if the entity does not have both a reference and define properties inline
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(SwaggerObject entity)
            => entity == null || string.IsNullOrEmpty(entity.Reference) || !entity.DefinesInlineProperties();

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.ConflictingRef;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Warning;

    }
}
