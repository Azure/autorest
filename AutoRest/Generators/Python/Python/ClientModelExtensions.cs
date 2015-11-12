// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using System.Text.RegularExpressions;
using System.Collections.Generic;
namespace Microsoft.Rest.Generator.Python.TemplateModels
{
    public static class ClientModelExtensions
    {
        /// <summary>
        /// The set contain the primary types which require datetime module
        /// </summary>
        public static HashSet<PrimaryType> PythonDatetimeModuleType = new HashSet<PrimaryType>() { PrimaryType.Date, PrimaryType.DateTime, PrimaryType.DateTimeRfc1123, PrimaryType.TimeSpan };

        /// <summary>
        /// Format the value of a sequence given the modeled element format.  Note that only sequences of strings are supported
        /// </summary>
        /// <param name="parameter">The parameter to format</param>
        /// <returns>A reference to the formatted parameter value</returns>
        public static string GetFormattedReferenceValue(this Parameter parameter)
        {
            if (parameter == null)
            {
                throw new ArgumentNullException("parameter");
            }

            SequenceType sequence = parameter.Type as SequenceType;
            if (sequence == null)
            {
                return parameter.Type.ToString(parameter.Name);
            }

            PrimaryType primaryType = sequence.ElementType as PrimaryType;
            EnumType enumType = sequence.ElementType as EnumType;
            if (enumType != null && enumType.ModelAsString)
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

            return string.Format(CultureInfo.InvariantCulture,
                "{0}.join('{1}')", parameter.Name, parameter.CollectionFormat.GetSeparator());
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

        private static string NormalizeValueReference(this string valueReference)
        {
            Regex pattern = new Regex("['.\\[\\]]");
            return pattern.Replace(valueReference, "");
        }

        private static string GetBasePropertyFromUnflattenedProperty(this string property)
        {
            string result = null;
            if (property.Contains("]["))
            {
                result = property.Substring(0, property.IndexOf("][", StringComparison.OrdinalIgnoreCase) + 1);
            }
            
            return result;
        }

        /// <summary>
        /// Simple conversion of the type to string
        /// </summary>
        /// <param name="type">The type to convert</param>
        /// <param name="reference">a reference to an instance of the type</param>
        /// <returns></returns>
        public static string ToString(this IType type, string reference)
        {
            var known = type as PrimaryType;

            if (known == PrimaryType.Date)
            {
                return string.Format(CultureInfo.InvariantCulture,
                    "Serialized.serializeObject({0}, \'date\')", reference);
            }

            if (known == PrimaryType.DateTimeRfc1123)
            {
                return string.Format(CultureInfo.InvariantCulture,
                    "Serialized.serializeObject({0}, \'rfc-date\')", reference);
            }

            if (known == PrimaryType.DateTime)
            {
                return string.Format(CultureInfo.InvariantCulture,
                    "Serialized.serializeObject({0}, \'iso-date\')", reference);
            }

            if (known == PrimaryType.TimeSpan)
            {
                return string.Format(CultureInfo.InvariantCulture,
                    "Serialized.serializeObject({0}, \'duration\')", reference);
            }

            return reference;
        }

        /// <summary>
        /// Simple conversion of the type to string
        /// </summary>
        /// <param name="type">The type to convert</param>
        /// <returns></returns>
        public static string ToPythonRuntimeTypeString(this IType type)
        {
            var known = type as PrimaryType;

            if (known == PrimaryType.Date)
            {
                return "date";
            }

            if (known == PrimaryType.DateTimeRfc1123)
            {
                return "rfc-date";
            }

            if (known == PrimaryType.DateTime)
            {
                return "iso-date"; 
            }

            if (known == PrimaryType.TimeSpan)
            {
                return "duration";
            }

            if (type is SequenceType)
            {
                var sequenceType = type as SequenceType;
                return "[" + sequenceType.ElementType.ToPythonRuntimeTypeString() + "]";
            }

            if (type is DictionaryType)
            {
                var dictionaryType = type as DictionaryType;
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

        public static string NullInitializeType(this IType type, IScopeProvider scope, string objectReference, string modelReference = "models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;
            string nullValue = "None";
            if (sequence != null)
            {
                nullValue = "[]";
            }
            else if (dictionary != null)
            {
                nullValue = "{}";
            }

            return string.Format(CultureInfo.InvariantCulture, "{0} = {1}", objectReference, nullValue);
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

        public static bool ContainsDatetime(this CompositeType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            Property prop = type.Properties.FirstOrDefault(p =>
                PythonDatetimeModuleType.Contains(p.Type) ||
                (p.Type is SequenceType && PythonDatetimeModuleType.Contains((p.Type as SequenceType).ElementType)) ||
                (p.Type is DictionaryType && PythonDatetimeModuleType.Contains((p.Type as DictionaryType).ValueType)));

            return prop != null;
        }
    }
}
