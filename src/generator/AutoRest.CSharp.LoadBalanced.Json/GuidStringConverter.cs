using System;

namespace AutoRest.CSharp.LoadBalanced.Json
{
    public class GuidStringConverter : JsonConverterBase<Guid, string>
    {
        protected override bool TryParse(Guid model, out string dto)
        {
            dto = model.ToString();
            return true;
        }

        protected override bool TryParse(string dto, out Guid model)
        {
            return Guid.TryParse(dto, out model);
        }
    }

}