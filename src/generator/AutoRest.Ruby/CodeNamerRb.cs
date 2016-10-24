// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;

namespace AutoRest.Ruby
{
    /// <summary>
    /// A class which keeps all naming related functionality.
    /// </summary>
    public class CodeNamerRb : CodeNamer
    {
        /// <summary>
        /// The set of already normalized types.
        /// </summary>
        private readonly HashSet<IModelType> normalizedTypes;

        /// <summary>
        /// Initializes a new instance of RubyCodeNamer.
        /// </summary>
        public CodeNamerRb()
        {
            new HashSet<string>
            {
                "begin",    "do",       "next",     "then",     "end",
                "else",     "nil",      "true",     "alias",    "elsif",
                "not",      "undef",    "and",      "end",      "or",
                "unless",   "begin",    "ensure",   "redo",     "until",
                "break",    "false",    "rescue",   "when",     "case",
                "for",      "retry",    "while",    "class",    "if",
                "return",   "while",    "def",      "in",       "self",
                "__file__", "defined?", "module",   "super",    "__line__",
                "yield"
            }.ForEach(s => ReservedWords.Add(s));

            normalizedTypes = new HashSet<IModelType>();
        }

        /// <summary>
        /// Formats segments of a string into "underscore" case.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public virtual string UnderscoreCase(string name)
        {
            if (string.IsNullOrEmpty(name))
            {
                return name;
            }

            return Regex.Replace(name, @"(\p{Ll})(\p{Lu})", "$1_$2").ToLower();
        }

        /// <summary>
        /// Corrects characters for Ruby compatibility.
        /// </summary>
        /// <param name="name">String to correct.</param>
        /// <returns>Corrected string.</returns>
        public string RubyRemoveInvalidCharacters(string name)
        {
            if (string.IsNullOrEmpty(name))
            {
                return name;
            }

            return RemoveInvalidCharacters(name).Replace('-', '_');
        }

        /// <summary>
        /// Returns name for the method which doesn't contain forbidden characters for current language.
        /// </summary>
        /// <param name="name">The intended name of method.</param>
        /// <returns>The corrected name of method.</returns>
        public override string GetMethodName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }

            return UnderscoreCase(RubyRemoveInvalidCharacters(GetEscapedReservedName(name, "Operation")));
        }

        /// <summary>
        /// Returns name for the field which doesn't contain forbidden characters for current language.
        /// </summary>
        /// <param name="name">The intended name of field.</param>
        /// <returns>The corrected name of field.</returns>
        public override string GetFieldName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }

            return GetVariableName(name);
        }

        /// <summary>
        /// Returns name for the property which doesn't contain forbidden characters for current language.
        /// </summary>
        /// <param name="name">The intended name of property.</param>
        /// <returns>The corrected name of property.</returns>
        public override string GetPropertyName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }

            return UnderscoreCase(RubyRemoveInvalidCharacters(GetEscapedReservedName(name, "Property")));
        }

        /// <summary>
        /// Returns name for the variable which doesn't contain forbidden characters for current language.
        /// </summary>
        /// <param name="name">The intended name of variable.</param>
        /// <returns>The corrected name of variable.</returns>
        public override string GetVariableName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }

            return UnderscoreCase(RubyRemoveInvalidCharacters(GetEscapedReservedName(name, "Variable")));
        }

        public override string EscapeDefaultValue(string defaultValue, IModelType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            PrimaryType primaryType = type as PrimaryType;
            if (defaultValue != null && primaryType != null)
            {
                if (primaryType.KnownPrimaryType == KnownPrimaryType.String)
                {
                    return QuoteValue(defaultValue, quoteChar: "'");
                }
                else if (primaryType.KnownPrimaryType == KnownPrimaryType.Boolean)
                {
                    return defaultValue.ToLowerInvariant();
                }
                else
                {
                    if (primaryType.KnownPrimaryType == KnownPrimaryType.Date ||
                        primaryType.KnownPrimaryType == KnownPrimaryType.DateTime ||
                        primaryType.KnownPrimaryType == KnownPrimaryType.DateTimeRfc1123 ||
                        primaryType.KnownPrimaryType == KnownPrimaryType.TimeSpan)
                    {
                        return "Date.parse('" + defaultValue + "')";
                    }

                    if (primaryType.KnownPrimaryType == KnownPrimaryType.ByteArray)
                    {
                        return "'" + defaultValue + "'.bytes.pack('C*')";
                    }
                }
            }

            EnumType enumType = type as EnumType;
            if (defaultValue != null && enumType != null)
            {
                return QuoteValue(defaultValue, quoteChar: "'");
            }
            return defaultValue;
        }
    }
}
