// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Reflection;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Microsoft.Rest
{
    /// <summary>
    /// JsonConverter that handles deserialization for polymorphic objects
    /// based on discriminator field.
    /// </summary>
    /// <typeparam name="T">The base type.</typeparam>
    public class PolymorphicDeserializeJsonConverter<T> : JsonConverter where T : new()
    {
        private readonly string _discriminatorField;

        /// <summary>
        /// Initializes an instance of the PolymorphicDeserializeJsonConverter.
        /// </summary>
        /// <param name="discriminatorField">The JSON field used as a discriminator</param>
        public PolymorphicDeserializeJsonConverter(string discriminatorField)
        {
            this._discriminatorField = discriminatorField;
        }

        /// <summary>
        /// Returns true if the object being deserialized is the base type. False otherwise.
        /// </summary>
        /// <param name="objectType">The type of the object to check.</param>
        /// <returns>True if the object being deserialized is the base type. False otherwise.</returns>
        public override bool CanConvert(Type objectType)
        {
            return typeof(T) == objectType;
        }

        /// <summary>
        /// Reads a JSON field and deserializes into an appropriate object based on discriminator
        /// field and object name. If JsonObject attribute is available, its value is used instead.
        /// </summary>
        /// <param name="reader">The JSON reader.</param>
        /// <param name="objectType">The type of the object.</param>
        /// <param name="existingValue">The existing value.</param>
        /// <param name="serializer">The JSON serializer.</param>
        /// <returns></returns>
        public override object ReadJson(JsonReader reader,
            Type objectType, object existingValue, JsonSerializer serializer)
        {
            JObject item = JObject.Load(reader);
            string typeDiscriminator = (string)item[_discriminatorField];
            foreach (Type type in typeof(T).Assembly.GetTypes()
                .Where(t => t.Namespace == typeof(T).Namespace && t != typeof(T)))
            {
                string typeName = type.Name;
                if (type.GetCustomAttributes<JsonObjectAttribute>().Any())
                {
                    typeName = type.GetCustomAttribute<JsonObjectAttribute>().Id;
                }
                if (typeName.Equals(typeDiscriminator, StringComparison.OrdinalIgnoreCase))
                {
                    return item.ToObject(type, serializer);
                }
            }
            return item.ToObject(objectType);
        }

        /// <summary>
        /// Throws NotSupportedException.
        /// </summary>
        /// <param name="writer">The JSON writer.</param>
        /// <param name="value">The value to serialize.</param>
        /// <param name="serializer">The JSON serializer.</param>
        public override void WriteJson(JsonWriter writer,
            object value, JsonSerializer serializer)
        {
            throw new NotSupportedException();
        }
    }
}