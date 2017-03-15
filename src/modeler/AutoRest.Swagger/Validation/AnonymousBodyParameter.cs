// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class AnonymousBodyParameter : TypedRule<SwaggerParameter>
    {
        private static AvoidAnonymousTypes AnonymousTypesRule = new AvoidAnonymousTypes();

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
        /// An entity fails this rule if it has a schema, and that schema is an anonymous type
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(SwaggerParameter entity) =>
            entity?.Schema == null || AnonymousTypesRule.IsValid(entity.Schema);
    }
}
