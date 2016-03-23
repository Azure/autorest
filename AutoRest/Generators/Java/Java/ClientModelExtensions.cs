// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using System.Text;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java.TemplateModels
{
    public static class ClientModelExtensions
    {
        public const string ExternalExtension = "x-ms-external";

        public static bool NeedsSpecialSerialization(this IType type)
        {
            var known = type as PrimaryType;
            return (known != null && (known.Name == "LocalDate" || known.Name == "DateTime" || known.Type == KnownPrimaryType.ByteArray)) ||
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
                if (known.Type == KnownPrimaryType.ByteArray)
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
            if (property.IsReadOnly)
            {
                settings.Add("access = JsonProperty.Access.WRITE_ONLY");
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

        public static IType ParameterType(this IType type)
        {
            PrimaryType primaryType = type as PrimaryType;
            if (primaryType.IsPrimaryType(KnownPrimaryType.Stream))
            {
                return JavaCodeNamer.NormalizePrimaryType(new PrimaryType(KnownPrimaryType.ByteArray));
            }
            else
            {
                return type.UserHandledType();
            }
        }

        public static IType UserHandledType(this IType type)
        {
            PrimaryType primaryType = type as PrimaryType;
            if (primaryType.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
            {
                return new PrimaryType(KnownPrimaryType.DateTime);
            }
            else
            {
                return type;
            }
        }

        public static List<string> ImportFrom(this IType type, string ns, JavaCodeNamer namer)
        {
            if (namer == null)
            {
                return null;
            }
            return namer.ImportType(type, ns);
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
            if (type.IsPrimaryType(KnownPrimaryType.Stream))
            {
                imports.Add("okhttp3.RequestBody");
                imports.Add("okhttp3.MediaType");
            }
            if (parameter.Location != ParameterLocation.Body
                && parameter.Location != ParameterLocation.None)
            {
                if (type.IsPrimaryType(KnownPrimaryType.ByteArray) ||
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
            string package = "retrofit2.http.";
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
            if (parameterLocation == ParameterLocation.FormData)
            {
                return "retrofit2.http.Part";
            }
            else if (parameterLocation != ParameterLocation.None)
            {
                return "retrofit2.http." + parameterLocation.ToString();
            }
            else
            {
                return null;
            }
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
