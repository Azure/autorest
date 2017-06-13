// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    internal static class EnumDefaultExtensions
    {
        /// <summary>
        ///     Determines if the SwaggerObject has both a default and an enum defined
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        internal static bool HasDefaultAndEnum(this SwaggerObject entity)
        {
            return !string.IsNullOrEmpty(entity.Default) && entity.Enum != null;
        }

        /// <summary>
        ///     Determines if the default value appears in the enum
        /// </summary>
        internal static bool EnumContainsDefault(this SwaggerObject entity)
        {
            return entity.Enum.Contains(entity.Default);
        }
    }

    public class DefaultMustBeInEnum : TypedRule<SwaggerObject>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R2027";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        ///     An <paramref name="entity" /> fails this rule if it has both default defined and enum and the default isn't in the
        ///     enum
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(SwaggerObject entity) =>
            entity == null || !entity.HasDefaultAndEnum() || entity.EnumContainsDefault();

        /// <summary>
        ///     The template message for this Rule.
        /// </summary>
        /// <remarks>
        ///     This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.InvalidDefault;

        /// <summary>
        ///     The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.Default;

        /// <summary>
        /// Whether the rule should be applied to the individual or composed context based on
        /// the corresponding .md file
        /// In most cases this should be composed
        /// This is because validation rules that run in individual mode will end up
        /// throwing multiple validation messages for the same violation if related model/property,etc 
        /// was referenced in multiple files
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Composed;

    }
}