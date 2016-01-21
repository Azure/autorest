// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using System.Text;

namespace Microsoft.Rest.Generator.Java.TemplateModels
{
    public static class ClientModelExtensions
    {
        public const string ExternalExtension = "x-ms-external";

        public static bool NeedsSpecialSerialization(this IType type)
        {
            var known = type as PrimaryType;
            return (known != null && (known.Name == "LocalDate" || known.Name == "DateTime" || known == PrimaryType.ByteArray)) ||
                type is EnumType || type is CompositeType || type is SequenceType || type is DictionaryType;
        }

        /// <summary>
        /// Simple conversion of the type to string
        /// </summary>
        /// <param name="parameter">The parameter to convert</param>
        /// <param name="reference">a reference to an instance of the type</param>
        /// <param name="clientReference">a reference to the service client</param>
        /// <returns></returns>
        public static string ToString(this Parameter parameter, string reference, string clientReference)
        {
            if (parameter == null)
            {
                return null;
            }
            var type = parameter.Type;
            var known = type as PrimaryType;
            var sequence = type as SequenceType;
            if (known != null && known.Name != "LocalDate" && known.Name != "DateTime")
            {
                if (known == PrimaryType.ByteArray)
                {
                    return "Base64.encodeBase64String(" + reference + ")";
                }
                else
                {
                    return reference;
                }
            }
            else if (sequence != null)
            {
                return clientReference + ".getMapperAdapter().serializeList(" + reference +
                    ", CollectionFormat." + parameter.CollectionFormat.ToString().ToUpper(CultureInfo.InvariantCulture) + ")";
            }
            else
            {
                return clientReference + ".getMapperAdapter().serializeRaw(" + reference + ")";
            }
        }

        public static string Period(this string documentation)
        {
            if (string.IsNullOrEmpty(documentation))
            {
                return documentation;
            }
            documentation = documentation.Trim();
            if (!documentation.EndsWith(".", StringComparison.Ordinal))
            {
                documentation += ".";
            }
            return documentation;
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

        public static string GetJsonProperty(this Property property)
        {
            if (property == null)
            {
                return null;
            }

            List<string> settings = new List<string>();
            if (property.Name != property.SerializedName)
            {
                settings.Add(string.Format(CultureInfo.InvariantCulture, "value = \"{0}\"", property.SerializedName));
            }
            if (property.IsRequired)
            {
                settings.Add("required = true");
            }
            return string.Join(", ", settings);
        }

        public static void AddRange<T>(this HashSet<T> hashSet, IEnumerable<T> range)
        {
            if( hashSet == null || range == null)
            {
                return;
            }

            foreach(var item in range)
            {
                hashSet.Add(item);
            }
        }

        public static List<string> ImportFrom(this IType type, string ns)
        {
            List<string> imports = new List<string>();
            var sequenceType = type as SequenceType;
            var dictionaryType = type as DictionaryType;
            var primaryType = type as PrimaryType;
            var compositeType = type as CompositeType;
            if (sequenceType != null)
            {
                imports.Add("java.util.List");
                imports.AddRange(sequenceType.ElementType.ImportFrom(ns));
            }
            else if (dictionaryType != null)
            {
                imports.Add("java.util.Map");
                imports.AddRange(dictionaryType.ValueType.ImportFrom(ns));
            }
            else if (compositeType != null && ns != null)
            {
                if (type.Name.Contains('<'))
                {
                    imports.AddRange(compositeType.ParseGenericType().SelectMany(t => t.ImportFrom(ns)));
                }
                else if (compositeType.Extensions.ContainsKey(ExternalExtension) &&
                    (bool)compositeType.Extensions[ExternalExtension])
                {
                    imports.Add(string.Join(
                        ".",
                        "com.microsoft.rest",
                        type.Name));
                }
                else
                {
                    imports.Add(string.Join(
                        ".",
                        ns.ToLower(CultureInfo.InvariantCulture),
                        "models",
                        type.Name));
                }
            }
            else if (type is EnumType && ns != null)
            {
                imports.Add(string.Join(
                    ".",
                    ns.ToLower(CultureInfo.InvariantCulture),
                    "models",
                    type.Name));
            }
            else if (primaryType != null)
            {
                var importedFrom = JavaCodeNamer.GetJavaType(primaryType);
                if (importedFrom != null)
                {
                    imports.Add(importedFrom);
                }
            }
            return imports;
        }

        public static List<string> ImportFrom(this Parameter parameter)
        {
            List<string> imports = new List<string>();
            if (parameter == null)
            {
                return imports;
            }
            var type = parameter.Type;

            SequenceType sequenceType = type as SequenceType;
            if (parameter.Location != ParameterLocation.Body
                && parameter.Location != ParameterLocation.None)
            {
                if (type == PrimaryType.ByteArray ||
                    type.Name == "ByteArray")
                {
                    imports.Add("org.apache.commons.codec.binary.Base64");
                }
                if (sequenceType != null)
                {
                    imports.Add("com.microsoft.rest.serializer.CollectionFormat");
                }
            }

            return imports;
        }

        public static string ImportFrom(this HttpMethod httpMethod)
        {
            string package = "retrofit.http.";
            if (httpMethod == HttpMethod.Delete)
            {
                return package + "HTTP";
            }
            else
            {
                return package + httpMethod.ToString().ToUpper(CultureInfo.InvariantCulture);
            }
        }

        public static string ImportFrom(this ParameterLocation parameterLocation)
        {
            if (parameterLocation != ParameterLocation.None &&
                parameterLocation != ParameterLocation.FormData)
                return "retrofit.http." + parameterLocation.ToString();
            else
                return null;
        }

        public static IEnumerable<IType> ParseGenericType(this CompositeType type)
        {
            string name = type.Name;
            string[] types = type.Name.Split(new String[]{"<", ">", ",", ", "}, StringSplitOptions.RemoveEmptyEntries);
            foreach (var innerType in types.Where(t => !string.IsNullOrWhiteSpace(t))) {
                if (!JavaCodeNamer.PrimaryTypes.Contains(innerType.Trim())) {
                    yield return new CompositeType() { Name = innerType.Trim() };
                }
            }
        }
    }
}
