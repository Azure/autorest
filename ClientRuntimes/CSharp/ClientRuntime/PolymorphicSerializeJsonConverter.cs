// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Newtonsoft.Json;

namespace Microsoft.Rest
{
    /// <summary>
    /// JsonConverter that handles serialization for polymorphic objects
    /// based on discriminator field.
    /// </summary>
    /// <typeparam name="T">The base type.</typeparam>
    public class PolymorphicSerializeJsonConverter<T> : JsonConverter where T : new()
    {
        private readonly string _discriminatorField;

        /// <summary>
        /// Initializes an instance of the PolymorphicSerializeJsonConverter.
        /// </summary>
        /// <param name="discriminatorField">The JSON field used as a discriminator</param>
        public PolymorphicSerializeJsonConverter(string discriminatorField)
        {
            this._discriminatorField = discriminatorField;
        }

        /// <summary>
        /// Returns true if the object being serialized is assignable from the base type. False otherwise.
        /// </summary>
        /// <param name="objectType">The type of the object to check.</param>
        /// <returns>True if the object being serialized is assignable from the base type. False otherwise.</returns>
        public override bool CanConvert(Type objectType)
        {
            return typeof(T).IsAssignableFrom(objectType);
        }

        /// <summary>
        /// Throws NotSupportedException.
        /// </summary>
        /// <param name="reader">The JSON reader.</param>
        /// <param name="objectType">The type of the object.</param>
        /// <param name="existingValue">The existing value.</param>
        /// <param name="serializer">The JSON serializer.</param>
        /// <returns></returns>
        public override object ReadJson(JsonReader reader,
            Type objectType, object existingValue, JsonSerializer serializer)
        {
            throw new NotSupportedException();
        }

        /// <summary>
        /// Serializes an object into a JSON string based on discriminator
        /// field and object name. If JsonObject attribute is available, its value is used instead.
        /// </summary>
        /// <param name="writer">The JSON writer.</param>
        /// <param name="value">The value to serialize.</param>
        /// <param name="serializer">The JSON serializer.</param>
        public override void WriteJson(JsonWriter writer,
            object value, JsonSerializer serializer)
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

            string typeName = value.GetType().Name;
            if (value.GetType().GetCustomAttributes<JsonObjectAttribute>().Any())
            {
                typeName = value.GetType().GetCustomAttribute<JsonObjectAttribute>().Id;
            }

            writer.WriteStartObject();
            writer.WritePropertyName(_discriminatorField);
            writer.WriteValue(typeName);

            PropertyInfo[] properties = value.GetType().GetProperties();
            foreach (var property in properties)
            {
                string propertyName = property.Name;
                if (property.GetCustomAttributes<JsonPropertyAttribute>().Any())
                {
                    propertyName = property.GetCustomAttribute<JsonPropertyAttribute>().PropertyName;
                }
                writer.WritePropertyName(propertyName);
                serializer.Serialize(writer, property.GetValue(value, null));
            }
            writer.WriteEndObject();
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