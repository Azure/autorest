using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AutoRest.CSharp.LoadBalanced.Json
{
    public class WrappedListConverter<T> : JsonConverter
    {
        private readonly string _collectionPropertyName;

        public WrappedListConverter(string collectionPropertyName)
        {
            _collectionPropertyName = collectionPropertyName;
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            writer.WriteStartObject();
            writer.WritePropertyName(_collectionPropertyName);
            writer.WriteStartArray();

            var items = value as IEnumerable<T> ?? new T[0];

            foreach (var item in items)
            {
                JToken.FromObject(item).WriteTo(writer);
            }

            writer.WriteEndArray();
            writer.WriteEndObject();
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            var list = new List<T>();

            if (reader.Read() && reader.TokenType == JsonToken.PropertyName)
            {
                var propertyName = (string) reader.Value;

                if (propertyName == _collectionPropertyName)
                {
                    if (reader.Read() && reader.TokenType == JsonToken.StartArray)
                    {
                        while (reader.Read() && reader.TokenType != JsonToken.EndArray)
                        {
                            var item = serializer.Deserialize<T>(reader);
                            list.Add(item);
                        }
                    }
                }
            }

            reader.Read(); // read the end object 

            return list;
        }

        public override bool CanConvert(Type objectType)
        {
            return objectType == typeof(IList<T>);
        }
    }
}
