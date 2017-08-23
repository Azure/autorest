using AutoRest.Core.Model;
using AutoRest.Php.JsonBuilder;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Php.SwaggerBuilder
{
    /// <summary>
    /// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#pathItemObject
    /// </summary>
    public static class PathItemObject
    {
        public static Object<OperationObject> Create(IEnumerable<Method> methods)
            => Json.Object(methods.Select(m => Json.Property(
                m.HttpMethod.ToString().ToLower(),
                OperationObject.Create(m))));
    }
}
