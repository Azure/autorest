using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AutoRest.CSharp.LoadBalanced.Json
{
    public class Int32ValueConverter : JsonConverterBase<Int32, string>
    {
        protected override bool TryParse(Int32 model, out string dto)
        {
            dto = model.ToString();
            return true;
        }

        protected override bool TryParse(string dto, out Int32 model)
        {
            return Int32.TryParse(dto, out model);
        }

        public sealed override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            var token = JToken.Load(reader);
            if (token != null)
            {
                switch (token.Type)
                {
                    case JTokenType.Integer:
                        return token;
                    // false by default
                    default:
                        return 0;
                }
            }
            else
            {
                return 0;
            }
        }
    }
}
