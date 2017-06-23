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
        internal static string GetTypeName(this JObject jObject) => jObject?["$type"]?.Value<string>();

        public static T ResolveReference<T>(this JsonSerializer serializer, string id) where T : class
        {
            return
                (T)(!string.IsNullOrEmpty(id) ? serializer.ReferenceResolver.ResolveReference(serializer, id) : null);
        }

        public static object Populate<T>(this JsonSerializer serializer, JsonReader reader) where T : class
        {
            var result = New<T>();
            serializer.Populate(reader, result);
            return result;
        }
    }
}