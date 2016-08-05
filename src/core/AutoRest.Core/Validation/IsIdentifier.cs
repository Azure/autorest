// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Linq;
using AutoRest.Core.Logging;

namespace AutoRest.Core.Validation
{
    /// <summary>
    ///     This validator should be applied to all elements in the model that
    ///     represent identifiers.
    /// </summary>
    public class IsIdentifier : TypedRule<string>
    {
        /// <summary>
        /// Start characters are letters or underscores.
        /// </summary>
        /// <param name="ch"></param>
        /// <returns></returns>
        private static bool IsStartChar(char ch) => ch >= 'a' && ch <= 'z' ||
                                                    ch >= 'A' && ch <= 'Z' ||
                                                    ch == '_';

        /// <summary>
        /// Identifier characters are letters, underscores or numbers.
        /// </summary>
        /// <param name="ch"></param>
        /// <returns></returns>
        private static bool IsIdentifierChar(char ch) => ch >= '0' && ch <= '9' || IsStartChar(ch);

        /// <summary>
        ///     Ensures that the string starts with a letter or underscore
        ///     and contains only legal identifier characters.
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(string entity)
            => IsStartChar(entity[0]) && entity.All(IsIdentifierChar);

        /// <summary>
        ///     The template message for this Rule.
        /// </summary>
        /// <remarks>
        ///     This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate
            => "Identifiers may not contain characters other than letters, numbers and underscores";

        /// <summary>
        ///     The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Error;
    }
}