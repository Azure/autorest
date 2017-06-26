using System;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using static System.Decimal;

namespace AutoRest.CSharp.LoadBalanced.Json
{
    public class MoneyConverter : JsonConverter
    {
        private readonly MoneyConverterOptions? _options;

        public MoneyConverter()
        {
        }

        public MoneyConverter(MoneyConverterOptions options)
        {
            _options = options;
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            if (value == null && IsNullable)
            {
                JToken.FromObject(null).WriteTo(writer);
                return;
            }

            object typedValue = null;
            typedValue = SendAsText ? (object) (value?.ToString() ?? "0") : (decimal) (value ?? 0);

            JToken.FromObject(typedValue).WriteTo(writer);
        }

        public sealed override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            JToken token = JToken.Load(reader);
            switch (token.Type)
            {
                case JTokenType.Null:
                    if (IsNullable)
                    {
                        return null;
                    }

                    return SendAsText ? (object) "0" : 0;
                case JTokenType.Float:
                case JTokenType.Integer:
                    return token.ToObject<decimal>();
            }

            return Parse(token.ToString());
        }

        protected bool SendAsText => _options?.HasFlag(MoneyConverterOptions.SendAsText) ?? false;
        protected bool IsNullable => _options?.HasFlag(MoneyConverterOptions.IsNullable) ?? false;

        public sealed override bool CanConvert(Type objectType)
        {
            return objectType == typeof(float?) ||
                objectType == typeof(decimal?) || 
                objectType == typeof(float) || 
                objectType == typeof(decimal) || 
                objectType == typeof(string);
        }
    }
}



