// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Linq;
using AutoRest.Core.Logging;

namespace AutoRest.Core.Validation
{
    /// <summary>
    ///     This validator is applied all string members, and ensures that no control
    ///     characters are permitted at all.
    /// </summary>
    public class NoControlCharacters : TypedRule<string>
    {
        /// <summary>
        ///     Ensures that the string starts with a letter or underscore
        ///     and contains only legal identifier characters.
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(string entity, out object[] formatParameters)
        {

            if (entity.All(ch => ch >= ' ' || ch == '\t' || ch == '\r' || ch == '\n'))
            {
                formatParameters = null;
                return true;
            }
            formatParameters = new object[]
            {
                entity,
                entity.Where(ch => ch < ' ').Aggregate("", (s, ch) => $"{s}, 0x{Convert.ToInt32(ch):X}")
            };
            return false;
        }

        /// <summary>
        ///     The template message for this Rule.
        /// </summary>
        /// <remarks>
        ///     This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate
            => "May not contain control characters ({0} contains {1})";

        /// <summary>
        ///     The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Error;
    }
}