using System;
using System.Collections.Generic;
using System.Diagnostics;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AutoRest.CSharp.LoadBalanced.Json
{
    [Flags]
    public enum BooleanConverterOptions
    {
        Default = 0,
        WriteAsInt = 1
    }

    public class BooleanStringConverter : JsonConverterBase<bool, string>
    {
        private readonly BooleanConverterOptions? _options;

        public BooleanStringConverter()
        {
            _options = BooleanConverterOptions.Default;
        }

        public BooleanStringConverter(BooleanConverterOptions options)
        {
            _options = options;
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            if (_options == BooleanConverterOptions.WriteAsInt)
            {
                Debug.WriteLine("BooleanStringConverter WriteJson Int");
                var typedValue = StringToBoolAsInt(value.ToString());
                JToken.FromObject(typedValue).WriteTo(writer);
            }
            else
            {
                Debug.WriteLine("BooleanStringConverter WriteJson Bool");
                var typedValue = StringToBool(value.ToString());
                JToken.FromObject(typedValue).WriteTo(writer);
            }
        }

        protected override bool TryParse(bool model, out string dto)
        {
            dto = model.ToString();
            return true;
        }

        protected override bool TryParse(string dto, out bool model)
        {
            return bool.TryParse(dto, out model);
        }

        public sealed override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            var token = JToken.Load(reader);
            if (token != null)
            {
                switch (token.Type)
                {
                    case JTokenType.String:
                        return StringToBool(token.ToString());
                    case JTokenType.Integer:
                        return StringToBool(token.ToString());
                    case JTokenType.Boolean:
                        return StringToBool(token.ToString());
                    default:
                        return false;
                }
            }

            return false;
        }

        private int StringToBoolAsInt(string value)
        {
            var whitelist = new List<string> {"1", "true", "True"};
            return whitelist.Contains(value) ? 1 : 0;
        }

        private bool StringToBool(string value)
        {
            var whitelist = new List<string> { "1", "true", "True" };
            return whitelist.Contains(value);
        }
    }
}
