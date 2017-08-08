using AutoRest.Core.Model;
using AutoRest.Php.JsonBuilder;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Php.SwaggerBuilder
{
    /// <summary>
    /// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#pathsObject
    /// </summary>
    public static class PathsObject
    {
        public static Object<Object<OperationObject>> Create(IEnumerable<Method> methods)            
            => Json.Object(methods
                .GroupBy(m => m.Url)
                .Select(g => Json.Property(
                    g.Key,
                    PathItemObject.Create(g))));
    }
}
