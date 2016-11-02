// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Text.RegularExpressions;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities.Collections;
using AutoRest.Python.Properties;

namespace AutoRest.Python
{
    public class CodeNamerPy : CodeNamer
    {
        /// <summary>
        ///     Initializes a new instance of Python's CodeNamer.
        /// </summary>
        public CodeNamerPy()
        {
            // List retrieved from
            // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Lexical_grammar#Keywords
            ReservedWords.AddRange(
                new[]
                {
                    "and","as","assert","break","class","continue",
                    "def","del","elif","else","except","exec",
                    "finally","for","from","global","if","import",
                    "in","is","lambda","not","or","pass",
                    "print","raise","return","try","while","with",
                    "yield",
                    // Though the following word is not python keyword, but it will cause trouble if we use them as variable, field, etc.
                    "int","bool","bytearray","date","datetime","float",
                    "long","object","decimal","str","timedelta"
                });
        }

        // "joined_lower" for functions, methods, attributes
        // do not invoke this for a class name which should be "StudlyCaps"
        [SuppressMessage("Microsoft.Globalization", "CA1308:NormalizeStringsToUppercase")]
        public string PythonCase(string name)
        {
            name = Regex.Replace(name, @"[A-Z]+", m =>
            {
                var matchedStr = m.ToString().ToLowerInvariant();
                if ((m.Index > 0) && (name[m.Index - 1] == '_'))
                {
                    //we are good if a '_' already exists 
                    return matchedStr;
                }
                // The first letter should not have _
                var prefix = m.Index > 0 ? "_" : string.Empty;
                if (ShouldInsertExtraLowerScoreInTheMiddle(name, m, matchedStr))
                {
                    // We will add extra _ if there are multiple upper case chars together
                    return prefix + matchedStr.Substring(0, matchedStr.Length - 1) + "_" +
                           matchedStr.Substring(matchedStr.Length - 1);
                }
                return prefix + matchedStr;
            });
            return name;
        }

        private bool ShouldInsertExtraLowerScoreInTheMiddle(string name, Match m, string matchedStr)
        {
            //For name like "SQLConnection", we will insert an extra '_' between "SQL" and "Connection"
            //we will only insert if there are more than 2 consecutive upper cases, because 2 upper cases
            //most likely means one single word. 
            var nextNonUpperCaseCharLocation = m.Index + matchedStr.Length;
            return (matchedStr.Length > 2) && (nextNonUpperCaseCharLocation < name.Length) &&
                   char.IsLetter(name[nextNonUpperCaseCharLocation]);
        }

        /// <summary>
        ///     Removes invalid characters from the name. Everything but alpha-numeral, underscore.
        /// </summary>
        /// <param name="name">String to parse.</param>
        /// <returns>Name with invalid characters removed.</returns>
        public string RemoveInvalidPythonCharacters(string name)
        {
            if (string.IsNullOrEmpty(name))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, Resources.InvalidIdentifierName,
                    name));
            }

            return GetValidName(name.Replace('-', '_'), '_');
        }

        private string GetValidPythonName(string name, string padString)
            => PythonCase(GetEscapedReservedName(RemoveInvalidPythonCharacters(name), padString));

        public override string GetFieldName(string name) => "_" + GetValidPythonName(name, "Variable");

        public override string GetPropertyName(string name) => GetValidPythonName(name, "Property");

        public override string GetMethodName(string name) => GetValidPythonName(name, "Method");

        public override string GetEnumMemberName(string name) => GetValidPythonName(name, "Enum");

        public override string GetParameterName(string name) => GetValidPythonName(name, "Parameter");

        public override string GetVariableName(string name) => GetValidPythonName(name, "Variable");

        /// <summary>
        ///     Returns a quoted string for the given language if applicable.
        /// </summary>
        /// <param name="defaultValue">Value to quote.</param>
        /// <param name="type">Data type.</param>
        public override string EscapeDefaultValue(string defaultValue, IModelType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            var parsedDefault = PythonConstants.None;

            EnumType enumType = type as EnumType;
            if (defaultValue != null && enumType != null)
            {
                parsedDefault = QuoteValue(defaultValue);
            }

            PrimaryType primaryType = type as PrimaryType;
            if (defaultValue != null && primaryType != null)
            {
                if (primaryType.KnownPrimaryType == KnownPrimaryType.String || primaryType.KnownPrimaryType== KnownPrimaryType.Uuid)
                {
                    parsedDefault = QuoteValue(defaultValue);
                }
                else if (primaryType.KnownPrimaryType == KnownPrimaryType.Boolean)
                {
                    if (defaultValue == "true")
                    {
                        parsedDefault = "True";
                    }
                    else
                    {
                        parsedDefault = "False";
                    }
                }
                else
                {
                    //TODO: Add support for default KnownPrimaryType.DateTimeRfc1123

                    if (primaryType.KnownPrimaryType == KnownPrimaryType.Date ||
                        primaryType.KnownPrimaryType == KnownPrimaryType.DateTime ||
                        primaryType.KnownPrimaryType == KnownPrimaryType.TimeSpan)
                    {
                        parsedDefault = QuoteValue(defaultValue);
                    }

                    else if (primaryType.KnownPrimaryType == KnownPrimaryType.ByteArray)
                    {
                        parsedDefault = "bytearray(\"" + defaultValue + "\", encoding=\"utf-8\")";
                    }

                    else if (primaryType.KnownPrimaryType == KnownPrimaryType.Int ||
                        primaryType.KnownPrimaryType == KnownPrimaryType.Long ||
                        primaryType.KnownPrimaryType == KnownPrimaryType.Double)
                    {
                        parsedDefault = defaultValue;
                    }
                }
            }
            return parsedDefault;
        }
    }
}