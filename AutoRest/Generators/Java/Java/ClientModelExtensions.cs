// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using Microsoft.Rest.Generator.ClientModel;

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
        /// <returns></returns>
        public static string ToString(this Parameter parameter, string reference)
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
                return "JacksonHelper.serializeList(" + reference + 
                    ", CollectionFormat." + parameter.CollectionFormat.ToString().ToUpper(CultureInfo.InvariantCulture) + ")";
            }
            else
            {
                return "JacksonHelper.serializeRaw(" + reference + ")";
            }
        }

        public static String GetJsonProperty(this Property property)
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
            else if ((compositeType != null || type is EnumType) && ns != null)
            {
                if (compositeType != null &&
                    compositeType.Extensions.ContainsKey(ExternalExtension) &&
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
            if (type == PrimaryType.ByteArray ||
                type.Name == "ByteArray")
            {
                imports.Add("org.apache.commons.codec.binary.Base64");
            }

            SequenceType sequenceType = type as SequenceType;
            if (parameter.Location != ParameterLocation.Body)
            {
                if (type.Name == "LocalDate" ||
                    type.Name == "DateTime" ||
                    type is CompositeType ||
                    sequenceType != null ||
                    type is DictionaryType)
                {
                    imports.Add("com.microsoft.rest.serializer.JacksonHelper");
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
    }
}
