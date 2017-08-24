using System.Collections.Generic;
using AutoRest.Php.JsonBuilder;

namespace AutoRest.Php.SwaggerBuilder
{
    public sealed class ResponseObject : Object
    {
        public SchemaObject Schema { get; }

        public static ResponseObject Create(Core.Model.Response response)
            => new ResponseObject(SchemaObject.Create(response.Body));

        public ResponseObject(SchemaObject schema)
        {
            Schema = schema;
        }

        public override IEnumerable<Property> GetProperties()
        {
            if (Schema != null)
            {
                yield return Json.Property("schema", Schema);
            }
        }
    }
}
