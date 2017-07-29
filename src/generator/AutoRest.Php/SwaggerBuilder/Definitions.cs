using AutoRest.Core.Model;
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
        public static IEnumerable<KeyValuePair<string, Schema>> CreateSwaggerDefinitions(
            this IEnumerable<CompositeType> modelTypes)
            => modelTypes.Select(type => Extensions.KeyValue(
                    type.SerializedName.FixedValue,
                    Schema.CreateDefinition(type)));

        public static Array ToPhp(this IEnumerable<KeyValuePair<string, Schema>> definitions)
            => PHP.CreateArray(definitions.Select(p => PHP.KeyValue(p.Key, p.Value.ToPhp())));
    }
}
