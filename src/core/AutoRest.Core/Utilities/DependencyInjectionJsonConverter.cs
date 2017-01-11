// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using AutoRest.Core.Model;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AutoRest.Core.Utilities
{
    public abstract class DeserializingJsonConverter<T> : JsonConverter where T : class
    {
        public override bool CanWrite => false;
        public override bool CanRead => true;

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            throw new NotImplementedException();
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue,
           JsonSerializer serializer)
        {
            if (reader.TokenType == JsonToken.Null)
            {
                return null;
            }
            
            var jObject = JObject.Load(reader);

            if (jObject == null)
            {
                return null;
            }
            var reference = jObject["$ref"]?.Value<string>();
            if (reference != null)
            {
                return serializer.ResolveReference<T>(reference);
            }
            var id = jObject["$id"]?.Value<string>();
            if (id != null)
            {
                var result = ReadJson(jObject, objectType, existingValue, serializer);
                // serializer.ReferenceResolver.AddReference(serializer,id,result);
                return result;
            }
            return ReadJson(jObject, objectType, existingValue, serializer);
        }

        protected abstract object ReadJson(JObject jObject, Type objectType, object existingValue,
            JsonSerializer serializer);

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

    /// <summary>
    ///     This should be used as a deserialization creator for any types that are handled via LODIS.
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class DependencyInjectionJsonConverter<T> : DeserializingJsonConverter<T> where T : class
    {
        protected override object ReadJson(JObject jObject, Type objectType, object existingValue,
            JsonSerializer serializer)
        {
            // create and populate the object using LODIS based on the type T
            return serializer.Populate<T>(jObject.CreateReader());
        }
    }

    public class TypedObjectConverter<T> : DeserializingJsonConverter<T> where T : class
    {
        protected override object ReadJson(JObject jObject, Type objectType, object existingValue, JsonSerializer serializer)
        {
            // if there is a $type, we need to ask the serializer to try deserializing to that specific type.
            var typeDeclaration = jObject.GetTypeDeclaration();
            
            if (typeDeclaration != null)
            {
                return serializer.Deserialize(jObject.CreateReader(), typeDeclaration.Type);
            }

            // if there isn't a specified type *try* to use a LODIS factory for the type.
            // (this doesn't seem as likely to succeed)
            return serializer.Populate<T>(jObject.CreateReader());
        }
    }
}