using System;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AutoRest.CSharp.LoadBalanced.Json
{
    public class DateTimeStringConverter : JsonConverter
    {
        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            var date = (DateTime)value;
            // TODO: custom date format stuff goes here 
            JToken.FromObject(date.ToString()).WriteTo(writer);
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            var rawObject = reader.Value?.ToString();
            if (string.IsNullOrWhiteSpace(rawObject))
            {
                return existingValue;
            }

            DateTime dateValue;
            if (DateTime.TryParse(rawObject, out dateValue))
            {
                return dateValue;
            }

            return existingValue;
        }

        public override bool CanConvert(Type objectType)
        {
            return objectType == typeof(DateTime) || objectType == typeof(DateTime?);
        }
    }
}
