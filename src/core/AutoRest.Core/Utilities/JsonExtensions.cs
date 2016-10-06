// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core.Utilities
{
    public static class JsonExtensions
    {
        internal class TypeNameKey
        {
            internal string AssemblyName { get; set; }
            internal string TypeName { get; set; }
            internal Type Type => AssemblyName != null ? Assembly.Load(new AssemblyName(AssemblyName)).GetType(TypeName) : Type.GetType(TypeName);
        }

        internal static TypeNameKey GetTypeDeclaration(this JObject jObject)
        {
            string fullyQualifiedTypeName = jObject?["$type"]?.Value<string>();
            if (string.IsNullOrEmpty(fullyQualifiedTypeName))
            {
                return null;
            }

            int? assemblyDelimiterIndex = GetAssemblyDelimiterIndex(fullyQualifiedTypeName);

            if (assemblyDelimiterIndex != null)
            {
                return new TypeNameKey
                {
                    TypeName = fullyQualifiedTypeName.Substring(0, assemblyDelimiterIndex.GetValueOrDefault()).Trim(),
                    AssemblyName = fullyQualifiedTypeName.Substring(assemblyDelimiterIndex.GetValueOrDefault() + 1, fullyQualifiedTypeName.Length - assemblyDelimiterIndex.GetValueOrDefault() - 1).Trim()
                };
            }

            return new TypeNameKey
            {
                TypeName = fullyQualifiedTypeName,
                AssemblyName = null
            };
        }

        private static int? GetAssemblyDelimiterIndex(string fullyQualifiedTypeName)
        {
            // we need to get the first comma following all surrounded in brackets because of generic types
            // e.g. System.Collections.Generic.Dictionary`2[[System.String, mscorlib,Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089],[System.String, mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089]], mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089
            int scope = 0;
            for (int i = 0; i < fullyQualifiedTypeName.Length; i++)
            {
                char current = fullyQualifiedTypeName[i];
                switch (current)
                {
                    case '[':
                        scope++;
                        break;
                    case ']':
                        scope--;
                        break;
                    case ',':
                        if (scope == 0)
                        {
                            return i;
                        }
                        break;
                }
            }

            return null;
        }

        public static string SortJson(this string jsonText)
        {
            var dom = (JObject) JsonConvert.DeserializeObject(jsonText);
            dom.Sort();
            return dom.ToString(Formatting.Indented);
        }

        public static T ResolveReference<T>(this JsonSerializer serializer, string id) where T : class
        {
            return
                (T) (!string.IsNullOrEmpty(id) ? serializer.ReferenceResolver.ResolveReference(serializer, id) : null);
        }

        public static object Populate<T>(this JsonSerializer serializer, JsonReader reader) where T : class
        {
            var result = New<T>();
            serializer.Populate(reader, result);
            return result;
        }

        public static void Sort(this JObject jObj)
        {
            var props = jObj.Properties().ToList();
            foreach (var prop in props)
            {
                prop.Remove();
            }

            foreach (var prop in props.OrderBy(p => p.Name))
            {
                jObj.Add(prop);
                if (prop.Value is JObject)
                {
                    Sort((JObject) prop.Value);
                }
                if (prop.Value is JArray)
                {
                    var a = prop.Value as JArray;
                    foreach (var i in a)
                    {
                        if (i is JObject)
                        {
                            Sort((JObject) i);
                        }
                    }
                }
            }
        }
    }
}