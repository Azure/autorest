using System.Collections.Generic;
using AutoRest.Php.JsonBuilder;

namespace AutoRest.Php.SwaggerBuilder
{
    public sealed class Response : Object
    {
        public Schema Schema { get; }

        public static Response Create(Core.Model.Response response)
            => new Response(Schema.Create(response.Body));

        public Response(Schema schema)
        {
            Schema = schema;
        }

        public override IEnumerable<KeyValuePair<string, Token>> GetProperties()
        {
            if (Schema != null)
            {
                yield return Json.Property("schema", Schema);
            }
        }
    }
}
