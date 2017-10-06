using System;
using Newtonsoft.Json;

namespace AutoRest.CSharp.LoadBalanced.Json
{
    public abstract class JsonConverterDecorator : JsonConverter
    {
        private readonly JsonConverter converter;

        public JsonConverterDecorator(Type jsonConverterType) : this((JsonConverter)Activator.CreateInstance(jsonConverterType)) { }

        public JsonConverterDecorator(JsonConverter converter)
        {
            if (converter == null)
                throw new ArgumentNullException();
            this.converter = converter;
        }

        public override bool CanConvert(Type objectType)
        {
            return converter.CanConvert(objectType);
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            return converter.ReadJson(reader, objectType, existingValue, serializer);
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            converter.WriteJson(writer, value, serializer);
        }

        public override bool CanRead { get { return converter.CanRead; } }

        public override bool CanWrite { get { return converter.CanWrite; } }
    }
}