// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Microsoft.Rest.Generator.Java.TemplateModels
{
    public static class ClientModelExtensions
    {
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

        public static HashSet<string> TypeImports(this IList<IType> types, String ns)
        {
            HashSet<string> imports = new HashSet<string>();
            if (types == null || ns == null)
            {
                return imports;
            }

            for (int i = 0; i < types.Count; i++)
            {
                var type = types[i];
                var sequenceType = type as SequenceType;
                var dictionaryType = type as DictionaryType;
                var primaryType = type as PrimaryType;
                if (sequenceType != null)
                {
                    imports.Add("java.util.List");
                    types.Add(sequenceType.ElementType);
                }
                else if (dictionaryType != null)
                {
                    imports.Add("java.util.Map");
                    types.Add(dictionaryType.ValueType);
                }
                else if (type is CompositeType || type is EnumType)
                {
                    imports.Add(string.Join(
                        ".",
                        ns.ToLower(CultureInfo.InvariantCulture),
                        "models",
                        type.Name));
                }
                else if (primaryType != null)
                {
                    var importedFrom = JavaCodeNamer.ImportedFrom(primaryType);
                    if (importedFrom != null)
                    {
                        imports.Add(importedFrom);
                    }
                }
            }
            return imports;
        }
    }
}
