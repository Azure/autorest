// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using AutoRest.Core.Utilities.Collections;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Serialization;

namespace AutoRest.Core.Utilities
{
    public class DeserializeToExistingValueProvider : IValueProvider
    {
        private readonly IValueProvider _valueProvider;

        public DeserializeToExistingValueProvider(IValueProvider vp)
        {
            _valueProvider = vp;
        }

        public void SetValue(object target, object value)
        {
            // do nothing, since these values should always
            // get deserialized directly into the existing target object.
        }

        public object GetValue(object target) => _valueProvider.GetValue(target);
    }

    public class GeneratedCollectionConverter<T> : JsonConverter where T : class
    {
        public GeneratedCollectionConverter()
        {
            
        }

        /// <summary>Writes the JSON representation of the object.</summary>
        /// <param name="writer">The <see cref="T:Newtonsoft.Json.JsonWriter" /> to write to.</param>
        /// <param name="value">The value.</param>
        /// <param name="serializer">The calling serializer.</param>
        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            writer.WriteStartArray();
            foreach (var i in value as IEnumerable<T> ?? Enumerable.Empty<T>())
            {
                serializer.Serialize(writer, i);
            }
            writer.WriteEndArray();
        }

        /// <summary>Reads the JSON representation of the object.</summary>
        /// <param name="reader">The <see cref="T:Newtonsoft.Json.JsonReader" /> to read from.</param>
        /// <param name="objectType">Type of the object.</param>
        /// <param name="existingValue">The existing value of object being read.</param>
        /// <param name="serializer">The calling serializer.</param>
        /// <returns>The object value.</returns>
        public override object ReadJson(JsonReader reader, Type objectType, object existingValue,
            JsonSerializer serializer)
        {
            var o = existingValue as ICopyFrom<IEnumerable<T>>;
            if (o != null)
            {
                o.CopyFrom(JArray.Load(reader)
                        .Select(
                            each =>
                                each["$ref"] != null
                                    ? serializer.ResolveReference<T>(each["$ref"].Value<string>())
                                    : each.ToObject<T>(serializer)));
            }
            else
            {
                throw new Exception("Invalid state of deserialization. Can not continue.");
            }
            return existingValue;
        }

        /// <summary>
        ///     Determines whether this instance can convert the specified object type.
        /// </summary>
        /// <param name="objectType">Type of the object.</param>
        /// <returns>
        ///     <c>true</c> if this instance can convert the specified object type; otherwise, <c>false</c>.
        /// </returns>
        public override bool CanConvert(Type objectType)
        {
            return typeof(T).IsAssignableFrom(objectType);
        }
    }
}