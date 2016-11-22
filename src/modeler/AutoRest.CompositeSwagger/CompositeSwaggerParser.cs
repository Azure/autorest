using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.CompositeSwagger.Model;
using AutoRest.CompositeSwagger.Properties;
using AutoRest.Core;
using AutoRest.Core.Logging;
using Newtonsoft.Json;

namespace AutoRest.CompositeSwagger
{
    public class CompositeSwaggerParser : Transformer<string, CompositeServiceDefinition>
    {
        public override Task<CompositeServiceDefinition> Transform(string json)
        {
            try
            {
                var settings = new JsonSerializerSettings
                {
                    TypeNameHandling = TypeNameHandling.None,
                    MetadataPropertyHandling = MetadataPropertyHandling.Ignore
                };
                return Task.FromResult(JsonConvert.DeserializeObject<CompositeServiceDefinition>(json, settings));
            }
            catch (JsonException ex)
            {
                throw ErrorManager.CreateError(string.Format(CultureInfo.InvariantCulture, "{0}. {1}",
                    Resources.ErrorParsingSpec, ex.Message), ex);
            }
        }
    }
}
