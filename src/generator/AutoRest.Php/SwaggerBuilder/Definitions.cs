using AutoRest.Core.Model;
using AutoRest.Php.JsonBuilder;
using AutoRest.Php.PhpBuilder;
using AutoRest.Php.PhpBuilder.Expressions;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Php.SwaggerBuilder
{
    /// <summary>
    /// https://swagger.io/specification/#definitions-object-100
    /// </summary>
    public static class Definitions
    {
        public static Object<Schema> Create(
            IEnumerable<CompositeType> modelTypes)
            => Json.Object(modelTypes.Select(type => Extensions.KeyValue(
                type.SerializedName.FixedValue,
                Schema.CreateDefinition(type))));

        //public static Array ToPhp(IEnumerable<KeyValuePair<string, Schema>> definitions)
        //    => PHP.CreateArray(definitions.Select(p => PHP.KeyValue(p.Key, PHP.FromJson(p.Value))));
    }
}
