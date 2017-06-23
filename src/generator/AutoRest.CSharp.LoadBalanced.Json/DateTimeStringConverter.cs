using System;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AutoRest.CSharp.LoadBalanced.Json
{
    public class DateTimeStringConverter : JsonConverterBase<DateTime, string>
    {
        protected override bool TryParse(DateTime model, out string dto)
        {
            // TODO: custom date format stuff goes here 
            dto = model.ToString();
            return true;
        }

        protected override bool TryParse(string dto, out DateTime model)
        {
            return DateTime.TryParse(dto, out model);
        }
    }
}
