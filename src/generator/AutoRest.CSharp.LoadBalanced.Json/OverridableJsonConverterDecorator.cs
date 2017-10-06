using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using Newtonsoft.Json;

namespace AutoRest.CSharp.LoadBalanced.Json
{
    public class OverridableJsonConverterDecorator : JsonConverterDecorator
    {
        public OverridableJsonConverterDecorator(Type jsonConverterType) : base(jsonConverterType) { }

        public OverridableJsonConverterDecorator(JsonConverter converter) : base(converter) { }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            foreach (var converter in serializer.Converters)
            {
                if (converter == this)
                {
                    Debug.WriteLine("Skipping identical " + converter.ToString());
                    continue;
                }
                if (converter.CanConvert(value.GetType()) && converter.CanWrite)
                {
                    converter.WriteJson(writer, value, serializer);
                    return;
                }
            }
            base.WriteJson(writer, value, serializer);
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            foreach (var converter in serializer.Converters)
            {
                if (converter == this)
                {
                    Debug.WriteLine("Skipping identical " + converter.ToString());
                    continue;
                }
                if (converter.CanConvert(objectType) && converter.CanRead)
                {
                    return converter.ReadJson(reader, objectType, existingValue, serializer);
                }
            }
            return base.ReadJson(reader, objectType, existingValue, serializer);
        }
    }
}