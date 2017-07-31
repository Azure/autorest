using AutoRest.Core.Model;
using AutoRest.Php.JsonBuilder;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Php.SwaggerBuilder
{
    /// <summary>
    /// https://swagger.io/specification/#definitions-object-100
    /// </summary>
    public static class DefinitionsObject
    {
        public static Object<SchemaObject> Create(IEnumerable<CompositeType> modelTypes)
            => Json.Object(modelTypes.Select(type => Json.Property(
                type.SerializedName.FixedValue,
                SchemaObject.CreateDefinition(type))));
    }
}
