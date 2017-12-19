using System;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Globalization;

namespace AutoRest.CSharp.LoadBalanced.Json
{
    public class DateTimeStringConverter : JsonConverterBase<DateTime, string>
    {
        private const string DefaultDateTimeFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.FFFFFFFzzz";

        protected override bool TryParse(DateTime model, out string dto)
        {
            dto = model.ToString(DefaultDateTimeFormat, CultureInfo.CurrentCulture);
            return true;
        }

        protected override bool TryParse(string dto, out DateTime model)
        {
            return DateTime.TryParse(dto, out model);
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            string text;

            if (value == null)
            {
                JToken.FromObject(null).WriteTo(writer);
                return;
            }
            else if (value is DateTime)
            {
                DateTime dateTime = (DateTime)value;
                text = dateTime.ToString(DefaultDateTimeFormat, CultureInfo.CurrentCulture);
            }
            else
            {
                throw new JsonSerializationException("Unexpected value when converting date. Expected DateTime.");
            }

            JToken.FromObject(text).WriteTo(writer);
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            JToken token = JToken.Load(reader);

            if (token != null)
            {
                switch (token.Type)
                {
                    case JTokenType.Date:
                        return token.ToObject<DateTime>();
                    case JTokenType.String:
                        return TryParseDefault(token.ToString());
                    default:
                        return new DateTime();
                }
            }
            else
            {
                return new DateTime();
            }
        }

        private DateTime TryParseDefault(string dateTimeValue)
        {
            var defaultDateTime = new DateTime();

            if (DateTime.TryParseExact(dateTimeValue, "dd/MM/yyyy h:mm:ss tt", CultureInfo.InvariantCulture, DateTimeStyles.None, out defaultDateTime))
            {
                return defaultDateTime;
            }

            if (DateTime.TryParseExact(dateTimeValue, "M/d/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out defaultDateTime))
            {
                return defaultDateTime;
            }
            
            if (DateTime.TryParseExact(dateTimeValue, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out defaultDateTime))
            {
                return defaultDateTime;
            }

            return defaultDateTime;
        }
    }
}
