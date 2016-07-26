// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
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
        public override LogEntrySeverity Severity => LogEntrySeverity.Error;
    }
}