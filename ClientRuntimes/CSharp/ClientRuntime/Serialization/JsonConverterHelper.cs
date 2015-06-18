// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace Microsoft.Rest.Serialization
{
    public static class JsonConverterHelper
    {
        public static void SerializeProperties(JsonWriter writer, object value, JsonSerializer serializer,
            IEnumerable<string> filter = null)
        {
            if (writer == null)
            {
                throw new ArgumentNullException("writer");
            }
            if (value == null)
            {
                throw new ArgumentNullException("value");
            }
            if (serializer == null)
            {
                throw new ArgumentNullException("serializer");
            }

            var contract = (JsonObjectContract)serializer.ContractResolver.ResolveContract(value.GetType());
            foreach (JsonProperty property in contract.Properties
                .Where(p => filter == null || filter.Contains(p.UnderlyingName)))
            {
                object memberValue = property.ValueProvider.GetValue(value);

                // Skipping properties with JsonIgnore attribute, non-readable, and 
                // ShouldSerialize returning false when set
                if (!property.Ignored && property.Readable &&
                    (property.ShouldSerialize == null || property.ShouldSerialize(memberValue)))
                {
                    writer.WritePropertyName(property.PropertyName);
                    serializer.Serialize(writer, memberValue);
                }
            }
        }
    }

#if !NET45
    public static class AttributeExtensions
    {
        public static IEnumerable<T> GetCustomAttributes<T>(this MemberInfo memberInfo) where T : class
        {
            if (memberInfo == null)
            {
                return Enumerable.Empty<T>();
            }
            return memberInfo.GetCustomAttributes(typeof(T), true).Select(a => a as T);
        }

        public static T GetCustomAttribute<T>(this MemberInfo memberInfo) where T : class
        {
            if (memberInfo == null)
            {
                return null;
            }
            return memberInfo.GetCustomAttributes(typeof(T), true).First() as T;
        }
    }
#endif
}