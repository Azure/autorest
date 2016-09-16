// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;

namespace AutoRest.Python
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
                primaryType = new PrimaryType(KnownPrimaryType.String)
                {
                    Name = "str"
                };
            }

            if (primaryType != null && primaryType.Type != KnownPrimaryType.String)
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
                case CollectionFormat.Multi:
                    return ",";
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

            if (known != null)
            {
                if (known.Type == KnownPrimaryType.Date)
                {
                    return "date";
                }

                if (known.Type == KnownPrimaryType.DateTimeRfc1123)
                {
                    return "rfc-1123";
                }

                if (known.Type == KnownPrimaryType.DateTime)
                {
                    return "iso-8601";
                }

                if (known.Type == KnownPrimaryType.TimeSpan)
                {
                    return "duration";
                }

                if (known.Type == KnownPrimaryType.UnixTime)
                {
                    return "unix-time";
                }

                if (known.Type == KnownPrimaryType.Base64Url)
                {
                    return "base64";
                }

                if (known.Type == KnownPrimaryType.Decimal)
                {
                    return "decimal";
                }
            }

            var enumType = type as EnumType;
            if (enumType != null && enumType.ModelAsString)
            {
                return "str";
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

            return parameter.Extensions.ContainsKey(SwaggerExtensions.SkipUrlEncodingExtension) &&
                   (bool)parameter.Extensions[SwaggerExtensions.SkipUrlEncodingExtension];
        }

        public static bool ContainsDecimal(this CompositeType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            Property prop = type.Properties.FirstOrDefault(p =>
                p.Type.IsPrimaryType(KnownPrimaryType.Decimal) ||
                (p.Type is SequenceType && (p.Type as SequenceType).ElementType.IsPrimaryType(KnownPrimaryType.Decimal)) ||
                (p.Type is DictionaryType && (p.Type as DictionaryType).ValueType.IsPrimaryType(KnownPrimaryType.Decimal)));

            return prop != null;
        }

        public static string GetExceptionDefineType(this CompositeType type)
        {
            if (type == null)
            {
                return string.Empty;
            }

            if (type.Extensions.ContainsKey(SwaggerExtensions.NameOverrideExtension))
            {
                var ext = type.Extensions[SwaggerExtensions.NameOverrideExtension] as Newtonsoft.Json.Linq.JContainer;
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

        public static string GetPythonSerializationType(IType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            Dictionary<KnownPrimaryType, string> typeNameMapping = new Dictionary<KnownPrimaryType, string>()
                        {
                            { KnownPrimaryType.DateTime, "iso-8601" },
                            { KnownPrimaryType.DateTimeRfc1123, "rfc-1123" },
                            { KnownPrimaryType.TimeSpan, "duration" },
                            { KnownPrimaryType.UnixTime, "unix-time" },
                            { KnownPrimaryType.Base64Url, "base64" },
                            { KnownPrimaryType.Decimal, "decimal" }
                        };
            PrimaryType primaryType = type as PrimaryType;
            if (primaryType != null)
            {
                if (typeNameMapping.ContainsKey(primaryType.Type))
                {
                    return typeNameMapping[primaryType.Type];
                }
                else
                {
                    return type.Name;
                }
            }

            SequenceType sequenceType = type as SequenceType;
            if (sequenceType != null)
            {
                IType innerType = sequenceType.ElementType;
                PrimaryType innerPrimaryType = innerType as PrimaryType;
                string innerTypeName;
                if (innerPrimaryType != null && typeNameMapping.ContainsKey(innerPrimaryType.Type))
                {
                    innerTypeName = typeNameMapping[innerPrimaryType.Type];
                }
                else
                {
                    innerTypeName = innerType.Name;
                }
                return "[" + innerTypeName + "]";
            }

            DictionaryType dictType = type as DictionaryType;
            if (dictType != null)
            {
                IType innerType = dictType.ValueType;
                PrimaryType innerPrimaryType = innerType as PrimaryType;
                string innerTypeName;
                if (innerPrimaryType != null && typeNameMapping.ContainsKey(innerPrimaryType.Type))
                {
                    innerTypeName = typeNameMapping[innerPrimaryType.Type];
                }
                else
                {
                    innerTypeName = innerType.Name;
                }
                return "{" + innerTypeName + "}";
            }

            EnumType enumType = type as EnumType;
            if (enumType != null && enumType.ModelAsString)
            {
                return "str";
            }

            // CompositeType or EnumType
            return type.Name;
        }
    }
}
