using System;
using System.Diagnostics;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AutoRest.CSharp.LoadBalanced.Json
{
    public class MoneyConverter : JsonConverterBase<decimal, string>
    {
        private readonly MoneyConverterOptions? _options;

        public MoneyConverter()
        {
        }

        public MoneyConverter(MoneyConverterOptions options)
        {
            _options = options;
        }

        protected override bool TryParse(decimal model, out string dto)
        {
            dto = model.ToString();
            return true;
        }

        protected override bool TryParse(string dto, out decimal model)
        {
            return Decimal.TryParse(dto, out model);
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            if (value == null && IsNullable)
            {
                JToken.FromObject(null).WriteTo(writer);
                return;
            }

            object typedValue = null;
            typedValue = SendAsText ? (object)(value?.ToString() ?? "0") : (decimal)(value ?? 0);
            JToken.FromObject(typedValue).WriteTo(writer);
        }

        public sealed override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            JToken token = JToken.Load(reader);
            if (token != null)
            {
                switch (token.Type)
                {
                    case JTokenType.String:
                        if (IsNullable && string.IsNullOrEmpty(token.ToString()))
                        {
                            return null;
                        }
                        else
                        {
                            var value = TryParse(token.ToString());
                            return SendAsText ? (object)value.ToString() : value;
                        }
                    case JTokenType.Null:
                        if (IsNullable)
                        {
                            return null;
                        }
                        return SendAsText ? (object)"0" : 0;
                    case JTokenType.Float:
                    case JTokenType.Integer:
                        if (SendAsText)
                        {
                            return token.ToString();
                        }
                        else
                        {
                            return token.ToObject<decimal>();
                        }
                    default:
                        return SendAsText ? (object)"0" : 0;
                }
            }
            else
            {
                return SendAsText ? (object)"0" : 0;
            }
        }

        protected bool SendAsText => _options?.HasFlag(MoneyConverterOptions.SendAsText) ?? false;
        protected bool IsNullable => _options?.HasFlag(MoneyConverterOptions.IsNullable) ?? false;

        public decimal TryParse(string value)
        {
            decimal parsedValue;
            decimal.TryParse(value, out parsedValue);
            return parsedValue;
        }

        public sealed override bool CanConvert(Type objectType)
        {
            return objectType == typeof(decimal?) ||
                   objectType == typeof(decimal);
        }
    }
}


