using System.Collections.Generic;
using AutoRest.Php.JsonBuilder;

namespace AutoRest.Php.SwaggerBuilder
{
    public sealed class PropertyObject : Object
    {
        private SchemaObject Schema { get; }

        private bool ReadOnly { get; }

        public static PropertyObject Create(Core.Model.Property property)
            => new PropertyObject(SchemaObject.Create(property.ModelType), property.IsReadOnly);

        private PropertyObject(SchemaObject schema, bool readOnly)
        {
            Schema = schema;
            ReadOnly = readOnly;
        }

        public override IEnumerable<Property> GetProperties()
        {
            foreach (var p in Schema.GetProperties())
            {
                yield return p;
            }
            if (ReadOnly == true)
            {
                yield return Json.Property("readOnly", ReadOnly);
            }
        }
    }
}
