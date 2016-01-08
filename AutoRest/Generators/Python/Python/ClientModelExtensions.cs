// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using System;
using System.Globalization;
using System.Linq;
using System.Collections.Generic;
using System.Text;

namespace Microsoft.Rest.Generator.Python.TemplateModels
{
    public static class ClientModelExtensions
    {
        /// <summary>
        /// Format the value of a sequence given the modeled element format.  Note that only sequences of strings are supported
        /// </summary>
        /// <param name="parameter">The parameter to format</param>
        /// <returns>return the separator</returns>
        public static string NeedsFormattedSeparator(Parameter parameter)
        {
            if (parameter == null)
            {
                throw new ArgumentNullException("parameter");
            }

            SequenceType sequence = parameter.Type as SequenceType;
            if (sequence == null)
            {
                return null;
            }

            PrimaryType primaryType = sequence.ElementType as PrimaryType;
            EnumType enumType = sequence.ElementType as EnumType;
            if (enumType != null)
            {
                primaryType = PrimaryType.String;
            }

            if (primaryType != PrimaryType.String)
            {
                throw new InvalidOperationException(
                    string.Format(CultureInfo.InvariantCulture,
                    "Cannot generate a formatted sequence from a " +
                                  "non-string array parameter {0}", parameter));
            }

            return parameter.CollectionFormat.GetSeparator();
        }

        /// <summary>
        /// Return the separator associated with a given collectionFormat
        /// </summary>
        /// <param name="format">The collection format</param>
        /// <returns>The separator</returns>
        private static string GetSeparator(this CollectionFormat format)
        {
            switch (format)
            {
                case CollectionFormat.Csv:
                    return ",";
                case CollectionFormat.Pipes:
                    return "|";
                case CollectionFormat.Ssv:
                    return " ";
                case CollectionFormat.Tsv:
                    return "\t";
                default:
                    throw new NotSupportedException(string.Format(CultureInfo.InvariantCulture,
                        "Collection format {0} is not supported.", format));
            }
        }

        public static string TrimMultilineHeader(this string header)
        {
            if (string.IsNullOrEmpty(header))
            {
                return header;
            }
            StringBuilder builder = new StringBuilder();
            foreach (var headerLine in header.Split(new string[] { Environment.NewLine }, StringSplitOptions.None))
            {
                builder.Append(headerLine.TrimEnd()).Append(Environment.NewLine);
            }
            return builder.ToString();
        }

        /// <summary>
        /// Converts the specified string to a python style string.
        /// </summary>
        /// <param name="value">The string to convert.</param>
        /// <returns>The python style string.</returns>
        public static string ToPythonCase(this string value)
        {
            return PythonCodeNamer.PythonCase(value);
        }

        /// <summary>
        /// Simple conversion of the type to string
        /// </summary>
        /// <param name="type">The type to convert</param>
        /// <param name="reference">a reference to an instance of the type</param>
        /// <returns></returns>
        public static string ToString(this IType type, string reference)
        {
            return string.Format(CultureInfo.InvariantCulture,
                "self._serialize.serialize_data({0}, '{1}')", reference, type.ToPythonRuntimeTypeString());
        }

        /// <summary>
        /// Simple conversion of the type to string
        /// </summary>
        /// <param name="type">The type to convert</param>
        /// <returns></returns>
        public static string ToPythonRuntimeTypeString(this IType type)
        {
            if (type == null)
            {
                return string.Empty;
            }

            var known = type as PrimaryType;

            if (known == PrimaryType.Date)
            {
                return "date";
            }

            if (known == PrimaryType.DateTimeRfc1123)
            {
                return "rfc-1123";
            }

            if (known == PrimaryType.DateTime)
            {
                return "iso-8601"; 
            }

            if (known == PrimaryType.TimeSpan)
            {
                return "duration";
            }

            var sequenceType = type as SequenceType;
            if (sequenceType != null)
            {
                return "[" + sequenceType.ElementType.ToPythonRuntimeTypeString() + "]";
            }

            var dictionaryType = type as DictionaryType;
            if (dictionaryType != null)
            {
                return "{" + dictionaryType.ValueType.ToPythonRuntimeTypeString() + "}";
            }

            return type.Name;
        }
        /// <summary>
        /// Returns a Javascript Array containing the values in a string enum type
        /// </summary>
        /// <param name="type">EnumType to model as Javascript Array</param>
        /// <returns>The Javascript Array as a string</returns>
        public static string GetEnumValuesArray(this EnumType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            return string.Format(CultureInfo.InvariantCulture,
                "[ {0} ]", string.Join(", ",
                type.Values.Select(p => string.Format(CultureInfo.InvariantCulture, "'{0}'", p.Name))));
        }

        /// <summary>
        /// Determine whether URL encoding should be skipped for this parameter
        /// </summary>
        /// <param name="parameter">The parameter to check</param>
        /// <returns>true if url encoding should be skipped for the parameter, otherwise false</returns>
        public static bool SkipUrlEncoding(this Parameter parameter)
        {
            if (parameter == null)
            {
                return false;
            }

            return parameter.Extensions.ContainsKey(Extensions.SkipUrlEncodingExtension) &&
                   (bool)parameter.Extensions[Extensions.SkipUrlEncodingExtension];
        }

        public static bool ContainsDecimal(this CompositeType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            Property prop = type.Properties.FirstOrDefault(p =>
                p.Type == PrimaryType.Decimal ||
                (p.Type is SequenceType && (p.Type as SequenceType).ElementType == PrimaryType.Decimal) ||
                (p.Type is DictionaryType && (p.Type as DictionaryType).ValueType == PrimaryType.Decimal));

            return prop != null;
        }

        public static string GetExceptionDefineType(this CompositeType type)
        {
            if (type == null)
            {
                return string.Empty;
            }

            if (type.Extensions.ContainsKey(Microsoft.Rest.Generator.Extensions.NameOverrideExtension))
            {
                var ext = type.Extensions[Microsoft.Rest.Generator.Extensions.NameOverrideExtension] as Newtonsoft.Json.Linq.JContainer;
                if (ext != null && ext["name"] != null)
                {
                    return ext["name"].ToString();
                }
            }
            return type.Name + "Exception";
        }

        public static string GetExceptionDefinitionTypeIfExists(this CompositeType type, ServiceClient serviceClient)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            if (serviceClient.ErrorTypes.Contains(type))
            {
                return type.GetExceptionDefineType();
            }
            else
            {
                return null;
            }
        }
    }
}
