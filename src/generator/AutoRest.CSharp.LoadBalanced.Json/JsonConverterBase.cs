using System;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AutoRest.CSharp.LoadBalanced.Json
{
    public abstract class JsonConverterBase<TModel, TDto> : JsonConverter where TModel : struct 
    {
        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            var typedValue = (TModel)value;
            TDto dto;
            if (!TryParse(typedValue, out dto))
            {
                dto = default(TDto);
            }

            JToken.FromObject(dto).WriteTo(writer);
        }

        protected abstract bool TryParse(TModel model, out TDto dto);
        protected abstract bool TryParse(TDto dto, out TModel model);

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            TDto dto = reader.Value == null ? default(TDto) : (TDto) reader.Value;
            TModel model;
            return !TryParse(dto, out model) ? existingValue : model;
        }
       
        public override bool CanConvert(Type objectType)
        {
            return objectType == typeof(TModel) || objectType == typeof(TModel?);
        }
    }
}
