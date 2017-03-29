// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class AvoidAnonymousTypes : TypedRule<SwaggerObject>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2026";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.AnonymousTypesDiscouraged;

        /// <summary>
        /// An <paramref name="entity"/> fails this rule if it doesn't have a reference (meaning it's defined inline)
        /// </summary>
        /// <param name="entity">The entity to validate</param>
        /// <returns></returns>
        public override bool IsValid(SwaggerObject entity) => (entity?.GetType() == typeof(Schema) &&
            ((((Schema)entity).Properties == null) || ((Schema)entity).Properties?.Count == 0));

    }
}